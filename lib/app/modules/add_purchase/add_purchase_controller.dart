import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/purchase_repsonse_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class PurchaseController extends GetxController {
  static PurchaseController get instance => Get.find();
  final partyDetailController = Get.put(PartyController());
  final _loginController = Get.find<LoginController>();

  // Observable lists and values
  final selectedItems = <PurchaseItem>[].obs;
  final totalAmount = 0.0.obs;
  final dueAmount = 0.0.obs;
  final isServicePurchase = false.obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final paidAmount = TextEditingController();
  final notes = TextEditingController();
  final invoiceNumber = TextEditingController();
  final partyId = ''.obs;
  final partyCurrentCredit = 0.0.obs;

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Purchase...'),
      ),
      barrierDismissible: false,
    );
  }

  void addPurchaseItem(PurchaseItem item) {
    selectedItems.add(item);
    calculateTotal();
  }

  void removePurchaseItem(int index) {
    selectedItems.removeAt(index);
    calculateTotal();
  }

  void onPaidAmountChanged(String value) {
    calculateTotal();
  }

  void calculateTotal() {
    totalAmount.value = selectedItems.fold(0, (sum, item) => sum + item.total);
    dueAmount.value =
        totalAmount.value - (double.tryParse(paidAmount.text) ?? 0);
  }

  String get paymentStatus {
    if (dueAmount.value <= 0) return 'FULL';
    if (dueAmount.value >= totalAmount.value) return 'CREDIT';
    return 'PARTIAL';
  }

  Future<void> createPurchaseRecord() async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    if (selectedItems.isEmpty) {
      CustomDialog.showError(
        message: 'Please add at least one item to the purchase.',
      );
      return;
    }

    if (partyId.value.isEmpty) {
      CustomDialog.showError(
        message: 'Please enter party details.',
      );
      return;
    }

    _showLoadingDialog();

    try {
      final DateTime now = NepaliDateTime.now();
      final purchaseData = {
        'partyId': partyId.value,
        'adminId': adminId,
        'yearMonth': now.toIso8601String().substring(0, 7),
        'purchaseDate':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'purchaseItems': selectedItems.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount.value,
        'paidAmount': double.tryParse(paidAmount.text) ?? 0.0,
        'dueAmount': dueAmount.value,
        'paymentStatus': paymentStatus,
        'isServicePurchase': isServicePurchase.value,
        if (invoiceNumber.text.isNotEmpty) 'invoiceNumber': invoiceNumber.text,
        if (notes.text.isNotEmpty) 'notes': notes.text,
      };

      // TODO: Implement purchase record creation with repository
      // For now, just show success dialog
      Get.back(); // Close loading dialog
      CustomDialog.showSuccess(
        message: 'Purchase record created successfully.',
        onConfirm: () {
          Get.back();
          _clearForm();
        },
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording purchase',
      );
      log("Error creating purchase record: $e");
    }
  }

  void _clearForm() {
    selectedItems.clear();
    paidAmount.clear();
    notes.clear();
    invoiceNumber.clear();
    partyId.value = '';
    totalAmount.value = 0.0;
    dueAmount.value = 0.0;
    isServicePurchase.value = false;
  }

  @override
  void onClose() {
    paidAmount.dispose();
    notes.dispose();
    invoiceNumber.dispose();
    partyId.value = '';
    super.onClose();
  }
}
