// batch_finance_controller.dart

import 'package:get/get.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/repository/batch_finance_repository.dart';

class BatchFinanceController extends GetxController {
  static BatchFinanceController get instance => Get.find();
  final _batchFinanceRepository = BatchFinanceRepository();
  final currentAdmin = Get.find<LoginController>().currentAdmin.value;

  // Observable values
  final isLoading = false.obs;
  final batchId = ''.obs;
  final startDate = ''.obs;
  final endDate = ''.obs;
  final totalPurchases = 0.0.obs;
  final totalExpenses = 0.0.obs;
  final totalSales = 0.0.obs;
  final profit = 0.0.obs;
  final expensesByCategory = <String, double>{}.obs;
  final salesByCategory = <String, double>{}.obs;
  final purchasesByItem = <String, double>{}.obs;

  // Load batch finance summary
  Future<void> loadBatchFinanceSummary(String id) async {
    try {
      isLoading.value = true;
      batchId.value = id;

      final response = await _batchFinanceRepository.getBatchFinanceSummary(id);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        final summary = response.response!;

        // Update observable values
        startDate.value = summary.startDate;
        endDate.value = summary.endDate;
        totalPurchases.value = summary.totalPurchases;
        totalExpenses.value = summary.totalExpenses;
        totalSales.value = summary.totalSales;
        profit.value = summary.profit;
        expensesByCategory.assignAll(summary.expensesByCategory);
        salesByCategory.assignAll(summary.salesByCategory);
        purchasesByItem.assignAll(summary.purchasesByItem);
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to load batch finance summary',
        );
      }
    } catch (e) {
      CustomDialog.showError(
        message: 'Error loading batch finance summary',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get formatted currency string
  String formatCurrency(double amount) {
    return 'Rs. ${amount.toStringAsFixed(2)}';
  }

  // Get the top expense categories
  List<MapEntry<String, double>> get topExpenseCategories {
    final sortedEntries = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  // Get the top selling categories
  List<MapEntry<String, double>> get topSellingCategories {
    final sortedEntries = salesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  // Get the top purchased items
  List<MapEntry<String, double>> get topPurchasedItems {
    final sortedEntries = purchasesByItem.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  // Calculate expense percentage for a category
  double getExpensePercentage(String category) {
    if (totalExpenses.value == 0) return 0;
    return (expensesByCategory[category] ?? 0) / totalExpenses.value * 100;
  }

  // Calculate sales percentage for a category
  double getSalesPercentage(String category) {
    if (totalSales.value == 0) return 0;
    return (salesByCategory[category] ?? 0) / totalSales.value * 100;
  }

  // Calculate purchase percentage for an item
  double getPurchasePercentage(String itemName) {
    if (totalPurchases.value == 0) return 0;
    return (purchasesByItem[itemName] ?? 0) / totalPurchases.value * 100;
  }

  // Calculate profit margin percentage
  double get profitMarginPercentage {
    if (totalSales.value == 0) return 0;
    return (profit.value / totalSales.value) * 100;
  }

  // Get date duration string
  String get batchDuration {
    if (startDate.value.isEmpty) return 'N/A';
    return '${startDate.value} - ${endDate.value.isEmpty ? 'Present' : endDate.value}';
  }
}
