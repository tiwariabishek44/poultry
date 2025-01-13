import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/purchase_repsonse_model.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class PurchaseRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Create a new purchase record
  Future<ApiResponse<PurchaseResponseModel>> createPurchaseRecord(
      Map<String, dynamic> purchaseData,
      double currentCredit,
      String remarks) async {
    try {
      log("Creating purchase record: $purchaseData");

      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.purchases);

      purchaseData['purchaseId'] = docRef.id;

      final response =
          await _firebaseClient.postDocument<PurchaseResponseModel>(
        collectionPath: FirebasePath.purchases,
        documentId: docRef.id,
        data: purchaseData,
        responseType: (json) =>
            PurchaseResponseModel.fromJson(json, purchaseId: docRef.id),
      );

      if (response.status == ApiStatus.SUCCESS) {
        // Create a purchase transaction
        await _transactionRepository.createBusinessTransaction(
          partyId: purchaseData['partyId'],
          adminId: purchaseData['adminId'],
          actionId: docRef.id,
          totalAmount: purchaseData['totalAmount'],
          paidAmount: purchaseData['paidAmount'],
          currentCredit: currentCredit,
          paymentMethod: purchaseData['paymentMethod'] ?? '',
          isSale: false, // This is a purchase
          transactionUnder:
              '', // this is for passing the bank name, or wallet name
          notes: purchaseData['notes'],
          remarks: remarks,
        );
      }

      return response;
    } catch (e) {
      log("Error in createPurchaseRecord: $e");
      return ApiResponse.error("Failed to create purchase record: $e");
    }
  }

  // Get purchase records with flexible filtering options
  Future<ApiResponse<List<PurchaseResponseModel>>> getPurchaseRecords({
    String? partyId,
    String? yearMonth,
    String? category,
    String? subcategory,
    String? paymentStatus,
    bool? isServicePurchase,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      log("Fetching purchase records");

      return await _firebaseClient.getCollection<PurchaseResponseModel>(
        collectionPath: FirebasePath.purchases,
        responseType: (json) => PurchaseResponseModel.fromJson(json),
        queryBuilder: (query) {
          Query result = query;

          if (partyId != null) {
            result = result.where('partyId', isEqualTo: partyId);
          }

          if (yearMonth != null) {
            result = result.where('yearMonth', isEqualTo: yearMonth);
          }

          if (paymentStatus != null) {
            result = result.where('paymentStatus', isEqualTo: paymentStatus);
          }

          if (isServicePurchase != null) {
            result =
                result.where('isServicePurchase', isEqualTo: isServicePurchase);
          }

          if (startDate != null) {
            result = result.where('purchaseDate',
                isGreaterThanOrEqualTo: startDate.toIso8601String());
          }

          if (endDate != null) {
            result = result.where('purchaseDate',
                isLessThanOrEqualTo: endDate.toIso8601String());
          }

          // If category/subcategory filter is applied
          if (category != null || subcategory != null) {
            result = result.where('purchaseItems', arrayContains: {
              if (category != null) 'category': category,
              if (subcategory != null) 'subcategory': subcategory,
            });
          }

          // Default ordering by purchase date
          return result.orderBy('purchaseDate', descending: true);
        },
      );
    } catch (e) {
      log("Error in getPurchaseRecords: $e");
      return ApiResponse.error("Failed to fetch purchase records: $e");
    }
  }

  // Add these methods to SalesRepository class
  Future<ApiResponse<double>> getTotalSalesAmount(
      String yearMonth, String adminId) async {
    try {
      log("Fetching total sales amount for: $yearMonth, adminId: $adminId");

      final response =
          await _firebaseClient.getCollection<Map<String, dynamic>>(
        collectionPath: FirebasePath.sales,
        responseType: (json) => json,
        queryBuilder: (query) => query
            .where('yearMonth', isEqualTo: yearMonth)
            .where('adminId', isEqualTo: adminId),
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        double totalAmount = 0;
        for (var saleData in response.response!) {
          totalAmount += (saleData['totalAmount'] ?? 0.0).toDouble();
        }
        return ApiResponse.completed(totalAmount);
      } else {
        return ApiResponse.error(
            response.message ?? "Failed to fetch sales data");
      }
    } catch (e) {
      log("Error in getTotalSalesAmount: $e");
      return ApiResponse.error("Failed to get total sales amount: $e");
    }
  }

// Add these methods to PurchaseRepository class
  Future<ApiResponse<double>> getTotalPurchaseAmount(
      String yearMonth, String adminId) async {
    try {
      log("Fetching total purchase amount for: $yearMonth, adminId: $adminId");

      final response =
          await _firebaseClient.getCollection<Map<String, dynamic>>(
        collectionPath: FirebasePath.purchases,
        responseType: (json) => json,
        queryBuilder: (query) => query
            .where('yearMonth', isEqualTo: yearMonth)
            .where('adminId', isEqualTo: adminId),
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        double totalAmount = 0;
        for (var purchaseData in response.response!) {
          totalAmount += (purchaseData['totalAmount'] ?? 0.0).toDouble();
        }
        return ApiResponse.completed(totalAmount);
      } else {
        return ApiResponse.error(
            response.message ?? "Failed to fetch purchase data");
      }
    } catch (e) {
      log("Error in getTotalPurchaseAmount: $e");
      return ApiResponse.error("Failed to get total purchase amount: $e");
    }
  }
}
