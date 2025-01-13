import 'package:cloud_firestore/cloud_firestore.dart';

class UserResponseModel {
  final String? uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? farmName;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  UserResponseModel({
    this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.farmName,
    this.address,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json, {String? uid}) {
    return UserResponseModel(
      uid: uid ?? json['uid'], // Use provided uid if available
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      farmName: json['farmName'],
      address: json['address'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid, // Include uid in the data
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'farmName': farmName,
      'address': address,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }
}
