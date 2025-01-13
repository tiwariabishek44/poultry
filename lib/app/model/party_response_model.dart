import 'package:cloud_firestore/cloud_firestore.dart';

class PartyResponseModel {
  final String? partyId;
  final String partyName;
  final String partyType; // 'supplier' or 'customer'
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? taxNumber;
  final bool isPan;
  final String adminId;
  final double creditAmount;
  final String? companyName;
  final bool isCredited;

  PartyResponseModel({
    this.partyId,
    required this.partyName,
    required this.partyType,
    required this.phoneNumber,
    this.email,
    this.address,
    this.taxNumber,
    this.isPan = true,
    required this.adminId,
    this.creditAmount = 0.0,
    this.companyName,
    required this.isCredited,
  });

  factory PartyResponseModel.fromJson(Map<String, dynamic> json,
      {String? partyId}) {
    return PartyResponseModel(
      partyId: partyId ?? json['partyId'],
      partyName: json['partyName'] ?? '',
      partyType: json['partyType'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      address: json['address'],
      taxNumber: json['taxNumber'],
      isPan: json['isPan'] ?? true,
      adminId: json['adminId'] ?? '',
      creditAmount: (json['creditAmount'] ?? 0.0).toDouble(),
      companyName: json['companyName'],
      isCredited: json['isCredited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyName': partyName,
      'partyType': partyType,
      'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (taxNumber != null) 'taxNumber': taxNumber,
      if (taxNumber != null) 'isPan': isPan,
      'adminId': adminId,
      'creditAmount': creditAmount,
      if (companyName != null) 'companyName': companyName,
      'isCredited': isCredited,
    };
  }

  // Helper method to get type display text
  String getPartyTypeDisplay() {
    switch (partyType.toLowerCase()) {
      case 'supplier':
        return 'Supplier';
      case 'customer':
        return 'Customer';
      default:
        return 'Unknown';
    }
  }

  // Helper method to get tax number type display
  String getTaxNumberTypeDisplay() {
    if (taxNumber == null) return 'No Tax Number';
    return isPan ? 'PAN' : 'VAT';
  }

  // Helper method to get formatted credit amount
  String getFormattedCreditAmount() {
    return 'Rs. ${creditAmount.toStringAsFixed(2)}';
  }
}
