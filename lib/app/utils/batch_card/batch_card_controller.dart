import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/model/expense_reposnse_model.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/model/purchase_repsonse_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/daily_weight_gain._repository.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class ActiveBatchStreamController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _loginController = Get.find<LoginController>();
  final _numberFormat = NumberFormat("#,##,###.#");

  // Main stream for active batches
  Stream<List<BatchResponseModel>> get activeBatches {
    return _firestore
        .collection(FirebasePath.batches)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => BatchResponseModel.fromJson(doc.data(), batchId: doc.id))
          .toList();
    });
  }

  // Stream for total costing (purchase + expense) filtered by active batch
  Stream<double> get totalCostStream {
    return activeBatches.switchMap((batches) {
      if (batches.isEmpty)
        return Stream.value(0.0); // Return 0 if no active batch

      final batchId = batches.first.batchId; // Get the current batch ID
      return rxdart.Rx.combineLatest2(
        _getTotalPurchasesStream(batchId!),
        _getTotalExpensesStream(batchId),
        (double totalPurchases, double totalExpenses) {
          return totalPurchases + totalExpenses;
        },
      );
    });
  }

  // Stream to calculate total purchases filtered by batchId
  Stream<double> _getTotalPurchasesStream(String batchId) {
    return _firestore
        .collection('purchases') // Replace with your actual collection name
        .where('batchId', isEqualTo: batchId)
        .snapshots()
        .map((snapshot) {
      double totalPurchases = 0.0;
      for (var doc in snapshot.docs) {
        final purchase =
            PurchaseResponseModel.fromJson(doc.data(), purchaseId: doc.id);
        totalPurchases += purchase
            .totalAmount; // Assuming totalAmount is already calculated in your model
      }
      return totalPurchases;
    });
  }

  // Stream to calculate total expenses filtered by batchId
  Stream<double> _getTotalExpensesStream(String batchId) {
    return _firestore
        .collection('expenses') // Replace with your actual collection name
        .where('batchId', isEqualTo: batchId)
        .snapshots()
        .map((snapshot) {
      double totalExpenses = 0.0;
      for (var doc in snapshot.docs) {
        final expense =
            ExpenseResponseModel.fromJson(doc.data(), expenseId: doc.id);
        totalExpenses += expense
            .amount; // Assuming amount is directly available in your model
      }
      return totalExpenses;
    });
  }

  Stream<Map<String, double>> get feedConsumptionByTypeStream {
    return activeBatches.switchMap((batches) {
      if (batches.isEmpty) {
        return Stream.value({'B-0': 0.0, 'B-1': 0.0, 'B-2': 0.0});
      }

      final batchId = batches.first.batchId;

      return _firestore
          .collection(FirebasePath.feedConsumption)
          .where('batchId', isEqualTo: batchId)
          .snapshots()
          .map((snapshot) {
        // Initialize a map to hold total weights for each feed type
        final feedTypeWeights = {
          'B-0': 0.0,
          'B-1': 0.0,
          'B-2': 0.0,
        };

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final feedConsumption = FeedConsumptionResponseModel.fromJson(data,
              consumptionId: doc.id);

          // Accumulate the weight based on the feed type
          if (feedTypeWeights.containsKey(feedConsumption.feedType)) {
            feedTypeWeights[feedConsumption.feedType] =
                (feedTypeWeights[feedConsumption.feedType] ?? 0) +
                    feedConsumption.quantityKg;
          }
        }

        // Return the map with total weights for each feed type
        return feedTypeWeights;
      });
    });
  }

  Stream<Map<String, dynamic>> get weightGainStream {
    return activeBatches.switchMap((batches) {
      if (batches.isEmpty)
        return Stream.value({
          'totalWeightGain': 0.0,
          'dailyAverageGain': 0.0,
          'thisWeekWeight': List.filled(7, {'date': '', 'weight': 0.0})
        });
      final batchId = batches.first.batchId;

      return _firestore
          .collection(FirebasePath.dailyWeightGain)
          .where('batchId', isEqualTo: batchId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty)
          return {
            'totalWeightGain': 0.0,
            'dailyAverageGain': 0.0,
            'thisWeekWeight': List.filled(7, {'date': '', 'weight': 0.0})
          };

        // Convert all documents to DailyWeightGainResponseModel
        final weightRecords = snapshot.docs
            .map((doc) => DailyWeightGainResponseModel.fromJson(doc.data(),
                weightGainId: doc.id))
            .toList();

        // Calculate total weight gain by summing all weight records
        double totalWeightGain = 0.0;
        for (var record in weightRecords) {
          totalWeightGain += record.weight;
        }

        // Calculate daily average gain
        double dailyAverageGain = totalWeightGain / weightRecords.length;

        // Calculate this week's weight
        final now = NepaliDateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));

        final weightMap = <String, double>{};
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final date = NepaliDateTime.parse(data['date']);
          if (date.isAfter(startOfWeek) &&
              date.isBefore(endOfWeek.add(Duration(days: 1)))) {
            weightMap[date.toIso8601String().split('T').first] =
                data['weight'].toDouble();
          }
        }

        final thisWeekWeight = List<Map<String, dynamic>>.generate(7, (index) {
          final date = startOfWeek
              .add(Duration(days: index))
              .toIso8601String()
              .split('T')
              .first;
          final weight = weightMap[date] ?? 0.0;
          return {'date': date, 'weight': weight};
        });

        return {
          'totalWeightGain': totalWeightGain / 1000,
          'dailyAverageGain': dailyAverageGain / 1000,
          'thisWeekWeight': thisWeekWeight
        };
      });
    });
  }

  // Mortality Rate Stream calculated from active batch
  Stream<double> get mortalityRateStream {
    return activeBatches.map((batches) {
      if (batches.isEmpty) return 0.0;
      final batch = batches.first;

      if (batch.initialFlockCount == 0) return 0.0;

      return ((batch.initialFlockCount - batch.currentFlockCount) /
              batch.initialFlockCount) *
          100;
    });
  }

  String formatNumber(num value) => _numberFormat.format(value);

  @override
  void onClose() {
    super.onClose();
  }
}
