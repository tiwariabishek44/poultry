// make the repository for the feed consumption
import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/service/api_client.dart';

class FeedConsumptionRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<FeedConsumptionResponseModel>> createFeedConsumption(
      Map<String, dynamic> consumptionData) async {
    try {
      log("Creating feed consumption with data: $consumptionData");

      // Get document reference first to get the ID
      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.feedConsumption);

      // Add the document ID to the data
      consumptionData['consumptionId'] = docRef.id;

      final response =
          await _firebaseClient.postDocument<FeedConsumptionResponseModel>(
        collectionPath: FirebasePath.feedConsumption,
        documentId: docRef.id,
        data: consumptionData,
        responseType: (json) => FeedConsumptionResponseModel.fromJson(json,
            consumptionId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createFeedConsumption: $e");
      return ApiResponse.error("Failed to create feed consumption: $e");
    }
  }

  // in feed_consumption_repository.dart
  Future<ApiResponse<List<FeedConsumptionResponseModel>>>
      getFeedConsumptionByMonth(String yearMonth) async {
    try {
      log("Fetching feed consumption for: $yearMonth");

      final response =
          await _firebaseClient.getCollection<FeedConsumptionResponseModel>(
        collectionPath: FirebasePath.feedConsumption,
        responseType: (json) => FeedConsumptionResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('yearMonth', isEqualTo: yearMonth),
      );

      return response;
    } catch (e) {
      log("Error in getFeedConsumptionByMonth: $e");
      return ApiResponse.error("Failed to fetch feed consumption: $e");
    }
  }
}
