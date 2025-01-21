import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final deathCountController = TextEditingController();
  final yearController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();

  // Observable values
  final remainingFlock = 0.obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize death count to 0
    deathCountController.text = '0';
    updateRemainingFlock();
  }

  @override
  void onClose() {
    batchNameController.dispose();
    initialFlockController.dispose();
    deathCountController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    super.onClose();
  }

  void updateRemainingFlock() {
    int initialFlock = int.tryParse(initialFlockController.text) ?? 0;
    int deathCount = int.tryParse(deathCountController.text) ?? 0;
    remainingFlock.value = initialFlock - deathCount;
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
      // Format date from individual components
      String formattedDate =
          '${yearController.text}-${monthController.text.padLeft(2, '0')}-${dayController.text.padLeft(2, '0')}';

      final batchData = {
        'batchName': batchNameController.text,
        'initialFlockCount': int.parse(initialFlockController.text),
        'currentFlockCount': remainingFlock.value,
        'totalDeath': int.parse(deathCountController.text),
        'startingDate': formattedDate,
        'stage': '', // Empty stage as requested
        'adminId': adminId,
        'isActive': true,
      };

      final response = await _batchRepository.createBatch(batchData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        Get.put(ActiveBatchStreamController()).refreshStreams();

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
    deathCountController.text = '0';
    yearController.clear();
    monthController.clear();
    dayController.clear();
    remainingFlock.value = 0;
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

  String? validateDeathCount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter death count';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    int deathCount = int.parse(value);
    int initialFlock = int.tryParse(initialFlockController.text) ?? 0;
    if (deathCount < 0) {
      return 'Death count cannot be negative';
    }
    if (deathCount > initialFlock) {
      return 'Death count cannot exceed initial flock';
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter year';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid year';
    }
    int year = int.parse(value);
    if (year < 2070 || year > 2090) {
      return 'Year must be between 2070 and 2090';
    }
    return null;
  }

  String? validateMonth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter month';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid month';
    }
    int month = int.parse(value);
    if (month < 1 || month > 12) {
      return 'Month must be between 1 and 12';
    }
    return null;
  }

  String? validateDay(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter day';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid day';
    }
    int day = int.parse(value);
    int month = int.tryParse(monthController.text) ?? 0;
    int year = int.tryParse(yearController.text) ?? 0;

    // Get maximum days for given month
    int maxDays = 32; // Default for safety
    if (month >= 1 && month <= 12) {
      if (month == 1 ||
          month == 3 ||
          month == 5 ||
          month == 7 ||
          month == 8 ||
          month == 10 ||
          month == 12) {
        maxDays = 31;
      } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        maxDays = 30;
      } else if (month == 2) {
        // Handle Nepali calendar's Falgun month
        maxDays = 29;
      }
    }

    if (day < 1 || day > maxDays) {
      return 'Invalid day for selected month';
    }
    return null;
  }
}
