// import 'package:cloud_firestore/cloud_firestore.dart';

// class EggCollectionResponseModel {
//   final String? collectionId;
//   final String batchId;
//   final String adminId;
//   final String yearMonth; // Nepali year-month for filtering (e.g., "2080-12")
//   final String collectionDate;

//   // Normal Eggs Collection
//   final String
//       eggCategory; //  'small','medium','large','large_plus','crack','waste'
//   final int totalCrates; //
//   final int remainingEggs;
//   final int henCount;
//   // Metadata

//   EggCollectionResponseModel({
//     this.collectionId,
//     required this.batchId,
//     required this.adminId,
//     required this.yearMonth,
//     required this.collectionDate,
//     required this.eggCategory,
//     required this.totalCrates,
//     required this.remainingEggs,
//     required this.henCount,
//   });

//   factory EggCollectionResponseModel.fromJson(Map<String, dynamic> json,
//       {String? collectionId}) {
//     return EggCollectionResponseModel(
//       collectionId: collectionId ?? json['collectionId'],
//       batchId: json['batchId'] ?? '',
//       adminId: json['adminId'] ?? '',
//       yearMonth: json['yearMonth'] ?? '',
//       collectionDate: json['collectionDate'] ?? '',
//       eggCategory: json['eggCategory'] ?? '',
//       totalCrates: json['totalCrates'] ?? 0,
//       remainingEggs: json['remainingEggs'] ?? 0,
//       henCount: json['henCount'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'batchId': batchId,
//       'adminId': adminId,
//       'yearMonth': yearMonth,
//       'collectionDate': collectionDate,
//       'eggCategory': eggCategory,
//       'totalCrates': totalCrates,
//       'remainingEggs': remainingEggs,
//       'henCount': henCount,
//     };
//   }

//   // Helper to get total eggs
//   int getTotalEggs() {
//     return (totalCrates * 30) + remainingEggs;
//   }
// }

class EggCollectionResponseModel {
  final String? collectionId;
  final String batchId;
  final String adminId;
  final String yearMonth;
  final String collectionDate;

  // Total egg counts for each category
  final int totalLargePlusEggs;
  final int totalLargeEggs;
  final int totalMediumEggs;
  final int totalSmallEggs;
  final int totalCrackEggs;
  final int totalWasteEggs;

  final int henCount;

  EggCollectionResponseModel({
    this.collectionId,
    required this.batchId,
    required this.adminId,
    required this.yearMonth,
    required this.collectionDate,
    required this.totalLargePlusEggs,
    required this.totalLargeEggs,
    required this.totalMediumEggs,
    required this.totalSmallEggs,
    required this.totalCrackEggs,
    required this.totalWasteEggs,
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
      totalLargePlusEggs: json['totalLargePlusEggs'] ?? 0,
      totalLargeEggs: json['totalLargeEggs'] ?? 0,
      totalMediumEggs: json['totalMediumEggs'] ?? 0,
      totalSmallEggs: json['totalSmallEggs'] ?? 0,
      totalCrackEggs: json['totalCrackEggs'] ?? 0,
      totalWasteEggs: json['totalWasteEggs'] ?? 0,
      henCount: json['henCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'collectionDate': collectionDate,
      'totalLargePlusEggs': totalLargePlusEggs,
      'totalLargeEggs': totalLargeEggs,
      'totalMediumEggs': totalMediumEggs,
      'totalSmallEggs': totalSmallEggs,
      'totalCrackEggs': totalCrackEggs,
      'totalWasteEggs': totalWasteEggs,
      'henCount': henCount,
    };
  }

  // Get grand total of all eggs
  int getTotalEggs() {
    return totalLargePlusEggs +
        totalLargeEggs +
        totalMediumEggs +
        totalSmallEggs +
        totalCrackEggs +
        totalWasteEggs;
  }
}
