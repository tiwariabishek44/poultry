import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class TransactionRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  // Helper method to get current time in HH:mm:ss format
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  Future<ApiResponse<TransactionResponseModel>> createTransaction(
      Map<String, dynamic> transactionData) async {
    try {
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.transactions,
      );

      transactionData['transactionId'] = docRef.id;

      final response =
          await _firebaseClient.postDocument<TransactionResponseModel>(
        collectionPath: FirebasePath.transactions,
        documentId: docRef.id,
        data: transactionData,
        responseType: (json) =>
            TransactionResponseModel.fromJson(json, transactionId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createTransaction: $e");
      return ApiResponse.error("Failed to create transaction: $e");
    }
  }

//  ------- creating payment transaction ---------
  Future<ApiResponse<TransactionResponseModel>> createPaymentTransaction({
    required String partyId,
    required String adminId,
    required double amount,
    required double currentCredit, // Added current credit parameter
    required String paymentMethod,
    required String transactionUnder,
    required String date,
    required String yearMonth,
    String? notes,
    String? bankDetails,
    required String remarks,
    required bool isMoneyReciving,
  }) async {
    try {
      log("Creating payment transaction for party: $partyId");

      // Calculate new balance after payment
      double newBalance = currentCredit - amount;

      // Get document reference for new transaction
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.transactions,
      );

      // Prepare transaction data
      final transactionData = TransactionResponseModel(
        transactionId: docRef.id,
        partyId: partyId,
        actionId: '',
        adminId: adminId,
        yearMonth: yearMonth,
        transactionDate: date,
        transactionType: isMoneyReciving ? 'PAYMENT_IN' : 'PAYMENT_OUT',
        totalAmount: amount,
        paymentMethod: paymentMethod,
        bankDetails: '',
        balance: newBalance, // This is the remaining credit after payment
        notes: notes,
        status: newBalance == 0 ? 'FULL_PAID' : 'PARTIAL_PAID',
        transactionUnder: '',
        remarks: remarks,
        unpaidAmount: 0.0,
        transactionTime: _getCurrentTime(), // Now just using time portion
      ).toJson();

      // Update party's credit amount
      final partyUpdate = {
        'creditAmount': newBalance, // Set the new credit balance directly
        'isCredited': newBalance >
            0, // Set isCredit to true if credit amount is greater than 0
      };

      return await _firebaseClient
          .updateRelatedDocuments<TransactionResponseModel>(
        primaryCollection: FirebasePath.transactions,
        primaryId: docRef.id,
        primaryUpdate: transactionData,
        relatedCollection: FirebasePath.parties,
        relatedId: partyId,
        relatedUpdate: partyUpdate,
        responseType: (json) =>
            TransactionResponseModel.fromJson(json, transactionId: docRef.id),
      );
    } catch (e) {
      log("Error creating payment transaction: $e");
      return ApiResponse.error("Failed to create payment transaction: $e");
    }
  }

// to create the business transction
  Future<ApiResponse<TransactionResponseModel>> createBusinessTransaction({
    required String partyId,
    required String adminId,
    required double totalAmount,
    required double paidAmount,
    required double currentCredit,
    required String paymentMethod,
    required String transactionUnder,
    required String actionId,
    required String date,
    required String yearMonth,
    required String transactionType, // true for sale, false for purchase
    String? notes,
    String? bankDetails,
    required String remarks,
    required double unpaidAmount,
  }) async {
    try {
      log("Creating $transactionType transaction for party: $partyId");

      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.transactions,
      );

      // Calculate new credit and balance based on transaction type
      double remainingAmount = totalAmount - paidAmount;
      // For sales (isSale=true), credit increases when unpaid amount exists
      // For purchases (isSale=false), credit increases (as a negative value) when unpaid amount exists
      double newBalance = currentCredit + remainingAmount;

      String status = paidAmount == totalAmount
          ? 'FULL_PAID'
          : paidAmount == 0
              ? 'UNPAID'
              : 'PARTIAL_PAID';

      // Prepare transaction data
      final transactionData = TransactionResponseModel(
        transactionId: docRef.id,
        partyId: partyId,
        actionId: actionId,
        adminId: adminId,
        yearMonth: yearMonth,
        transactionDate: date,
        transactionType: transactionType,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        bankDetails: bankDetails ?? '',
        balance: newBalance, // This is the new total credit after transaction
        notes: notes,
        status: status,
        transactionUnder: transactionUnder,
        remarks: remarks,
        unpaidAmount: unpaidAmount,
        transactionTime: _getCurrentTime(), // Now just using time portion
      ).toJson();

      // Update party with new credit amount
      final partyUpdate = {
        'creditAmount': newBalance,
        'isCredited': newBalance !=
            0, // Set isCredit to true if there's any credit (positive or negative)
      };

      return await _firebaseClient
          .updateRelatedDocuments<TransactionResponseModel>(
        primaryCollection: FirebasePath.transactions,
        primaryId: docRef.id,
        primaryUpdate: transactionData,
        relatedCollection: FirebasePath.parties,
        relatedId: partyId,
        relatedUpdate: partyUpdate,
        responseType: (json) =>
            TransactionResponseModel.fromJson(json, transactionId: docRef.id),
      );
    } catch (e) {
      log("Error creating $transactionType transaction: $e");
      return ApiResponse.error(
          "Failed to create $transactionType transaction: $e");
    }
  }

  Future<ApiResponse<TransactionResponseModel>> createExpenseTransaction({
    required String adminId,
    required double amount,
    required String paymentMethod,
    required String transactionUnder,
    required String actionId,
    required String date,
    required String yearMonth,
    String? notes,
    required String remarks,
    required String category,
  }) async {
    try {
      log("Creating expense transaction");

      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.transactions,
      );

      // Prepare transaction data
      final transactionData = TransactionResponseModel(
        transactionId: docRef.id,
        partyId: '', // Empty for expenses
        actionId: actionId,
        adminId: adminId,
        yearMonth: yearMonth,
        transactionDate: date,
        transactionType: 'EXPENSE',
        totalAmount: amount,
        paymentMethod: paymentMethod,
        bankDetails: '',
        balance: 0, // No balance for expenses
        notes: '',
        status: 'PAID', // Expenses are always paid
        transactionUnder: '',
        remarks: remarks,
        unpaidAmount: 0, // No unpaid amount for expenses
        transactionTime: _getCurrentTime(),
      ).toJson();

      return await _firebaseClient.postDocument<TransactionResponseModel>(
        collectionPath: FirebasePath.transactions,
        documentId: docRef.id,
        data: transactionData,
        responseType: (json) =>
            TransactionResponseModel.fromJson(json, transactionId: docRef.id),
      );
    } catch (e) {
      log("Error creating expense transaction: $e");
      return ApiResponse.error("Failed to create expense transaction: $e");
    }
  }
}
