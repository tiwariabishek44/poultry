import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class TransactionFetchRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

// to fetch the transciton by party --------

  Future<ApiResponse<List<TransactionResponseModel>>> getPartyTransactions(
      String partyId) async {
    try {
      log("Fetching transactions for party: $partyId");

      return await _firebaseClient.getCollection<TransactionResponseModel>(
        collectionPath: FirebasePath.transactions,
        responseType: (json) => TransactionResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('partyId', isEqualTo: partyId),
      );
    } catch (e) {
      log("Error fetching party transactions: $e");
      return ApiResponse.error("Failed to fetch transactions: $e");
    }
  }

// to get the transaction by year and month
  Future<ApiResponse<List<TransactionResponseModel>>>
      getTransactionsByYearMonth(String yearMonth, String adminId) async {
    try {
      log("Fetching transactions for yearMonth: $yearMonth and adminId: $adminId");

      return await _firebaseClient.getCollection<TransactionResponseModel>(
        collectionPath: FirebasePath.transactions,
        responseType: (json) => TransactionResponseModel.fromJson(json),
        queryBuilder: (query) => query
            .where('yearMonth', isEqualTo: yearMonth)
            .where('adminId', isEqualTo: adminId),
      );
    } catch (e) {
      log("Error fetching transactions by yearMonth: $e");
      return ApiResponse.error("Failed to fetch transactions: $e");
    }
  }

  // Group transactions by date
  Map<String, List<TransactionResponseModel>> groupTransactionsByDate(
      List<TransactionResponseModel> transactions) {
    final groupedTransactions = <String, List<TransactionResponseModel>>{};

    for (var transaction in transactions) {
      final date =
          transaction.transactionDate.split('T')[0]; // Get date part only
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    return Map.fromEntries(groupedTransactions.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key)) // Sort by date descending
        );
  }
}
