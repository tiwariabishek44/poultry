import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/model/my_vaccine_reposnse.dart';
import 'package:poultry/app/model/rice_husk_reposnse.dart';
import 'package:poultry/app/service/api_client.dart';

class MonthlyReportRepository {
  final _firebaseClient = FirebaseClient();

  Future<ApiResponse<List<EggCollectionResponseModel>>>
      getMonthlyEggCollections({
    required String adminId,
    required String yearMonth,
    String? batchId,
  }) async {
    try {
      log('the batch id is null ${batchId == null}');
      final response = await _firebaseClient.getCollection(
          collectionPath: FirebasePath.eggCollections,
          responseType: (json) => EggCollectionResponseModel.fromJson(json),
          queryBuilder: (query) {
            var filteredQuery = query
                .where('adminId', isEqualTo: adminId)
                .where('yearMonth', isEqualTo: yearMonth);
            if (batchId != null && batchId.isNotEmpty) {
              filteredQuery =
                  filteredQuery.where('batchId', isEqualTo: batchId);
            }
            return filteredQuery;
          });
      return response;
    } catch (e) {
      return ApiResponse.error("Failed to fetch egg collections: $e");
    }
  }

  Future<ApiResponse<List<FeedConsumptionResponseModel>>>
      getMonthlyFeedConsumption({
    required String adminId,
    required String yearMonth,
    String? batchId,
  }) async {
    try {
      final response = await _firebaseClient.getCollection(
          collectionPath: FirebasePath.feedConsumption,
          responseType: (json) => FeedConsumptionResponseModel.fromJson(json),
          queryBuilder: (query) {
            var filteredQuery = query
                .where('adminId', isEqualTo: adminId)
                .where('yearMonth', isEqualTo: yearMonth);
            if (batchId != null && batchId.isNotEmpty) {
              filteredQuery =
                  filteredQuery.where('batchId', isEqualTo: batchId);
            }
            return filteredQuery;
          });
      return response;
    } catch (e) {
      return ApiResponse.error("Failed to fetch feed consumption: $e");
    }
  }

  Future<ApiResponse<List<FlockDeathModel>>> getMonthlyMortality({
    required String adminId,
    required String yearMonth,
    String? batchId,
  }) async {
    try {
      final response = await _firebaseClient.getCollection(
          collectionPath: FirebasePath.flockDeaths,
          responseType: (json) => FlockDeathModel.fromJson(json),
          queryBuilder: (query) {
            var filteredQuery = query
                .where('adminId', isEqualTo: adminId)
                .where('yearMonth', isEqualTo: yearMonth);
            if (batchId != null && batchId.isNotEmpty) {
              filteredQuery =
                  filteredQuery.where('batchId', isEqualTo: batchId);
            }
            return filteredQuery;
          });
      return response;
    } catch (e) {
      return ApiResponse.error("Failed to fetch mortality: $e");
    }
  }

  Future<ApiResponse<List<RiceHuskSpray>>> getMonthlyRiceHusk({
    required String adminId,
    required String yearMonth,
    String? batchId,
  }) async {
    try {
      final response = await _firebaseClient.getCollection(
          collectionPath: FirebasePath.riceHusk,
          responseType: (json) => RiceHuskSpray.fromJson(json),
          queryBuilder: (query) {
            var filteredQuery = query
                .where('adminId', isEqualTo: adminId)
                .where('yearMonth', isEqualTo: yearMonth);
            if (batchId != null && batchId.isNotEmpty) {
              filteredQuery =
                  filteredQuery.where('batchId', isEqualTo: batchId);
            }
            return filteredQuery;
          });
      return response;
    } catch (e) {
      return ApiResponse.error("Failed to fetch rice husk: $e");
    }
  }

  Future<ApiResponse<List<MyVaccineResponseModel>>> getMonthlyVaccination({
    required String adminId,
    required String yearMonth,
    String? batchId,
  }) async {
    try {
      final response = await _firebaseClient.getCollection(
          collectionPath: FirebasePath.myVaccines,
          responseType: (json) => MyVaccineResponseModel.fromJson(json),
          queryBuilder: (query) {
            var filteredQuery = query
                .where('adminId', isEqualTo: adminId)
                .where('yearMonth', isEqualTo: yearMonth);
            if (batchId != null && batchId.isNotEmpty) {
              filteredQuery =
                  filteredQuery.where('batchId', isEqualTo: batchId);
            }
            return filteredQuery;
          });
      return response;
    } catch (e) {
      return ApiResponse.error("Failed to fetch vaccination: $e");
    }
  }
}
