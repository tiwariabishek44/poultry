import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/salse_resonse_model.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class SalesRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Create a new sale record
  Future<ApiResponse<SalesResponseModel>> createSaleRecord(
      Map<String, dynamic> saleData,
      double currentCredit,
      String remarks) async {
    try {
      log("Creating sale record: $saleData");

      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.sales);

      saleData['saleId'] = docRef.id;

      final response = await _firebaseClient.postDocument<SalesResponseModel>(
        collectionPath: FirebasePath.sales,
        documentId: docRef.id,
        data: saleData,
        responseType: (json) =>
            SalesResponseModel.fromJson(json, saleId: docRef.id),
      );

      if (response.status == ApiStatus.SUCCESS) {
        // Create a sale transaction when sale record is successful
        await _transactionRepository.createBusinessTransaction(
          partyId: saleData['partyId'],
          actionId: docRef.id,
          adminId: saleData['adminId'],
          totalAmount: saleData['totalAmount'],
          paidAmount: saleData['paidAmount'],
          currentCredit: currentCredit, // Using the passed currentCredit
          paymentMethod:
              '', // Default to CASH, you might want to make this configurable
          transactionUnder: '',
          notes: saleData['notes'],
          remarks: remarks,
          isSale: true,
        );
      }

      if (response.status == ApiStatus.SUCCESS) {}

      return response;
    } catch (e) {
      log("Error in createSaleRecord: $e");
      return ApiResponse.error("Failed to create sale record: $e");
    }
  }

  // Get sales records with flexible filtering options
  Future<ApiResponse<List<SalesResponseModel>>> getSalesRecords({
    String? partyId,
    String? yearMonth,
    String? batchId,
    String? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      log("Fetching sales records");

      return await _firebaseClient.getCollection<SalesResponseModel>(
        collectionPath: FirebasePath.sales,
        responseType: (json) => SalesResponseModel.fromJson(json),
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

          if (batchId != null) {
            // Query for sales containing items from specific batch
            result =
                result.where('saleItems', arrayContains: {'batchId': batchId});
          }

          if (startDate != null) {
            result = result.where('saleDate',
                isGreaterThanOrEqualTo: startDate.toIso8601String());
          }

          if (endDate != null) {
            result = result.where('saleDate',
                isLessThanOrEqualTo: endDate.toIso8601String());
          }

          // Default ordering by sale date
          return result.orderBy('saleDate', descending: true);
        },
      );
    } catch (e) {
      log("Error in getSalesRecords: $e");
      return ApiResponse.error("Failed to fetch sales records: $e");
    }
  }

  Future<ApiResponse<double>> getTotalSalesAmount(
      String yearMonth, String adminId) async {
    try {
      log("Fetching total sales amount for: $yearMonth");

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
}
