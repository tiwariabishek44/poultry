// rice_husk_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/rice_husk_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class RiceHuskController extends GetxController {
  static RiceHuskController get instance => Get.find();

  final _riceHuskRepository = RiceHuskRepository();
  final _loginController = Get.find<LoginController>();
  final batchesDropDownController = Get.put(BatchesDropDownController());

  final formKey = GlobalKey<FormState>();
  final bagsController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void onClose() {
    bagsController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Rice Husk...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createRiceHuskRecord() async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
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

    if (bagsController.text.isEmpty || int.parse(bagsController.text) <= 0) {
      CustomDialog.showError(
        message: 'Please enter a valid number of bags.',
      );
      return;
    }

    _showLoadingDialog();

    try {
      final now = NepaliDateTime.now();

      final riceHuskData = {
        'batchId': selectedBatchId,
        'adminId': adminId,
        'yearMonth': now.toIso8601String().substring(0, 7),
        'date':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'totalBags': int.parse(bagsController.text),
        if (notesController.text.isNotEmpty) 'notes': notesController.text,
      };

      final response =
          await _riceHuskRepository.createRiceHuskRecord(riceHuskData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Rice Husk Record Success =========");
        log("Record ID: ${response.response?.ricehuskId}");
        log("Batch ID: ${response.response?.batchId}");
        log("Total Bags: ${response.response?.totalBags}");
        log("Date: ${response.response?.date}");
        log("=======================================");

        CustomDialog.showSuccess(
          message: 'Rice husk record created successfully.',
          onConfirm: () {
            Get.back();
            _clearForm();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to create rice husk record',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording rice husk',
      );
      log("Error creating rice husk record: $e");
    }
  }

  void _clearForm() {
    bagsController.clear();
    notesController.clear();
  }
}
