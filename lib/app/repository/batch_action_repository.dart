import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class BatchOperationsRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  // Upgrade batch stage (e.g., from starter to grower)
  Future<ApiResponse<BatchResponseModel>> upgradeBatchStage({
    required String batchId,
    required String newStage,
  }) async {
    try {
      log("Upgrading batch $batchId to stage: $newStage");

      final updateData = {
        'stage': newStage,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final response = await _firebaseClient.postDocument<BatchResponseModel>(
        collectionPath: FirebasePath.batches,
        documentId: batchId,
        data: updateData,
        responseType: (json) =>
            BatchResponseModel.fromJson(json, batchId: batchId),
      );

      if (response.status == ApiStatus.SUCCESS) {
        log("Successfully upgraded batch stage");
      } else {
        log("Failed to upgrade batch stage: ${response.message}");
      }

      return response;
    } catch (e) {
      log("Error in upgradeBatchStage: $e");
      return ApiResponse.error("Failed to upgrade batch stage: $e");
    }
  }

  // Retire a batch
  Future<ApiResponse<BatchResponseModel>> retireBatch({
    required String batchId,
    required String retireDate,
    String? notes,
  }) async {
    try {
      log("Retiring batch $batchId on date: $retireDate");

      final updateData = {
        'isActive': false,
        'retireDate': retireDate,
      };

      final response = await _firebaseClient.postDocument<BatchResponseModel>(
        collectionPath: FirebasePath.batches,
        documentId: batchId,
        data: updateData,
        responseType: (json) =>
            BatchResponseModel.fromJson(json, batchId: batchId),
      );

      if (response.status == ApiStatus.SUCCESS) {
        log("Successfully retired batch");
      } else {
        log("Failed to retire batch: ${response.message}");
      }

      return response;
    } catch (e) {
      log("Error in retireBatch: $e");
      return ApiResponse.error("Failed to retire batch: $e");
    }
  }

  // Get batch details with summary
  Future<ApiResponse<Map<String, dynamic>>> getBatchSummary(
      String batchId) async {
    try {
      log("Fetching summary for batch: $batchId");

      // Get batch basic info
      final batchResponse =
          await _firebaseClient.getDocument<BatchResponseModel>(
        collectionPath: FirebasePath.batches,
        documentId: batchId,
        responseType: (json) =>
            BatchResponseModel.fromJson(json, batchId: batchId),
      );

      if (batchResponse.status != ApiStatus.SUCCESS) {
        return ApiResponse.error("Failed to fetch batch details");
      }

      final batch = batchResponse.response!;

      // Initialize summary data
      Map<String, dynamic> summary = {
        'batch': batch,
        'eggProduction': {
          'totalEggs': 0,
          'normalEggs': 0,
          'crackedEggs': 0,
        },
        'feedConsumption': {
          'totalFeed': 0.0,
          'byType': {},
        },
        'mortality': {
          'total': batch.totalDeath,
          'byCause': {},
        },
        'vaccinations': {
          'completed': 0,
          'pending': 0,
        },
      };

      // Get all related data in parallel
      await Future.wait([
        // Fetch egg collections
        _firebaseClient
            .getCollection<Map<String, dynamic>>(
          collectionPath: FirebasePath.eggCollections,
          responseType: (json) => json,
          queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        )
            .then((response) {
          if (response.status == ApiStatus.SUCCESS) {
            for (var doc in response.response ?? []) {
              final total =
                  (doc['totalCrates'] * 30) + (doc['remainingEggs'] ?? 0);
              summary['eggProduction']['totalEggs'] += total;
              if (doc['eggCategory'] == 'normal') {
                summary['eggProduction']['normalEggs'] += total;
              } else {
                summary['eggProduction']['crackedEggs'] += total;
              }
            }
          }
        }),

        // Fetch feed consumption
        _firebaseClient
            .getCollection<Map<String, dynamic>>(
          collectionPath: FirebasePath.feedConsumption,
          responseType: (json) => json,
          queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        )
            .then((response) {
          if (response.status == ApiStatus.SUCCESS) {
            for (var doc in response.response ?? []) {
              final quantity = doc['quantityKg'] ?? 0.0;
              final type = doc['feedType'];
              summary['feedConsumption']['totalFeed'] += quantity;
              summary['feedConsumption']['byType'][type] =
                  (summary['feedConsumption']['byType'][type] ?? 0.0) +
                      quantity;
            }
          }
        }),

        // Fetch mortality data
        _firebaseClient
            .getCollection<Map<String, dynamic>>(
          collectionPath: FirebasePath.flockDeaths,
          responseType: (json) => json,
          queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        )
            .then((response) {
          if (response.status == ApiStatus.SUCCESS) {
            for (var doc in response.response ?? []) {
              final cause = doc['cause'];
              final count = doc['deathCount'] ?? 0;
              summary['mortality']['byCause'][cause] =
                  (summary['mortality']['byCause'][cause] ?? 0) + count;
            }
          }
        }),

        // Fetch vaccination data
        _firebaseClient
            .getCollection<Map<String, dynamic>>(
          collectionPath: FirebasePath.myVaccines,
          responseType: (json) => json,
          queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        )
            .then((response) {
          if (response.status == ApiStatus.SUCCESS) {
            for (var doc in response.response ?? []) {
              if (doc['isCompleted'] == true) {
                summary['vaccinations']['completed']++;
              } else {
                summary['vaccinations']['pending']++;
              }
            }
          }
        }),
      ]);

      return ApiResponse.completed(summary);
    } catch (e) {
      log("Error in getBatchSummary: $e");
      return ApiResponse.error("Failed to fetch batch summary: $e");
    }
  }
}
