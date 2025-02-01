// lib/app/modules/flock_medication/flock_medication_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/medicine_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:poultry/app/widget/loading_State.dart';

class FlockMedicationController extends GetxController {
  static FlockMedicationController get instance => Get.find();

  final _medicationRepository = FlockMedicationRepository();
  final _loginController = Get.find<LoginController>();
  final selectedDateController = Get.put(DateSelectorController());
  final batchesDropDownController = Get.put(BatchesDropDownController());

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Create new medication record
  Future<void> createMedication(String medicineName) async {
    final selectedBatchId = batchesDropDownController.selectedBatchId.value;

    final selectedDate = NepaliDateFormat('yyyy-MM-dd')
        .format(selectedDateController.selectedDate.value);
    if (selectedBatchId.isEmpty) {
      CustomDialog.showError(
        message: 'Please select a batch first.',
      );
      return;
    }

    final adminId = _loginController.adminUid;
    if (adminId == null) {
      CustomDialog.showError(
          message: 'Admin ID not found. Please login again.');
      return;
    }

    Get.dialog(
      const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingState(text: 'Adding Medication Record...'),
      ),
      barrierDismissible: false,
    );

    try {
      final medicationData = {
        'batchId': selectedBatchId,
        'adminId': adminId,
        'medicineName': medicineName,
        'date': selectedDate,
      };

      final response =
          await _medicationRepository.createMedication(medicationData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        CustomDialog.showSuccess(
          message: 'Medication record added successfully',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to add medication record',
        );
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(
          message: 'Something went wrong while adding the medication record');
      log("Error creating medication record: $e");
    }
  }
}
