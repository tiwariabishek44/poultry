import 'package:cloud_firestore/cloud_firestore.dart';

class BatchResponseModel {
  final String? batchId; // Nullable as it's assigned by Firebase
  final String batchName; // Required
  final int initialFlockCount; // Required
  final int currentFlockCount; // Required
  final int totalDeath; // Required
  final String startingDate; // Required
  final String? retireDate; // Optional as batch might be ongoing
  final String stage; // Required
  final String adminId; // Required
  final bool isActive; // Required with default

  BatchResponseModel({
    this.batchId,
    required this.batchName,
    required this.initialFlockCount,
    required this.currentFlockCount,
    required this.totalDeath,
    required this.startingDate,
    this.retireDate,
    required this.stage,
    required this.adminId,
    this.isActive = true, // Default value provided
  });

  factory BatchResponseModel.fromJson(Map<String, dynamic> json,
      {String? batchId}) {
    return BatchResponseModel(
      batchId: batchId ?? json['batchId'],
      batchName: json['batchName'] ?? '', // Provide default for required field
      initialFlockCount: json['initialFlockCount'] ?? 0, // Default for required
      currentFlockCount: json['currentFlockCount'] ?? 0, // Default for required
      totalDeath: json['totalDeath'] ?? 0, // Default for required
      startingDate: json['startingDate'] ?? '', // Default for required
      retireDate: json['retireDate'], // Optional field
      stage: json['stage'] ?? '', // Default for required
      adminId: json['adminId'] ?? '', // Default for required
      isActive: json['isActive'] ?? true, // Default for required
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchName': batchName,
      'initialFlockCount': initialFlockCount,
      'currentFlockCount': currentFlockCount,
      'totalDeath': totalDeath,
      'startingDate': startingDate,
      'retireDate': retireDate,
      'stage': stage,
      'adminId': adminId,
      'isActive': isActive,
    };
  }
}
