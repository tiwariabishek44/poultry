import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class FlockDeathModel {
  final String? deathId;
  final String batchId;
  final String adminId;
  final int deathCount;
  final String cause;
  final String date;
  final String yearMonth;
  final String? notes;

  FlockDeathModel({
    this.deathId,
    required this.batchId,
    required this.adminId,
    required this.deathCount,
    required this.cause,
    required this.date,
    required this.yearMonth,
    this.notes,
  });

  factory FlockDeathModel.fromJson(Map<String, dynamic> json,
      {String? deathId}) {
    return FlockDeathModel(
      deathId: deathId ?? json['deathId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      deathCount: json['deathCount'] ?? 0,
      cause: json['cause'] ?? '',
      date: json['date'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deathId': deathId,
      'batchId': batchId,
      'adminId': adminId,
      'deathCount': deathCount,
      'cause': cause,
      'date': date,
      'yearMonth': yearMonth,
      if (notes != null) 'notes': notes,
    };
  }
}

class FlockDeathRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<FlockDeathModel>> recordFlockDeath({
    required String batchId,
    required String adminId,
    required int deathCount,
    required String cause,
    required String date,
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
        date: date,
        notes: '',
        yearMonth: date.substring(0, 7),
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
