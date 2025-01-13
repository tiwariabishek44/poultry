// laying_stage_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';

class LayingStgController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  Stream<double> getFeedConsumptionStream({
    required String batchId,
    required String stage,
    required bool monthFilter,
  }) {
    final today = NepaliDateTime.now();
    final yearMonth = '${today.year}-${today.month.toString().padLeft(2, '0')}';

    var query = _firestore
        .collection(FirebasePath.feedConsumption)
        .where('batchId', isEqualTo: batchId);

    if (monthFilter) {
      query = query.where('yearMonth', isEqualTo: yearMonth);
    }

    return query.snapshots().map((snapshot) {
      double totalFeed = 0.0;
      for (var doc in snapshot.docs) {
        totalFeed += (doc.data()['quantityKg'] as num?)?.toDouble() ?? 0.0;
      }

      return totalFeed;
    });
  }

  Stream<int> getMortalityStream({
    required String yearmonth,
    required String batchId,
    required String stage,
    required bool monthFilter,
  }) {
    var query = _firestore
        .collection(FirebasePath.flockDeaths)
        .where('batchId', isEqualTo: batchId);

    if (monthFilter) {
      query = query.where('yearMonth', isEqualTo: yearmonth);
    }

    return query.snapshots().map((snapshot) {
      int totalDeaths = 0;
      for (var doc in snapshot.docs) {
        totalDeaths += (doc.data()['deathCount'] as num?)?.toInt() ?? 0;
      }
      return totalDeaths;
    });
  }

  Stream<double> getProductionPercentageStream(String batchId) {
    final today = NepaliDateTime.now();
    final yearMonth = '${today.year}-${today.month.toString().padLeft(2, '0')}';

    return _firestore
        .collection(FirebasePath.eggCollections)
        .where('batchId', isEqualTo: batchId)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 0.0;

      // Group collections by date to handle multiple collections per day
      Map<String, List<DocumentSnapshot<Map<String, dynamic>>>>
          collectionsByDate = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data == null) continue;

        String? date = data['collectionDate'] as String?;
        if (date == null) continue;

        if (!collectionsByDate.containsKey(date)) {
          collectionsByDate[date] = [];
        }
        collectionsByDate[date]?.add(doc);
      }

      double totalProductionPercentage = 0.0;
      int numberOfDays = collectionsByDate.length;

      // Calculate daily production percentages
      collectionsByDate.forEach((date, dailyCollections) {
        // Get the hen count for this day from first collection
        final firstCollectionData = dailyCollections.first.data();
        if (firstCollectionData == null) return;

        final dailyHenCount = firstCollectionData['henCount'] as int? ?? 0;
        if (dailyHenCount == 0) return; // Skip days with no hens

        // Calculate total eggs for the day
        int dailyEggs = 0;
        for (var collection in dailyCollections) {
          final data = collection.data();
          if (data == null) continue;

          final crates = (data['totalCrates'] as num?)?.toInt() ?? 0;
          final remaining = (data['remainingEggs'] as num?)?.toInt() ?? 0;
          dailyEggs += (crates * 30 + remaining);
        }

        // Calculate daily production percentage
        double dailyPercentage = (dailyEggs / dailyHenCount) * 100;
        totalProductionPercentage += dailyPercentage;
      });

      // Calculate average production percentage
      double averageProductionPercentage =
          numberOfDays > 0 ? totalProductionPercentage / numberOfDays : 0.0;

      return averageProductionPercentage;
    });
  }
}

///////
///
///////
///
///////
///
///////
///
///////
///
///////
///////
///
///////
///
///////

// CountData model to represent the egg count structure
class CountData {
  int fullCrates;
  int remainingEggs;

  CountData({
    this.fullCrates = 0,
    this.remainingEggs = 0,
  });

  // Add the egg data to the CountData instance
  void addEggData(EggCollectionResponseModel data) {
    fullCrates += data.totalCrates;
    remainingEggs += data.remainingEggs;
  }

  // Helper to get the total egg count in the format of (crates + remaining eggs)
  String getFormattedEggCount() {
    return '$fullCrates crates + $remainingEggs Piece';
  }
}

class LayingStageAnalysisController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch egg collection data from Firebase
  Stream<Map<String, CountData>> getEggCountStream({
    required String monthYear,
    required String batchId,
  }) {
    // Reference to the specific path in the Firebase collection
    var eggCollectionRef = _firestore
        .collection(
            FirebasePath.eggCollections) // Your Firebase collection path
        .where('yearMonth', isEqualTo: monthYear) // Filtering by yearMonth
        .where('batchId', isEqualTo: batchId); // Filtering by batchId

    // Listen to changes in the collection for the specific batch and monthYear
    return eggCollectionRef.snapshots().map((snapshot) {
      // Initialize a map to store segregated data based on egg category
      Map<String, CountData> eggCounts = {
        'normal': CountData(),
        'crack': CountData(),
        'waste': CountData(),
      };

      // Iterate over the documents in the snapshot
      for (var doc in snapshot.docs) {
        // Convert the document data to the EggCollectionResponseModel
        var data = EggCollectionResponseModel.fromJson(doc.data(),
            collectionId: doc.id);

        // Check the egg category and add the data accordingly
        if (data.eggCategory == 'normal') {
          eggCounts['normal']?.addEggData(data);
        } else if (data.eggCategory == 'crack') {
          eggCounts['crack']?.addEggData(data);
        } else if (data.eggCategory == 'waste') {
          eggCounts['waste']?.addEggData(data);
        }
      }

      return eggCounts;
    });
  }

  // Method to get the feed consumption data stream from Firebase
  Stream<List<FeedConsumptionResponseModel>> getFeedConsumptionStream({
    required String monthYear,
    required String batchId,
  }) {
    return _firestore
        .collection(FirebasePath
            .feedConsumption) // Access the feed consumption collection
        .where('yearMonth', isEqualTo: monthYear) // Filter by yearMonth
        .where('batchId', isEqualTo: batchId) // Filter by batchId
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedConsumptionResponseModel.fromJson(doc.data(),
              consumptionId: doc.id))
          .toList();
    });
  }

  // Method to calculate total feed consumption for the given batch and month
  Stream<double> getTotalFeedConsumptionStream({
    required String monthYear,
    required String batchId,
  }) {
    return getFeedConsumptionStream(monthYear: monthYear, batchId: batchId)
        .map((feedConsumptions) {
      double totalConsumption = 0;

      // Sum up the total quantity of feed consumed
      feedConsumptions.forEach((consumption) {
        totalConsumption += consumption.quantityKg;
      });

      return totalConsumption;
    });
  }

// ------------- for the death count

  // Stream to get the total flock death for a specific batch and month-year
  Stream<int> getTotalFlockDeathStream({
    required String monthYear,
    required String batchId,
  }) {
    return _firestore
        .collection(FirebasePath.flockDeaths) // Your Firebase collection path
        .where('batchId', isEqualTo: batchId)
        .where('yearMonth',
            isEqualTo: monthYear) // Filter by the given monthYear
        .snapshots() // Get snapshots of the collection
        .map((snapshot) {
      // Calculate total death count by summing up the deathCount field
      int totalDeathCount = 0;
      for (var doc in snapshot.docs) {
        FlockDeathModel flockDeath =
            FlockDeathModel.fromJson(doc.data(), deathId: doc.id);
        totalDeathCount += flockDeath.deathCount;
      }
      return totalDeathCount; // Return the total death count
    });
  }
}
