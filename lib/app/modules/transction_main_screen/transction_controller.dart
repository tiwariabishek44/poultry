import 'dart:developer';

import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/transction_fetch_repositoyr.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';

class TransactionsController extends GetxController {
  static TransactionsController get instance => Get.find();
  final _transactionRepo = TransactionFetchRepository();
  final _loginController = Get.find<LoginController>();

  final transactions = <TransactionResponseModel>[].obs;
  final filteredTransactions = <TransactionResponseModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs;
  final selectedYearMonth = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentMonthTransactions();
  }

  // Using the same helper method from PartyController
  DateTime _getFullDateTime(String date, String time) {
    try {
      final dateTime = DateTime.parse(date);
      final timeParts = time.split(':');

      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        int.parse(timeParts[0]), // hours
        int.parse(timeParts[1]), // minutes
        int.parse(timeParts[2]), // seconds
      );
    } catch (e) {
      log("Error parsing date/time: $e");
      return DateTime.parse(
          date); // Fallback to just date if time parsing fails
    }
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  Future<void> fetchCurrentMonthTransactions() async {
    isLoading.value = true;
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        CustomDialog.showError(
            message: 'Admin ID not found. Please login again.');
        return;
      }

      final now = NepaliDateTime.now();
      final yearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

      final response = await _transactionRepo.getTransactionsByYearMonth(
          selectedYearMonth.value == '' ? yearMonth : selectedYearMonth.value,
          adminId);

      if (response.status == ApiStatus.SUCCESS) {
        var sortedTransactions = response.response ?? [];

        // Sort by date and time exactly like in PartyController
        sortedTransactions.sort((a, b) {
          final aDateTime =
              _getFullDateTime(a.transactionDate, a.transactionTime);
          final bDateTime =
              _getFullDateTime(b.transactionDate, b.transactionTime);
          return bDateTime
              .compareTo(aDateTime); // Descending order (recent first)
        });

        transactions.value = sortedTransactions;
        _applyFilter();
      } else {
        CustomDialog.showError(
            message: response.message ?? 'Failed to fetch transactions');
      }
    } catch (e) {
      log("Error fetching transactions: $e");
      CustomDialog.showError(message: 'Error fetching transactions');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    // Apply filter but maintain the sorting
    filteredTransactions.value = transactions.where((transaction) {
      if (transaction.transactionType == 'OPENING_BALANCE') {
        return false;
      }

      switch (selectedFilter.value) {
        case 'all':
          return true;
        case 'sale':
          return transaction.transactionType == 'SALE';
        case 'purchase':
          return transaction.transactionType == 'PURCHASE';
        case 'payment_in':
          return transaction.transactionType == 'PAYMENT_IN';
        case 'payment_out':
          return transaction.transactionType == 'PAYMENT_OUT';
        case 'expense':
          return transaction.transactionType == 'EXPENSE';
        default:
          return true;
      }
    }).toList();
  }
}
