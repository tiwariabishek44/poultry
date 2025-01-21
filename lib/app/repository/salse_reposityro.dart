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
          date: saleData['saleDate'],
          yearMonth: saleData['yearMonth'],
          notes: saleData['notes'],
          remarks: remarks,
          isSale: true,
          unpaidAmount: saleData['totalAmount'] - saleData['paidAmount'],
        );
      }

      if (response.status == ApiStatus.SUCCESS) {}

      return response;
    } catch (e) {
      log("Error in createSaleRecord: $e");
      return ApiResponse.error("Failed to create sale record: $e");
    }
  }
}
