// import 'dart:async';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:nepali_date_picker/nepali_date_picker.dart';
// import 'package:poultry/app/config/firebase_path.dart';
// import 'package:poultry/app/model/batch_response_model.dart';
// import 'package:poultry/app/modules/login%20/login_controller.dart';

// class ActiveBatchStreamController extends GetxController {
//   static ActiveBatchStreamController get instance => Get.find();

//   final _firestore = FirebaseFirestore.instance;
//   final _loginController = Get.find<LoginController>();
//   final _numberFormat = NumberFormat("#,##,###.#");

//   // Stream controllers
//   final _batchesController =
//       StreamController<List<BatchResponseModel>>.broadcast();
//   final _statsController =
//       StreamController<Map<String, Map<String, dynamic>>>.broadcast();

//   // Public streams
//   Stream<List<BatchResponseModel>> get batches => _batchesController.stream;
//   Stream<Map<String, Map<String, dynamic>>> get batchStats =>
//       _statsController.stream;

//   // Store subscriptions for cleanup
//   List<StreamSubscription> _subscriptions = [];

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeStreams();
//   }

//   // 5. Add proper disposal
//   void _disposeSubscriptions() {
//     for (var subscription in _subscriptions) {
//       subscription.cancel();
//     }
//     _subscriptions.clear();
//   }

//   void refreshStreams() {
//     // Cancel existing subscriptions
//     _disposeSubscriptions();
//     _initializeStreams();
//   }

//   void _initializeStreams() {
//     final adminId = _loginController.adminUid;

//     if (adminId == null) {
//       log("Admin ID not found");
//       _batchesController.add([]);
//       _statsController.add({});
//       return;
//     }

//     // Listen to active batches
//     final batchSubscription = _firestore
//         .collection(FirebasePath.batches)
//         .where('adminId', isEqualTo: adminId)
//         .where('isActive', isEqualTo: true)
//         .snapshots()
//         .listen((snapshot) {
//       try {
//         final batches = snapshot.docs
//             .map((doc) =>
//                 BatchResponseModel.fromJson(doc.data(), batchId: doc.id))
//             .toList();

//         _batchesController.add(batches);
//         _updateStatsForBatches(batches);
//       } catch (e) {
//         log("Error processing batch data: $e");
//         _batchesController.addError("Failed to process batch data");
//       }
//     }, onError: (error) {
//       log("Error in batch subscription: $error");
//       _batchesController.addError(error);
//     });

//     _subscriptions.add(batchSubscription);
//   }

//   void _updateStatsForBatches(List<BatchResponseModel> batches) {
//     final today = NepaliDateTime.now();
//     final yearMonth = '${today.year}-${today.month.toString().padLeft(2, '0')}';

//     // Cancel existing stat subscriptions
//     _subscriptions.forEach((sub) => sub.cancel());
//     _subscriptions = [];

//     final Map<String, Map<String, dynamic>> currentStats = {};

//     for (var batch in batches) {
//       if (batch.batchId == null) continue;

//       currentStats[batch.batchId!] = {
//         'totalEggs': 0,
//         'totalCrates': 0.0,
//         'remainingEggs': 0,
//         'totalFeed': 0.0,
//         'totalDeaths': 0,
//       };

//       // Listen to egg production with new calculation
//       final eggSubscription = _firestore
//           .collection(FirebasePath.eggCollections)
//           .where('batchId', isEqualTo: batch.batchId)
//           .where('yearMonth', isEqualTo: yearMonth)
//           .snapshots()
//           .listen((snapshot) {
//         try {
//           int totalEggs = 0;
//           int totalRemaining = 0;

//           for (var doc in snapshot.docs) {
//             // Calculate eggs from full crates
//             final crates = (doc.data()['totalCrates'] as num?)?.toInt() ?? 0;
//             totalEggs += crates * 30;

//             // Add remaining eggs
//             final remaining =
//                 (doc.data()['remainingEggs'] as num?)?.toInt() ?? 0;
//             totalRemaining += remaining;
//           }

//           // Add remaining eggs to total
//           totalEggs += totalRemaining;

//           // Calculate final crate statistics
//           final double totalCrates = totalEggs / 30;
//           final int finalRemaining = totalEggs % 30;

//           currentStats[batch.batchId!]?.addAll({
//             'totalEggs': totalEggs,
//             'totalCrates': totalCrates,
//             'remainingEggs': finalRemaining,
//           });

//           _statsController.add(Map.from(currentStats));
//         } catch (e) {
//           log("Error processing egg data: $e");
//         }
//       }, onError: (error) {
//         log("Error in egg subscription: $error");
//       });

//       // Listen to feed consumption
//       final feedSubscription = _firestore
//           .collection(FirebasePath.feedConsumption)
//           .where('batchId', isEqualTo: batch.batchId)
//           .where('yearMonth', isEqualTo: yearMonth)
//           .snapshots()
//           .listen((snapshot) {
//         try {
//           double totalFeed = 0;
//           for (var doc in snapshot.docs) {
//             totalFeed += (doc.data()['quantityKg'] as num?)?.toDouble() ?? 0;
//           }
//           currentStats[batch.batchId!]?['totalFeed'] = totalFeed;
//           _statsController.add(Map.from(currentStats));
//         } catch (e) {
//           log("Error processing feed data: $e");
//         }
//       }, onError: (error) {
//         log("Error in feed subscription: $error");
//       });

//       // Listen to death records
//       final deathSubscription = _firestore
//           .collection(FirebasePath.flockDeaths)
//           .where('batchId', isEqualTo: batch.batchId)
//           .where('yearMonth', isEqualTo: yearMonth)
//           .snapshots()
//           .listen((snapshot) {
//         try {
//           int totalDeaths = 0;
//           for (var doc in snapshot.docs) {
//             totalDeaths += (doc.data()['deathCount'] as num?)?.toInt() ?? 0;
//           }
//           currentStats[batch.batchId!]?['totalDeaths'] = totalDeaths;
//           _statsController.add(Map.from(currentStats));
//         } catch (e) {
//           log("Error processing death data: $e");
//         }
//       }, onError: (error) {
//         log("Error in death subscription: $error");
//       });

//       _subscriptions
//           .addAll([eggSubscription, feedSubscription, deathSubscription]);
//     }

//     // Initial stats update
//     _statsController.add(currentStats);
//   }

//   // Helper method for general number formatting
//   String formatNumber(num value) => _numberFormat.format(value);

//   @override
//   void onClose() {
//     for (var subscription in _subscriptions) {
//       subscription.cancel();
//     }
//     _batchesController.close();
//     _statsController.close();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';

class ActiveBatchStreamController extends GetxController {
  static ActiveBatchStreamController get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;
  final _loginController = Get.find<LoginController>();
  final _numberFormat = NumberFormat("#,##,###.#");

  final _batchesController =
      StreamController<List<BatchResponseModel>>.broadcast();
  final _statsController =
      StreamController<Map<String, Map<String, dynamic>>>.broadcast();

  Stream<List<BatchResponseModel>> get batches => _batchesController.stream;
  Stream<Map<String, Map<String, dynamic>>> get batchStats =>
      _statsController.stream;

  List<StreamSubscription> _subscriptions = [];

  @override
  void onInit() {
    super.onInit();
    _initializeStreams();
  }

  void _disposeSubscriptions() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  void refreshStreams() {
    _disposeSubscriptions();
    _initializeStreams();
  }

  void _initializeStreams() {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      log("Admin ID not found");
      _batchesController.add([]);
      _statsController.add({});
      return;
    }

    final batchSubscription = _firestore
        .collection(FirebasePath.batches)
        .where('adminId', isEqualTo: adminId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      try {
        final batches = snapshot.docs
            .map((doc) =>
                BatchResponseModel.fromJson(doc.data(), batchId: doc.id))
            .toList();

        _batchesController.add(batches);
        _updateStatsForBatches(batches);
      } catch (e) {
        log("Error processing batch data: $e");
        _batchesController.addError("Failed to process batch data");
      }
    }, onError: (error) {
      log("Error in batch subscription: $error");
      _batchesController.addError(error);
    });

    _subscriptions.add(batchSubscription);
  }

  void _updateStatsForBatches(List<BatchResponseModel> batches) {
    final today = NepaliDateTime.now();
    final yearMonth = '${today.year}-${today.month.toString().padLeft(2, '0')}';

    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions = [];

    final Map<String, Map<String, dynamic>> currentStats = {};

    for (var batch in batches) {
      if (batch.batchId == null) continue;

      currentStats[batch.batchId!] = {
        'totalEggs': 0,
        'totalCrates': 0.0,
        'remainingEggs': 0,
        'totalFeed': 0.0,
        'totalDeaths': 0,
        // Adding category-wise totals
        'totalLargePlusEggs': 0,
        'totalLargeEggs': 0,
        'totalMediumEggs': 0,
        'totalSmallEggs': 0,
        'totalCrackEggs': 0,
        'totalWasteEggs': 0,
      };

      // Listen to egg production with new calculation
      final eggSubscription = _firestore
          .collection(FirebasePath.eggCollections)
          .where('batchId', isEqualTo: batch.batchId)
          .where('yearMonth', isEqualTo: yearMonth)
          .snapshots()
          .listen((snapshot) {
        try {
          int totalLargePlusEggs = 0;
          int totalLargeEggs = 0;
          int totalMediumEggs = 0;
          int totalSmallEggs = 0;
          int totalCrackEggs = 0;
          int totalWasteEggs = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            totalLargePlusEggs +=
                (data['totalLargePlusEggs'] as num?)?.toInt() ?? 0;
            totalLargeEggs += (data['totalLargeEggs'] as num?)?.toInt() ?? 0;
            totalMediumEggs += (data['totalMediumEggs'] as num?)?.toInt() ?? 0;
            totalSmallEggs += (data['totalSmallEggs'] as num?)?.toInt() ?? 0;
            totalCrackEggs += (data['totalCrackEggs'] as num?)?.toInt() ?? 0;
            totalWasteEggs += (data['totalWasteEggs'] as num?)?.toInt() ?? 0;
          }

          final totalEggs = totalLargePlusEggs +
              totalLargeEggs +
              totalMediumEggs +
              totalSmallEggs +
              totalCrackEggs +
              totalWasteEggs;

          final double totalCrates = totalEggs / 30;
          final int finalRemaining = totalEggs % 30;

          currentStats[batch.batchId!]?.addAll({
            'totalEggs': totalEggs,
            'totalCrates': totalCrates,
            'remainingEggs': finalRemaining,
            'totalLargePlusEggs': totalLargePlusEggs,
            'totalLargeEggs': totalLargeEggs,
            'totalMediumEggs': totalMediumEggs,
            'totalSmallEggs': totalSmallEggs,
            'totalCrackEggs': totalCrackEggs,
            'totalWasteEggs': totalWasteEggs,
          });

          _statsController.add(Map.from(currentStats));
        } catch (e) {
          log("Error processing egg data: $e");
        }
      }, onError: (error) {
        log("Error in egg subscription: $error");
      });

      // Feed consumption subscription remains the same
      final feedSubscription = _firestore
          .collection(FirebasePath.feedConsumption)
          .where('batchId', isEqualTo: batch.batchId)
          .where('yearMonth', isEqualTo: yearMonth)
          .snapshots()
          .listen((snapshot) {
        try {
          double totalFeed = 0;
          for (var doc in snapshot.docs) {
            totalFeed += (doc.data()['quantityKg'] as num?)?.toDouble() ?? 0;
          }
          currentStats[batch.batchId!]?['totalFeed'] = totalFeed;
          _statsController.add(Map.from(currentStats));
        } catch (e) {
          log("Error processing feed data: $e");
        }
      });

      // Death records subscription remains the same
      final deathSubscription = _firestore
          .collection(FirebasePath.flockDeaths)
          .where('batchId', isEqualTo: batch.batchId)
          .where('yearMonth', isEqualTo: yearMonth)
          .snapshots()
          .listen((snapshot) {
        try {
          int totalDeaths = 0;
          for (var doc in snapshot.docs) {
            totalDeaths += (doc.data()['deathCount'] as num?)?.toInt() ?? 0;
          }
          currentStats[batch.batchId!]?['totalDeaths'] = totalDeaths;
          _statsController.add(Map.from(currentStats));
        } catch (e) {
          log("Error processing death data: $e");
        }
      });

      _subscriptions
          .addAll([eggSubscription, feedSubscription, deathSubscription]);
    }

    _statsController.add(currentStats);
  }

  String formatNumber(num value) => _numberFormat.format(value);

  @override
  void onClose() {
    _disposeSubscriptions();
    _batchesController.close();
    _statsController.close();
    super.onClose();
  }
}
