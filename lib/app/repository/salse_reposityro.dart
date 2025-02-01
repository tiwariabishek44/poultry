import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/salse_resonse_model.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class SalesRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<ApiResponse<SalesResponseModel>> createSaleRecord(
      Map<String, dynamic> saleData,
      double currentCredit,
      String remarks) async {
    try {
      log("Creating sale record: $saleData");

      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.sales);

      saleData['saleId'] = docRef.id;

      // Process all sale items
      final saleItems = (saleData['saleItems'] as List)
          .map((item) => SaleItem.fromJson(item))
          .toList();

      // Separate hen items from other items
      final henItems =
          saleItems.where((item) => item.category == 'hen').toList();

      // Check if we need to update batch data (only if there are hen items)
      if (henItems.isNotEmpty && saleData['batchId'] != null) {
        // Calculate totals for hen items only
        final totalHensSold =
            henItems.fold(0.0, (sum, item) => sum + item.quantity);
        final totalHenWeight =
            henItems.fold(0.0, (sum, item) => sum + item.totalWeight);

        // Prepare batch update data for hen-related changes only
        final batchUpdate = {
          'currentFlockCount': FieldValue.increment(-totalHensSold.toInt()),
          'totalSold': FieldValue.increment(totalHensSold.toInt()),
          'totalWeight': FieldValue.increment(totalHenWeight),
        };

        // Use updateRelatedDocuments for both sale and batch update
        final response =
            await _firebaseClient.updateRelatedDocuments<SalesResponseModel>(
          primaryCollection: FirebasePath.sales,
          primaryId: docRef.id,
          primaryUpdate: saleData,
          relatedCollection: FirebasePath.batches,
          relatedId: saleData['batchId'],
          relatedUpdate: batchUpdate,
          responseType: (json) =>
              SalesResponseModel.fromJson(json, saleId: docRef.id),
        );

        if (response.status == ApiStatus.SUCCESS) {
          await _createTransactionRecord(saleData, currentCredit, remarks);
        }

        return response;
      } else {
        // Handle sales with no hen items (only manure, eggs, or other items)
        final response = await _firebaseClient.postDocument<SalesResponseModel>(
          collectionPath: FirebasePath.sales,
          documentId: docRef.id,
          data: saleData,
          responseType: (json) =>
              SalesResponseModel.fromJson(json, saleId: docRef.id),
        );

        if (response.status == ApiStatus.SUCCESS) {
          await _createTransactionRecord(saleData, currentCredit, remarks);
        }

        return response;
      }
    } catch (e) {
      log("Error in createSaleRecord: $e");
      return ApiResponse.error("Failed to create sale record: $e");
    }
  }

  Future<void> _createTransactionRecord(Map<String, dynamic> saleData,
      double currentCredit, String remarks) async {
    try {
      await _transactionRepository.createBusinessTransaction(
        partyId: saleData['partyId'],
        actionId: saleData['saleId'],
        adminId: saleData['adminId'],
        totalAmount: saleData['totalAmount'],
        paidAmount: saleData['paidAmount'],
        currentCredit: currentCredit,
        paymentMethod: '',
        transactionUnder: '',
        date: saleData['saleDate'],
        yearMonth: saleData['yearMonth'],
        notes: saleData['notes'],
        remarks: remarks,
        transactionType: 'SALE',
        unpaidAmount: saleData['totalAmount'] - saleData['paidAmount'],
      );
    } catch (e) {
      log("Error creating transaction record: $e");
      throw e; // Re-throw to be handled by the caller
    }
  }
}





// This repository handles the creation of sale records in a poultry management system.
// It interacts with Firebase Firestore to store sale data and updates related batch data if necessary.
// The `createSaleRecord` method processes the sale data, separates hen items, and updates the batch data accordingly.
// It also creates a transaction record using the `_createTransactionRecord` method.
// The repository uses a `FirebaseClient` for Firestore operations and a `TransactionRepository` for handling transactions.