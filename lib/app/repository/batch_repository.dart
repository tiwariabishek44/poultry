import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class BatchRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  Future<ApiResponse<BatchResponseModel>> createBatch(
      Map<String, dynamic> batchData) async {
    try {
      log("Creating batch with data: $batchData");

      // Get document reference first to get the ID
      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.batches);

      // Add the document ID to the data
      batchData['batchId'] = docRef.id;

      final response = await _firebaseClient.postDocument<BatchResponseModel>(
        collectionPath: FirebasePath.batches,
        documentId: docRef.id, // Use the same ID
        data: batchData,
        responseType: (json) =>
            BatchResponseModel.fromJson(json, batchId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createBatch: $e");
      return ApiResponse.error("Failed to create batch: $e");
    }
  }

  // to fetch all batches
  Future<ApiResponse<List<BatchResponseModel>>> getAllBatches(
      String adminId) async {
    try {
      log("Fetching batches for admin: $adminId");

      final response = await _firebaseClient.getCollection<BatchResponseModel>(
          collectionPath: FirebasePath.batches,
          responseType: (json) => BatchResponseModel.fromJson(json),
          queryBuilder: (query) => query
              .where('adminId', isEqualTo: adminId)
              .where('isActive', isEqualTo: true));

      return response;
    } catch (e) {
      log("Error in getAllBatches: $e");
      return ApiResponse.error("Failed to fetch batches: $e");
    }
  }
}
