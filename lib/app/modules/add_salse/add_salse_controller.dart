import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/salse_resonse_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/repository/salse_reposityro.dart';

import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class SalesController extends GetxController {
  static SalesController get instance => Get.find();
  final partyDetailController = Get.put(PartyController());

  final _salesRepository = SalesRepository();
  final _loginController = Get.find<LoginController>();

  // Observable lists and values
  final selectedItems = <SaleItem>[].obs;
  final totalAmount = 0.0.obs;
  final dueAmount = 0.0.obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final paidAmount = TextEditingController();
  final notes = TextEditingController();
  final partyId = ''.obs;
  final partyCurrentCredit = 0.0.obs;
  final partyName = ''.obs;

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Sale...'),
      ),
      barrierDismissible: false,
    );
  }

  void addSaleItem(SaleItem item) {
    selectedItems.add(item);
    calculateTotal();
  }

  void removeSaleItem(int index) {
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

  Future<void> createSaleRecord() async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    if (selectedItems.isEmpty) {
      CustomDialog.showError(
        message: 'Please add at least one item to the sale.',
      );
      return;
    }

    if (partyId.value.isEmpty) {
      CustomDialog.showError(
        message: 'Please enter party/customer details.',
      );
      return;
    }

    _showLoadingDialog();
    // Generate remarks with party name and items
    final itemNames = selectedItems.map((item) => item.itemName).toList();
    final remarks = '${partyName.value}: ${itemNames.join(", ")}';

    try {
      final DateTime now = NepaliDateTime.now();
      final saleData = {
        'partyId': partyId.value,
        'adminId': adminId,
        'yearMonth': now.toIso8601String().substring(0, 7),
        'saleDate':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'saleItems': selectedItems.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount.value,
        'paidAmount': double.tryParse(paidAmount.text) ?? 0.0,
        'dueAmount': dueAmount.value,
        'paymentStatus': paymentStatus,
        if (notes.text.isNotEmpty) 'notes': notes.text,
      };

      final response = await _salesRepository.createSaleRecord(
          saleData, partyCurrentCredit.value, remarks);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        partyDetailController.fetchPartyDetails(partyId.value);
        partyDetailController.fetchParties();

        CustomDialog.showSuccess(
          message: 'Sale record created successfully.',
          onConfirm: () {
            Get.back();
            _clearForm();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to create sale record',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording sale',
      );
      log("Error creating sale record: $e");
    }
  }

  void _clearForm() {
    selectedItems.clear();
    paidAmount.clear();
    notes.clear();
    partyId.value = '';
    totalAmount.value = 0.0;
    dueAmount.value = 0.0;
  }

  @override
  void onClose() {
    paidAmount.dispose();
    notes.dispose();
    partyId.value = '';
    super.onClose();
  }
}
