// payment_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/modules/transction_main_screen/transction_controller.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final _transactionRepository = TransactionRepository();
  final _loginController = Get.find<LoginController>();
  final partyDetailController = Get.put(PartyController());
  final controller = Get.put(TransactionsController());

  // Form key
  final formKey = GlobalKey<FormState>();

  // Form Controllers
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  final bankDetailsController = TextEditingController();
  final dateController = TextEditingController();

  // Observables
  final selectedPaymentMethod = 'CASH'.obs;
  final selectedTransactionUnder = ''.obs;
  final selectedDate = NepaliDateTime.now().obs;
  final isLoading = false.obs;
  final isCustomer = true.obs;
  final totalCredit = 0.0.obs;
  final remainingAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _updateDateDisplay();
    // Add listener to amountController
    amountController.addListener(() {
      calculateRemainingAmount();
    });
  }

  void calculateRemainingAmount() {
    double currentAmount = double.tryParse(amountController.text) ?? 0;
    remainingAmount.value = totalCredit.value - currentAmount;
  }

  Future<void> pickDate() async {
    final NepaliDateTime? picked = await showMaterialDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: NepaliDateTime(2070),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      _updateDateDisplay();
    }
  }

  void _updateDateDisplay() {
    dateController.text =
        '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Payment...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> recordPayment(
      String partyId, double currentCredit, String partyName) async {
    if (!formKey.currentState!.validate()) return;

    final adminId = _loginController.adminUid;
    if (adminId == null) {
      CustomDialog.showError(
          message: 'Admin ID not found. Please login again.');
      return;
    }

    _showLoadingDialog();

    try {
      final amount = double.parse(amountController.text);

      final response = await _transactionRepository.createPaymentTransaction(
          partyId: partyId,
          adminId: adminId,
          amount: amount,
          date: dateController.text,
          yearMonth: '${selectedDate.value.year}-${selectedDate.value.month}',
          currentCredit: currentCredit,
          paymentMethod: selectedPaymentMethod.value,
          transactionUnder: selectedTransactionUnder.value,
          notes: notesController.text.isEmpty ? '' : notesController.text,
          bankDetails: bankDetailsController.text.isEmpty
              ? ''
              : bankDetailsController.text,
          remarks: isCustomer.value
              ? 'Money Recive From    $partyName'
              : 'Money Give To    $partyName',
          isMoneyReciving: isCustomer.value);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        partyDetailController.fetchPartyDetails(partyId);
        partyDetailController.fetchParties();
        controller.fetchCurrentMonthTransactions();

        CustomDialog.showSuccess(
          message: 'Payment recorded successfully.',
          onConfirm: () {
            Get.back();
            _clearForm();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to record payment',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording payment',
      );
    }
  }

  void _clearForm() {
    amountController.clear();
    notesController.clear();
    bankDetailsController.clear();
    selectedPaymentMethod.value = 'CASH';
    selectedTransactionUnder.value = '';
    selectedDate.value = NepaliDateTime.now();
    _updateDateDisplay();
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    bankDetailsController.dispose();
    dateController.dispose();
    super.onClose();
  }

  // Validation methods
  String? validateAmount(String? value, double currentCredit) {
    if (value == null || value.isEmpty) {
      return 'कृपया रकम प्रविष्ट गर्नुहोस्';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'कृपया मान्य रकम प्रविष्ट गर्नुहोस्';
    }
    if (amount > currentCredit.toInt()) {
      log(" this is the about   ${amount}  ${currentCredit}");
      return 'रकम क्रेडिट भन्दा बढी हुन सक्दैन';
    }
    return null;
  }
}
