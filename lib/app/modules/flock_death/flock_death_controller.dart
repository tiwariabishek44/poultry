import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/dashboard/dashboard_controller.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/flock_death_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/death_cause_drop_down.dart';
import 'package:poultry/app/widget/loading_State.dart';

class FlockDeathController extends GetxController {
  static FlockDeathController get instance => Get.find();

  final _flockDeathRepository = FlockDeathRepository();
  final _loginController = Get.find<LoginController>();
  final batchesDropDownController = Get.put(BatchesDropDownController());
  final deathCauseController = Get.put(DeathCauseDropdownController());

  // Loading state
  final isLoading = false.obs;

  // Form field values
  final deathCount = ''.obs;
  final notes = ''.obs;

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Death...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> recordFlockDeath({
    required String deathCount,
    String? notes,
  }) async {
    final adminId = _loginController.adminUid;
    final selectedCause = deathCauseController.selectedCause.value;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    if (selectedCause.isEmpty) {
      CustomDialog.showError(
        message: 'Please select cause of death.',
      );
      return;
    }

    final selectedBatchId = batchesDropDownController.selectedBatchId.value;
    if (selectedBatchId.isEmpty) {
      CustomDialog.showError(
        message: 'Please select a batch first.',
      );
      return;
    }
    if (selectedCause.isEmpty) {
      CustomDialog.showError(
        message: 'Please select a Death Cause.',
      );
      return;
    }

    _showLoadingDialog();
    isLoading.value = true;

    try {
      final response = await _flockDeathRepository.recordFlockDeath(
        batchId: selectedBatchId,
        adminId: adminId,
        deathCount: int.parse(deathCount),
        cause: selectedCause,
        notes: notes,
      );

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        // Print success response
        log("========= Death Record Success =========");
        log("Death ID: ${response.response?.deathId}");
        log("Batch ID: ${response.response?.batchId}");
        log("Death Count: ${response.response?.deathCount}");
        log("Cause: ${response.response?.cause}");
        log("Date: ${response.response?.date}");
        if (response.response?.notes != null) {
          log("Notes: ${response.response?.notes}");
        }
        log("=======================================");

        // Show success dialog
        CustomDialog.showSuccess(
          message: 'Death record added successfully.',
          onConfirm: () {
            Get.back(); // Close success dialog
            _clearForm(); // Clear form fields after successful submission
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to record death',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording death',
      );
      log("Error recording death: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to clear form fields
  void _clearForm() {
    deathCount.value = '';
    notes.value = '';
    deathCauseController.reset();
  }

  String? validateDeathCount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter number of deaths';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid number';
    }
    if (int.parse(value) <= 0) {
      return 'Death count must be greater than 0';
    }
    return null;
  }
}
