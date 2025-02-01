// expense_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/transction_main_screen/transction_controller.dart';
import 'package:poultry/app/repository/expense_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class ExpenseController extends GetxController {
  static ExpenseController get instance => Get.find();
  final _expenseRepository = ExpenseRepository();
  final _loginController = Get.find<LoginController>();
  final controller = Get.put(TransactionsController());
  final selectedBatchController = Get.put(BatchesDropDownController());

  // Form values
  final expenseType = 'GENERAL'.obs; // 'BATCH' or 'GENERAL'
  final category = ''.obs;
  final paymentMethod = 'CASH'.obs; // 'CASH', 'BANK', 'WALLET'

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final notes = TextEditingController();
  final bankName = TextEditingController();
  final walletName = TextEditingController();

  // Categories list
  final expenseCategories = [
    'Staff Salary',
    'Water Bill',
    'Electricity Bill',
    'Doctor Bill',
    'Plumber Bill',
    'Electrician Bill',
    'Fuel Bill',
  ];

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Expense...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createExpenseRecord(String date, String yearMonth) async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    if (category.value.isEmpty) {
      CustomDialog.showError(
        message: 'Please select an expense category.',
      );
      return;
    }
    if (expenseType.value == 'batch' &&
        selectedBatchController.selectedBatchId.value == '') {
      CustomDialog.showError(
        message: 'Please select a batch.',
      );
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    _showLoadingDialog();

    try {
      final amount = double.parse(amountController.text);
      final expenseData = {
        'adminId': adminId,
        'yearMonth': yearMonth,
        'expenseDate': date,
        'category': category.value,
        'amount': amount,
        'paymentMethod': paymentMethod.value,
        'expenseType': expenseType.value,
        'batchId': expenseType.value == 'batch'
            ? selectedBatchController.selectedBatchId.value
            : '',
        if (notes.text.isNotEmpty) 'notes': notes.text,
        if (bankName.text.isNotEmpty) 'bankName': bankName.text,
        if (walletName.text.isNotEmpty) 'walletName': walletName.text,
      };

      final response =
          await _expenseRepository.createExpenseRecord(expenseData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        controller.fetchCurrentMonthTransactions();

        CustomDialog.showSuccess(
          message: 'Expense record created successfully.',
          onConfirm: () {
            Get.back();
            _clearForm();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to create expense record',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording expense',
      );
      log("Error creating expense record: $e");
    }
  }

  void _clearForm() {
    category.value = '';
    amountController.clear();
    notes.clear();
    bankName.clear();
    walletName.clear();
    paymentMethod.value = 'CASH';
    expenseType.value = 'GENERAL';
  }

  @override
  void onClose() {
    amountController.dispose();
    notes.dispose();
    bankName.dispose();
    walletName.dispose();
    super.onClose();
  }
}
