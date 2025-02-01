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
          date: purchaseData['purchaseDate'],
          yearMonth: purchaseData['yearMonth'],
          actionId: docRef.id,
          totalAmount: purchaseData['totalAmount'],
          paidAmount: purchaseData['paidAmount'],
          currentCredit: currentCredit,
          paymentMethod: purchaseData['paymentMethod'] ?? '',
          transactionType: 'PURCHASE', // This is a purchase
          transactionUnder:
              '', // this is for passing the bank name, or wallet name
          notes: purchaseData['notes'],
          remarks: remarks,
          unpaidAmount:
              purchaseData['totalAmount'] - purchaseData['paidAmount'],
        );
      }

      return response;
    } catch (e) {
      log("Error in createPurchaseRecord: $e");
      return ApiResponse.error("Failed to create purchase record: $e");
    }
  }
}




//--------------- Expense repository

