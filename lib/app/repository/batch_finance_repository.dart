// batch_finance_repository.dart

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/service/api_client.dart';

class BatchFinanceSummary {
  final String batchId;
  final String startDate; // Added date fields
  final String endDate; // Added date fields
  final double totalPurchases;
  final double totalExpenses;
  final double totalSales;
  final double profit;
  final Map<String, double> expensesByCategory;
  final Map<String, double> salesByCategory;
  final Map<String, double> purchasesByItem;

  BatchFinanceSummary({
    required this.batchId,
    required this.startDate,
    required this.endDate,
    required this.totalPurchases,
    required this.totalExpenses,
    required this.totalSales,
    required this.profit,
    required this.expensesByCategory,
    required this.salesByCategory,
    required this.purchasesByItem,
  });

  factory BatchFinanceSummary.fromJson(Map<String, dynamic> json) {
    return BatchFinanceSummary(
      batchId: json['batchId'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalPurchases: (json['totalPurchases'] ?? 0.0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0.0).toDouble(),
      totalSales: (json['totalSales'] ?? 0.0).toDouble(),
      profit: (json['profit'] ?? 0.0).toDouble(),
      expensesByCategory:
          Map<String, double>.from(json['expensesByCategory'] ?? {}),
      salesByCategory: Map<String, double>.from(json['salesByCategory'] ?? {}),
      purchasesByItem: Map<String, double>.from(json['purchasesByItem'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'startDate': startDate,
      'endDate': endDate,
      'totalPurchases': totalPurchases,
      'totalExpenses': totalExpenses,
      'totalSales': totalSales,
      'profit': profit,
      'expensesByCategory': expensesByCategory,
      'salesByCategory': salesByCategory,
      'purchasesByItem': purchasesByItem,
    };
  }
}

class BatchFinanceRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<BatchFinanceSummary>> getBatchFinanceSummary(
      String batchId) async {
    try {
      log("Fetching financial summary for batch: $batchId");

      // First, get batch details to get dates
      final batchResponse = await _firebaseClient.getDocument(
        collectionPath: FirebasePath.batches,
        documentId: batchId,
        responseType: (json) => json,
      );

      if (batchResponse.status != ApiStatus.SUCCESS) {
        return ApiResponse.error("Failed to fetch batch details");
      }

      final batchData = batchResponse.response!;
      final startDate = batchData['startingDate'] ?? '';
      final endDate = batchData['retireDate'] ?? '';

      // Get purchases for the batch
      final purchasesResponse = await _firebaseClient.getCollection(
        collectionPath: FirebasePath.purchases,
        queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        responseType: (json) => json,
      );

      // Get sales for the batch
      final salesResponse = await _firebaseClient.getCollection(
        collectionPath: FirebasePath.sales,
        queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        responseType: (json) => json,
      );

      // Get expenses for the batch
      final expensesResponse = await _firebaseClient.getCollection(
        collectionPath: FirebasePath.expenses,
        queryBuilder: (query) => query.where('batchId', isEqualTo: batchId),
        responseType: (json) => json,
      );

      if (purchasesResponse.status == ApiStatus.SUCCESS &&
          salesResponse.status == ApiStatus.SUCCESS &&
          expensesResponse.status == ApiStatus.SUCCESS) {
        // Initialize aggregation variables
        double totalPurchases = 0;
        double totalExpenses = 0;
        double totalSales = 0;
        Map<String, double> expensesByCategory = {};
        Map<String, double> salesByCategory = {};
        Map<String, double> purchasesByItem = {};

        // Process purchases
        for (var purchase in purchasesResponse.response ?? []) {
          totalPurchases += (purchase['totalAmount'] ?? 0).toDouble();

          // Categorize purchase items
          final items = (purchase['purchaseItems'] as List<dynamic>?) ?? [];
          for (var item in items) {
            final itemName = item['itemName'] as String;
            final total = (item['total'] ?? 0).toDouble();
            purchasesByItem[itemName] =
                (purchasesByItem[itemName] ?? 0) + total;
          }
        }

        // Process sales
        for (var sale in salesResponse.response ?? []) {
          totalSales += (sale['totalAmount'] ?? 0).toDouble();

          final items = (sale['saleItems'] as List<dynamic>?) ?? [];
          for (var item in items) {
            final category = item['category'] as String;
            final total = (item['total'] ?? 0).toDouble();
            salesByCategory[category] =
                (salesByCategory[category] ?? 0) + total;
          }
        }

        // Process expenses
        for (var expense in expensesResponse.response ?? []) {
          final amount = (expense['amount'] ?? 0).toDouble();
          totalExpenses += amount;

          final category = expense['category'] as String;
          expensesByCategory[category] =
              (expensesByCategory[category] ?? 0) + amount;
        }

        // Calculate final profit
        final profit = totalSales - (totalPurchases + totalExpenses);

        final summary = BatchFinanceSummary(
          batchId: batchId,
          startDate: startDate,
          endDate: endDate,
          totalPurchases: totalPurchases,
          totalExpenses: totalExpenses,
          totalSales: totalSales,
          profit: profit,
          expensesByCategory: expensesByCategory,
          salesByCategory: salesByCategory,
          purchasesByItem: purchasesByItem,
        );

        return ApiResponse.completed(summary);
      } else {
        return ApiResponse.error("Failed to fetch complete financial data");
      }
    } catch (e) {
      log("Error in getBatchFinanceSummary: $e");
      return ApiResponse.error("Failed to fetch batch finance summary: $e");
    }
  }
}
