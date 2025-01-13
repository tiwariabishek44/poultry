import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class FlockDeathRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<FlockDeathModel>> recordFlockDeath({
    required String batchId,
    required String adminId,
    required int deathCount,
    required String cause,
    String? notes,
  }) async {
    try {
      log("Recording flock death for batch: $batchId");

      // Get document reference for the new death record
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.flockDeaths,
      );

      // Prepare death record data
      final deathData = FlockDeathModel(
        deathId: docRef.id,
        batchId: batchId,
        adminId: adminId,
        deathCount: deathCount,
        cause: cause,
        date: NepaliDateTime.now().toIso8601String(),
        notes: notes,
        yearMonth: NepaliDateTime.now().toIso8601String().substring(0, 7),
      ).toJson();

      // Prepare batch update data
      final batchUpdate = {
        'totalDeath': FieldValue.increment(deathCount),
        'currentFlockCount': FieldValue.increment(-deathCount),
      };

      // Use cross-collection update with proper type
      return await _firebaseClient.updateRelatedDocuments<FlockDeathModel>(
        primaryCollection: FirebasePath.flockDeaths,
        primaryId: docRef.id,
        primaryUpdate: deathData,
        relatedCollection: FirebasePath.batches,
        relatedId: batchId,
        relatedUpdate: batchUpdate,
        responseType: (json) =>
            FlockDeathModel.fromJson(json, deathId: docRef.id),
      );
    } catch (e) {
      log("Error recording flock death: $e");
      return ApiResponse.error("Failed to record flock death: $e");
    }
  }
}
