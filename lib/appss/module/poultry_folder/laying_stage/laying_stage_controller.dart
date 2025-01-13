// Count data model
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class CountData {
  int totalPieces = 0; // Total eggs in pieces
  String displayCrates = '0.0'; // Formatted crate count with decimal
  int fullCrates = 0; // Number of full crates
  int remainingEggs = 0; // Remaining eggs less than a crate
}

class LayingStageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginController = Get.find<PoultryLoginController>();
  final loading = false.obs;
  // Observable variables with default values
  final RxDouble monthlyFeed = 0.0.obs;
  final RxInt monthlyMortality = 0.obs;

  final batchId = ''.obs;
  Stream<Map<String, CountData>> getEggCountStream(
    String collection,
    String batchId, {
    String? eggtype,
    required bool monthFilter,
    required monthYear,
  }) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value({});

    var query = _firestore
        .collection(collection)
        .where('batchId', isEqualTo: batchId)
        .where('adminUid', isEqualTo: adminUid);

    if (monthFilter) {
      query = query.where(
        'yearMonth',
        isEqualTo: monthYear,
      );
    }
    if (eggtype != null && eggtype.isNotEmpty) {
      query = query.where(
        'eggType',
        isEqualTo: eggtype,
      );
    }

    return query.snapshots().map((snapshot) {
      Map<String, CountData> counts = {
        'small': CountData(),
        'medium': CountData(),
        'large': CountData(),
        'extra large': CountData(),
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['eggCategory'].toString().toLowerCase();
        final crates = data['crates'] as int;
        final remaining = data['remainingEggs'] as int;

        if (counts.containsKey(category)) {
          final totalPieces = (crates * 30) + remaining;
          counts[category]!.totalPieces += totalPieces;

          // Calculate full crates and remaining
          final totalCrates = counts[category]!.totalPieces ~/ 30;
          final remainingEggs = counts[category]!.totalPieces % 30;

          counts[category]!.fullCrates = totalCrates;
          counts[category]!.remainingEggs = remainingEggs;
          counts[category]!.displayCrates =
              formatCrateCount(counts[category]!.totalPieces);
        }
      }
      return counts;
    });
  }

  String formatCrateCount(int totalEggs) {
    double crates = totalEggs / 30;

    return crates.toStringAsFixed(1);
  }

  // Fetch feed consumption data

  Stream<double> getFeedConsumptionStream(String batchId, String stage,
      {required String yearmonth, required bool monthFilter}) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value(0.0);

    var query = _firestore
        .collection('feedConsumptions')
        .where('adminUid', isEqualTo: adminUid)
        .where('batchId', isEqualTo: batchId)
        .where('stage', isEqualTo: stage);

    if (monthFilter) {
      query = query.where(
        'yearMonth',
        isEqualTo: yearmonth,
      );
    }

    return query.snapshots().map((snapshot) {
      double totalFeed = 0.0;
      for (var doc in snapshot.docs) {
        totalFeed += (doc['totalFeed'] as num).toDouble();
      }
      monthlyFeed.value = totalFeed; // Update the observable
      return totalFeed;
    });
  }

  Stream<int> getMortalityStream(String batchId, String stage,
      {required bool monthFilter, required String yearmonth}) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value(0);

    var query = _firestore
        .collection('deaths')
        .where('adminUid', isEqualTo: adminUid)
        .where('batchId', isEqualTo: batchId)
        .where('stage', isEqualTo: stage);

    if (monthFilter) {
      query = query.where(
        'yearMonth',
        isEqualTo: yearmonth,
      );
    }

    return query.snapshots().map((snapshot) {
      int totalMortality = 0;
      for (var doc in snapshot.docs) {
        totalMortality += (doc['deathCount'] as num).toInt();
      }
      monthlyMortality.value = totalMortality;
      return totalMortality;
    });
  }

  // to get the produciton percentage
  Stream<double> getProductionPercentageStream(
      String batchId, int currentFlock) {
    return _firestore
        .collection('eggCollections')
        .where('batchId', isEqualTo: batchId)
        .where('adminUid', isEqualTo: loginController.adminData.value?.uid)
        .where('yearMonth',
            isEqualTo: NepaliDateTime.now().toIso8601String().substring(0, 7))
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 0.0;

      // Group efficiencies by date
      Map<String, double> dailyEfficiencies = {};

      // Sum efficiencies for each date
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final collectedAt = data['collectedAt'] as String;
        final efficiency = double.parse(data['efficiency'] as String);

        // Add efficiency to the date's total
        dailyEfficiencies[collectedAt] =
            (dailyEfficiencies[collectedAt] ?? 0.0) + efficiency;
      }

      // Calculate average of daily totals
      double totalEfficiency =
          dailyEfficiencies.values.fold(0.0, (sum, value) => sum + value);
      return (totalEfficiency / dailyEfficiencies.length) * 100;
    });
  }
}
