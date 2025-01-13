import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/analytics_page/analytics_controller.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/batch_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class AddBatchController extends GetxController {
  static AddBatchController get instance => Get.find();

  final _batchRepository = BatchRepository();
  final _loginController = Get.find<LoginController>();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final batchNameController = TextEditingController();
  final initialFlockController = TextEditingController();
  final startingDateController = TextEditingController();

  // Selected values
  final selectedStage = 'Broodidng'.obs;
  final selectedDate = NepaliDateTime.now().obs;

  // Loading state
  final isLoading = false.obs;

  // List of possible stages
  final List<String> stages = ['Broodidng', 'Grower', 'Layer'];

  @override
  void onClose() {
    batchNameController.dispose();
    initialFlockController.dispose();
    startingDateController.dispose();
    super.onClose();
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
      // Format date as YYYY-MM-DD
      startingDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Creating Batch...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createBatch() async {
    if (!formKey.currentState!.validate()) return;

    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    _showLoadingDialog();
    isLoading.value = true;

    try {
      final batchData = {
        'batchName': batchNameController.text,
        'initialFlockCount': int.parse(initialFlockController.text),
        'currentFlockCount': int.parse(initialFlockController.text),
        'totalDeath': 0,
        'startingDate': startingDateController.text,
        'stage': selectedStage.value,
        'adminId': adminId,
        'isActive': true,
      };

      final response = await _batchRepository.createBatch(batchData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Batch Creation Success =========");
        log("Batch Name: ${response.response?.batchName}");
        log("Initial Flock: ${response.response?.initialFlockCount}");
        log("Starting Date: ${response.response?.startingDate}");
        log("Stage: ${response.response?.stage}");
        log("Admin ID: ${response.response?.adminId}");
        log("Batch ID: ${response.response?.batchId}");
        log("=======================================");

        if (Get.isRegistered<AnalyticsController>()) {
          Get.find<AnalyticsController>().refreshBatches();
        }
        BatchStreamController.instance.notifyBatchUpdate();

        CustomDialog.showSuccess(
          message: 'Batch ${response.response?.batchName} created successfully',
          onConfirm: () => Get.back(),
        );

        _clearForm();
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to create batch',
        );
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(
        message: 'Something went wrong while creating the batch',
      );
      log("Error creating batch: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    batchNameController.clear();
    initialFlockController.clear();
    startingDateController.clear();
    selectedStage.value = 'Starter';
  }

  // Validation methods
  String? validateBatchName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter batch name';
    }
    return null;
  }

  String? validateInitialFlock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter initial flock count';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (int.parse(value) <= 0) {
      return 'Flock count must be greater than 0';
    }
    return null;
  }

  String? validateStartingDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select starting date';
    }
    return null;
  }
}
