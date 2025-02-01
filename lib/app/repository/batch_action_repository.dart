import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class BatchOperationsRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

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
      };

      final response = await _firebaseClient.updateDocument<BatchResponseModel>(
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
}
