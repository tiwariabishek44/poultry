import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/my_vaccine_reposnse.dart';
import 'package:poultry/app/service/api_client.dart';

class MyVaccineRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<MyVaccineResponseModel>> recordVaccination(
      Map<String, dynamic> vaccineData) async {
    try {
      log("Recording vaccination with data: $vaccineData");

      // Get document reference first to get the ID
      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.myVaccines);

      // Add the document ID to the data
      vaccineData['vaccineId'] = docRef.id;

      final response =
          await _firebaseClient.postDocument<MyVaccineResponseModel>(
        collectionPath: FirebasePath.myVaccines,
        documentId: docRef.id,
        data: vaccineData,
        responseType: (json) =>
            MyVaccineResponseModel.fromJson(json, vaccineId: docRef.id),
      );

      if (response.status == ApiStatus.SUCCESS) {
        log("Successfully recorded vaccination: ${response.response?.vaccineId}");
      } else {
        log("Failed to record vaccination: ${response.message}");
      }

      return response;
    } catch (e) {
      log("Error in recordVaccination: $e");
      return ApiResponse.error("Failed to record vaccination: $e");
    }
  }

  // Get vaccinations for a specific batch
  Future<ApiResponse<List<MyVaccineResponseModel>>> getBatchVaccinations(
      String batchId) async {
    try {
      log("Fetching vaccinations for batch: $batchId");

      final response =
          await _firebaseClient.getCollection<MyVaccineResponseModel>(
        collectionPath: FirebasePath.myVaccines,
        responseType: (json) => MyVaccineResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
      );

      return response;
    } catch (e) {
      log("Error in getBatchVaccinations: $e");
      return ApiResponse.error("Failed to fetch vaccinations: $e");
    }
  }

  // Get vaccinations by month
  Future<ApiResponse<List<MyVaccineResponseModel>>> getMonthlyVaccinations(
      String yearMonth) async {
    try {
      log("Fetching vaccinations for month: $yearMonth");

      final response =
          await _firebaseClient.getCollection<MyVaccineResponseModel>(
        collectionPath: FirebasePath.myVaccines,
        responseType: (json) => MyVaccineResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('yearMonth', isEqualTo: yearMonth),
      );

      return response;
    } catch (e) {
      log("Error in getMonthlyVaccinations: $e");
      return ApiResponse.error("Failed to fetch vaccinations: $e");
    }
  }
}
