import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/batch_action_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class BatchOperationsController extends GetxController {
  static BatchOperationsController get instance => Get.find();

  final _batchOperationsRepository = BatchOperationsRepository();
  final _loginController = Get.find<LoginController>();

  // Observable states
  final isLoading = false.obs;
  final batchSummary = Rxn<Map<String, dynamic>>();
  final errorMessage = ''.obs;

  // Loading state dialog
  void _showLoadingDialog(String message) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingState(text: message),
      ),
      barrierDismissible: false,
    );
  }

  // Retire batch
  Future<void> retireBatch({
    required String batchId,
    String? notes,
  }) async {
    try {
      _showLoadingDialog('Retiring batch...');

      final now = NepaliDateTime.now();
      final retireDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final response = await _batchOperationsRepository.retireBatch(
        batchId: batchId,
        retireDate: retireDate,
        notes: notes,
      );

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Batch Retirement Success =========");
        log("Batch ID: $batchId");
        log("Retire Date: $retireDate");
        log("========================================");

        CustomDialog.showSuccess(
          message: 'Batch successfully retired',
          onConfirm: () {
            Get.back();
            // Navigate back to batch list or appropriate screen
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to retire batch',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while retiring batch',
      );
      log("Error retiring batch: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Add any initialization logic here if needed
  }
}
