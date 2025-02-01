// Model
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/service/api_client.dart';

class DailyWeightGainResponseModel {
  final String? weightGainId; // Unique ID for the weight gain record
  final String batchId; // ID of the batch
  final String adminId; // ID of the admin/user
  final String date; // Date when the weight was recorded
  final double weight; // Average weight of the birds in kilograms

  DailyWeightGainResponseModel({
    this.weightGainId,
    required this.batchId,
    required this.adminId,
    required this.date,
    required this.weight,
  });

  // Factory method to create a model from JSON
  factory DailyWeightGainResponseModel.fromJson(Map<String, dynamic> json,
      {String? weightGainId}) {
    return DailyWeightGainResponseModel(
      weightGainId: weightGainId ?? json['weightGainId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      date: json['date'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'adminId': adminId,
      'date': date,
      'weight': weight,
    };
  }
}

// Repository

class DailyWeightGainRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  // Create a new daily weight gain record
  Future<ApiResponse<DailyWeightGainResponseModel>> createDailyWeightGain({
    required String batchId,
    required String adminId,
    required double weight,
    required String date,
  }) async {
    try {
      // Get document reference for the new weight gain record
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.dailyWeightGain,
      );

      // Prepare weight gain data
      final weightGainData = DailyWeightGainResponseModel(
        weightGainId: docRef.id,
        batchId: batchId,
        adminId: adminId,
        date: date,
        weight: weight,
      ).toJson();

      // Save the record to Firebase
      final response =
          await _firebaseClient.postDocument<DailyWeightGainResponseModel>(
        collectionPath: FirebasePath.dailyWeightGain,
        documentId: docRef.id,
        data: weightGainData,
        responseType: (json) => DailyWeightGainResponseModel.fromJson(json,
            weightGainId: docRef.id),
      );

      return response;
    } catch (e) {
      return ApiResponse.error("Failed to create daily weight gain record: $e");
    }
  }

  // Fetch all daily weight gain records for a specific batch
  Future<ApiResponse<List<DailyWeightGainResponseModel>>>
      getDailyWeightGainByBatch({
    required String batchId,
  }) async {
    try {
      final response =
          await _firebaseClient.getCollection<DailyWeightGainResponseModel>(
        collectionPath: FirebasePath.dailyWeightGain,
        responseType: (json) => DailyWeightGainResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
      );

      return response;
    } catch (e) {
      return ApiResponse.error("Failed to fetch daily weight gain records: $e");
    }
  }

  // Stream daily weight gain records for real-time updates
  Stream<List<DailyWeightGainResponseModel>> streamDailyWeightGainByBatch({
    required String batchId,
  }) {
    return _firebaseClient
        .streamCollection(
          collectionPath: FirebasePath.dailyWeightGain,
          queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => DailyWeightGainResponseModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  weightGainId: doc.id,
                ))
            .toList());
  }
}
