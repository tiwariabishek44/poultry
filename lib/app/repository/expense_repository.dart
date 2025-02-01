// expense_repository.dart

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/expense_reposnse_model.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class ExpenseRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Create a new expense record
  Future<ApiResponse<ExpenseResponseModel>> createExpenseRecord(
      Map<String, dynamic> expenseData) async {
    try {
      log("Creating expense record: $expenseData");

      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.expenses);

      expenseData['expenseId'] = docRef.id;

      final response = await _firebaseClient.postDocument<ExpenseResponseModel>(
        collectionPath: FirebasePath.expenses,
        documentId: docRef.id,
        data: expenseData,
        responseType: (json) =>
            ExpenseResponseModel.fromJson(json, expenseId: docRef.id),
      );

      if (response.status == ApiStatus.SUCCESS) {
        // Create an expense transaction
        await _transactionRepository.createExpenseTransaction(
          adminId: expenseData['adminId'],
          amount: expenseData['amount'],
          paymentMethod: expenseData['paymentMethod'],
          transactionUnder:
              expenseData['bankName'] ?? expenseData['walletName'] ?? '',
          actionId: docRef.id,
          date: expenseData['expenseDate'],
          yearMonth: expenseData['yearMonth'],
          notes: expenseData['notes'],
          remarks: 'Expense: ${expenseData['category']}',
          category: expenseData['category'],
        );
      }

      return response;
    } catch (e) {
      log("Error in createExpenseRecord: $e");
      return ApiResponse.error("Failed to create expense record: $e");
    }
  }
}
