// dashboard_controller.dart
import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/batch_repository.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';

class ActiveBatchCardController extends GetxController {
  static ActiveBatchCardController get instance => Get.find();

  final _batchRepository = BatchRepository();
  final _loginController = Get.find<LoginController>();
  final _batchStreamController = BatchStreamController.instance;
  final _firestore = FirebaseFirestore.instance;

  final batches = <BatchResponseModel>[].obs;
  final batchStats = <String, Map<String, dynamic>>{}.obs;
  final isLoading = false.obs;
  final isStatsLoading = false.obs;
  final numberFormat = NumberFormat("#,##,###");

  // Add stream subscriptions to listen for real-time updates
  List<StreamSubscription<QuerySnapshot>>? _statsSubscriptions;

  @override
  void onInit() {
    super.onInit();
    fetchBatches().then((_) {
      _setupStatsListeners();
    });
    ever(_batchStreamController.batchStream, (_) => _refreshBatchesAndStats());
  }

  @override
  void onClose() {
    _cancelStatsSubscriptions();
    super.onClose();
  }

  void _cancelStatsSubscriptions() {
    _statsSubscriptions?.forEach((subscription) => subscription.cancel());
    _statsSubscriptions = null;
  }

  void _setupStatsListeners() {
    _cancelStatsSubscriptions();
    _statsSubscriptions = [];

    final today = NepaliDateTime.now();
    final yearMonth = '${today.year}-${today.month.toString().padLeft(2, '0')}';

    for (var batch in batches) {
      if (batch.batchId == null) continue;

      final batchId = batch.batchId!;

      // Initialize stats for this batch
      if (!batchStats.containsKey(batchId)) {
        batchStats[batchId] = {
          'totalEggs': 0,
          'totalFeed': 0.0,
          'totalDeaths': 0,
        };
      }

      // Listen to egg production changes
      _statsSubscriptions?.add(
        _firestore
            .collection(FirebasePath.eggCollections)
            .where('batchId', isEqualTo: batchId)
            .where('yearMonth', isEqualTo: yearMonth)
            .snapshots()
            .listen((snapshot) {
          int totalEggs = 0;
          for (var doc in snapshot.docs) {
            final crates = (doc.data()['totalCrates'] as num?)?.toInt() ?? 0;
            final remaining =
                (doc.data()['remainingEggs'] as num?)?.toInt() ?? 0;
            totalEggs += (crates * 30) + remaining;
          }
          batchStats[batchId]?['totalEggs'] = totalEggs;
          batchStats.refresh();
        }),
      );

      // Listen to feed consumption changes
      _statsSubscriptions?.add(
        _firestore
            .collection(FirebasePath.feedConsumption)
            .where('batchId', isEqualTo: batchId)
            .where('yearMonth', isEqualTo: yearMonth)
            .snapshots()
            .listen((snapshot) {
          double totalFeed = 0;
          for (var doc in snapshot.docs) {
            totalFeed += (doc.data()['quantityKg'] as num?)?.toDouble() ?? 0;
          }
          batchStats[batchId]?['totalFeed'] = totalFeed;
          batchStats.refresh();
        }),
      );

      // Listen to death count changes
      _statsSubscriptions?.add(
        _firestore
            .collection(FirebasePath.flockDeaths)
            .where('batchId', isEqualTo: batchId)
            .where('yearMonth', isEqualTo: yearMonth)
            .snapshots()
            .listen((snapshot) {
          int totalDeaths = 0;
          for (var doc in snapshot.docs) {
            totalDeaths += (doc.data()['deathCount'] as num?)?.toInt() ?? 0;
          }
          batchStats[batchId]?['totalDeaths'] = totalDeaths;
          batchStats.refresh();
        }),
      );
    }
  }

  Future<void> _refreshBatchesAndStats() async {
    await fetchBatches();
    _setupStatsListeners();
  }

  Future<void> fetchBatches() async {
    isLoading.value = true;
    try {
      final adminId = _loginController.adminUid;
      if (adminId != null) {
        final response = await _batchRepository.getAllBatches(adminId);
        if (response.status == ApiStatus.SUCCESS && response.response != null) {
          batches.value = response.response!;
        }
      }
    } catch (e) {
      print('Error fetching batches: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class BatchStreamController extends GetxController {
  static BatchStreamController get instance => Get.put(BatchStreamController());
  final batchStream = false.obs;

  void notifyBatchUpdate() {
    batchStream.toggle();
  }
}
