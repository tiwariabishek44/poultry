import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/rice_husk_reposnse.dart';
import 'package:poultry/app/service/api_client.dart';

class RiceHuskRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<RiceHuskSpray>> createRiceHuskRecord(
      Map<String, dynamic> riceHuskData) async {
    try {
      log("Creating rice husk record: $riceHuskData");

      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.riceHusk);

      riceHuskData['ricehuskId'] = docRef.id;

      final response = await _firebaseClient.postDocument<RiceHuskSpray>(
        collectionPath: FirebasePath.riceHusk,
        documentId: docRef.id,
        data: riceHuskData,
        responseType: (json) =>
            RiceHuskSpray.fromJson(json, ricehuskId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createRiceHuskRecord: $e");
      return ApiResponse.error("Failed to create rice husk record: $e");
    }
  }

  // Get records by batch and month for reports
  Future<ApiResponse<List<RiceHuskSpray>>> getRiceHuskRecords({
    String? batchId,
    String? yearMonth,
  }) async {
    try {
      log("Fetching rice husk records");

      return await _firebaseClient.getCollection<RiceHuskSpray>(
        collectionPath: FirebasePath.riceHusk,
        responseType: (json) => RiceHuskSpray.fromJson(json),
        queryBuilder: (query) {
          Query result = query;
          if (batchId != null) {
            result = result.where('batchId', isEqualTo: batchId);
          }
          if (yearMonth != null) {
            result = result.where('yearMonth', isEqualTo: yearMonth);
          }
          return result;
        },
      );
    } catch (e) {
      log("Error in getRiceHuskRecords: $e");
      return ApiResponse.error("Failed to fetch rice husk records: $e");
    }
  }
}
