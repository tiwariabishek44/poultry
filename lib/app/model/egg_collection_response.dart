import 'package:cloud_firestore/cloud_firestore.dart';

class EggCollectionResponseModel {
  final String? collectionId;
  final String batchId;
  final String adminId;
  final String yearMonth; // Nepali year-month for filtering (e.g., "2080-12")
  final String collectionDate;

  // Normal Eggs Collection
  final String eggCategory; // 'normal' or 'crack'
  final String eggSize; // 'small', 'medium', 'large', 'large_plus'
  final int totalCrates; // Number of complete crates (30 eggs each)
  final int remainingEggs; // Eggs less than a full crate (<30)
  final int henCount; // Added hen count field

  // Metadata

  EggCollectionResponseModel({
    this.collectionId,
    required this.batchId,
    required this.adminId,
    required this.yearMonth,
    required this.collectionDate,
    required this.eggCategory,
    required this.eggSize,
    required this.totalCrates,
    required this.remainingEggs,
    required this.henCount,
  });

  factory EggCollectionResponseModel.fromJson(Map<String, dynamic> json,
      {String? collectionId}) {
    return EggCollectionResponseModel(
      collectionId: collectionId ?? json['collectionId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      collectionDate: json['collectionDate'] ?? '',
      eggCategory: json['eggCategory'] ?? '',
      eggSize: json['eggSize'] ?? '',
      totalCrates: json['totalCrates'] ?? 0,
      remainingEggs: json['remainingEggs'] ?? 0,
      henCount: json['henCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'collectionDate': collectionDate,
      'eggCategory': eggCategory,
      'eggSize': eggSize,
      'totalCrates': totalCrates,
      'remainingEggs': remainingEggs,
      'henCount': henCount,
    };
  }

  // Helper to get total eggs
  int getTotalEggs() {
    return (totalCrates * 30) + remainingEggs;
  }
}
