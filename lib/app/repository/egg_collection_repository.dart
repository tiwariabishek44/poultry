import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/service/api_client.dart';

class EggCollectionRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<EggCollectionResponseModel>> createEggCollection(
      Map<String, dynamic> collectionData) async {
    try {
      log("Creating egg collection with data: $collectionData");

      // Get document reference first to get the ID
      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath:
              FirebasePath.eggCollections // We should add this to FirebasePath
          );

      // Add the document ID to the data
      collectionData['collectionId'] = docRef.id;

      final response =
          await _firebaseClient.postDocument<EggCollectionResponseModel>(
        collectionPath: FirebasePath.eggCollections,
        documentId: docRef.id,
        data: collectionData,
        responseType: (json) =>
            EggCollectionResponseModel.fromJson(json, collectionId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createEggCollection: $e");
      return ApiResponse.error("Failed to create egg collection: $e");
    }
  }

  // Add this new method
  Stream<List<EggCollectionResponseModel>> streamEggCollectionsByYearMonth(
      String adminId, String yearMonth) {
    return _firebaseClient
        .streamCollection(
          collectionPath: FirebasePath.eggCollections,
          queryBuilder: (query) => query
              .where('adminId', isEqualTo: adminId)
              .where('yearMonth', isEqualTo: yearMonth),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => EggCollectionResponseModel.fromJson(
                doc.data() as Map<String, dynamic>,
                collectionId: doc.id))
            .toList());
  }
}
