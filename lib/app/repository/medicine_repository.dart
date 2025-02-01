// lib/app/model/medicine_response_model.dart

import 'dart:developer';

import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/service/api_client.dart';

class MedicineResponseModel {
  final String? medicineId; // Nullable as it's assigned by Firebase
  final String medicineName;
  final String adminId;

  MedicineResponseModel({
    this.medicineId,
    required this.medicineName,
    required this.adminId,
  });

  factory MedicineResponseModel.fromJson(Map<String, dynamic> json,
      {String? medicineId}) {
    return MedicineResponseModel(
      medicineId: medicineId ?? json['medicineId'],
      medicineName: json['medicineName'] ?? '',
      adminId: json['adminId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'adminId': adminId,
    };
  }
}

class MedicineRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  // Create new medicine
  Future<ApiResponse<MedicineResponseModel>> createMedicine(
      Map<String, dynamic> medicineData) async {
    try {
      // Get document reference for new medicine
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.medicines,
      );

      // Add the document ID to the medicine data
      medicineData['medicineId'] = docRef.id;

      // Create medicine document
      final response =
          await _firebaseClient.postDocument<MedicineResponseModel>(
        collectionPath: FirebasePath.medicines,
        documentId: docRef.id,
        data: medicineData,
        responseType: (json) =>
            MedicineResponseModel.fromJson(json, medicineId: docRef.id),
      );

      if (response.status == ApiStatus.SUCCESS) {
        log("Successfully created medicine");
      } else {
        log("Failed to create medicine: ${response.message}");
      }

      return response;
    } catch (e) {
      log("Error in createMedicine: $e");
      return ApiResponse.error("Failed to create medicine: $e");
    }
  }

  // Get all medicines for an admin
  Future<ApiResponse<List<MedicineResponseModel>>> getMedicines(
      String adminId) async {
    try {
      return await _firebaseClient.getCollection<MedicineResponseModel>(
          collectionPath: FirebasePath.medicines,
          responseType: (json) => MedicineResponseModel.fromJson(json),
          queryBuilder: (query) => query.where('adminId', isEqualTo: adminId));
    } catch (e) {
      log("Error in getMedicines: $e");
      return ApiResponse.error("Failed to fetch medicines: $e");
    }
  }

  // Delete medicine
  Future<ApiResponse<void>> deleteMedicine(String medicineId) async {
    try {
      log("Deleting medicine: $medicineId");

      return await _firebaseClient.deleteDocument(
        collectionPath: FirebasePath.medicines,
        documentId: medicineId,
      );
    } catch (e) {
      log("Error in deleteMedicine: $e");
      return ApiResponse.error("Failed to delete medicine: $e");
    }
  }
}

// ------------- Flock medicaiton
// lib/app/model/flock_medication_response_model.dart

class FlockMedicationResponseModel {
  final String? medicationId; // Nullable as it's assigned by Firebase
  final String batchId;
  final String adminId;
  final String medicineName;
  final String date; // Will store in YYYY-MM-DD format

  FlockMedicationResponseModel({
    this.medicationId,
    required this.batchId,
    required this.adminId,
    required this.medicineName,
    required this.date,
  });

  factory FlockMedicationResponseModel.fromJson(Map<String, dynamic> json,
      {String? medicationId}) {
    return FlockMedicationResponseModel(
      medicationId: medicationId ?? json['medicationId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      medicineName: json['medicineName'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'adminId': adminId,
      'medicineName': medicineName,
      'date': date,
    };
  }
}

class FlockMedicationRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  // Create new medication record
  Future<ApiResponse<FlockMedicationResponseModel>> createMedication(
      Map<String, dynamic> medicationData) async {
    try {
      log("Creating medication record with data: $medicationData");

      // Get document reference for new medication
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.flockMedications,
      );

      // Add the document ID to the medication data
      medicationData['medicationId'] = docRef.id;

      // Create medication document
      final response =
          await _firebaseClient.postDocument<FlockMedicationResponseModel>(
        collectionPath: FirebasePath.flockMedications,
        documentId: docRef.id,
        data: medicationData,
        responseType: (json) => FlockMedicationResponseModel.fromJson(json,
            medicationId: docRef.id),
      );

      if (response.status == ApiStatus.SUCCESS) {
      } else {}

      return response;
    } catch (e) {
      log("Error in createMedication: $e");
      return ApiResponse.error("Failed to create medication record: $e");
    }
  }

  // Get all medications for a batch
  Future<ApiResponse<List<FlockMedicationResponseModel>>> getBatchMedications(
      String batchId) async {
    try {
      log("Fetching medications for batch: $batchId");

      return await _firebaseClient.getCollection<FlockMedicationResponseModel>(
        collectionPath: FirebasePath.flockMedications,
        responseType: (json) => FlockMedicationResponseModel.fromJson(json),
        queryBuilder: (query) => query
            .where('batchId', isEqualTo: batchId)
            .orderBy('date', descending: true),
      );
    } catch (e) {
      log("Error in getBatchMedications: $e");
      return ApiResponse.error("Failed to fetch medications: $e");
    }
  }

  // Get all medications for an admin
  Future<ApiResponse<List<FlockMedicationResponseModel>>> getAdminMedications(
      String adminId) async {
    try {
      log("Fetching medications for admin: $adminId");

      return await _firebaseClient.getCollection<FlockMedicationResponseModel>(
        collectionPath: FirebasePath.flockMedications,
        responseType: (json) => FlockMedicationResponseModel.fromJson(json),
        queryBuilder: (query) => query
            .where('adminId', isEqualTo: adminId)
            .orderBy('date', descending: true),
      );
    } catch (e) {
      log("Error in getAdminMedications: $e");
      return ApiResponse.error("Failed to fetch medications: $e");
    }
  }

  // Delete medication record
  Future<ApiResponse<void>> deleteMedication(String medicationId) async {
    try {
      log("Deleting medication record: $medicationId");

      return await _firebaseClient.deleteDocument(
        collectionPath: FirebasePath.flockMedications,
        documentId: medicationId,
      );
    } catch (e) {
      log("Error in deleteMedication: $e");
      return ApiResponse.error("Failed to delete medication record: $e");
    }
  }
}
