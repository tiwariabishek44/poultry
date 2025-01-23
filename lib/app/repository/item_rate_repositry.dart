// Repository
import 'dart:developer';

import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/item_rate_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class FeedRateRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<ItemsRateResponseModel>> createFeedRate(
      Map<String, dynamic> rateData) async {
    try {
      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.itemRates);

      rateData['rateId'] = docRef.id;

      return await _firebaseClient.postDocument<ItemsRateResponseModel>(
        collectionPath: FirebasePath.itemRates,
        documentId: docRef.id,
        data: rateData,
        responseType: (json) =>
            ItemsRateResponseModel.fromJson(json, rateId: docRef.id),
      );
    } catch (e) {
      log("Error in createFeedRate: $e");
      return ApiResponse.error("Failed to create feed rate: $e");
    }
  }

  Future<ApiResponse<ItemsRateResponseModel>> updateFeedRate(
      String rateId, Map<String, dynamic> rateData) async {
    try {
      return await _firebaseClient.postDocument<ItemsRateResponseModel>(
        collectionPath: FirebasePath.itemRates,
        documentId: rateId,
        data: rateData,
        responseType: (json) =>
            ItemsRateResponseModel.fromJson(json, rateId: rateId),
      );
    } catch (e) {
      return ApiResponse.error("Failed to update feed rate: $e");
    }
  }

  Future<ApiResponse<List<ItemsRateResponseModel>>> getFeedRates(
      String adminId) async {
    try {
      return await _firebaseClient.getCollection<ItemsRateResponseModel>(
        collectionPath: FirebasePath.itemRates,
        queryBuilder: (query) => query.where('adminId', isEqualTo: adminId),
        responseType: (json) => ItemsRateResponseModel.fromJson(json),
      );
    } catch (e) {
      return ApiResponse.error("Failed to fetch feed rates: $e");
    }
  }
}
