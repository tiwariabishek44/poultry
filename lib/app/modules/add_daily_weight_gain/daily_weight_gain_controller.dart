import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/daily_weight_gain._repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:poultry/app/widget/loading_State.dart';

class DailyWeightGainController extends GetxController {
  static DailyWeightGainController get instance => Get.find();

  final DailyWeightGainRepository _repository = DailyWeightGainRepository();
  final controller = Get.put(BatchesDropDownController());
  final DateSelectorController dateSelectorController =
      Get.put(DateSelectorController());
  // Observable list of daily weight gain records
  final dailyWeightGainList = <DailyWeightGainResponseModel>[].obs;
  final _loginController = Get.find<LoginController>();

  // Loading state
  final isLoading = false.obs;

  // Error state
  final error = RxString('');

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Loading...'),
      ),
      barrierDismissible: false,
    );
  }

  // Create a new daily weight gain record
  Future<void> createDailyWeightGain({
    required double weight,
  }) async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }
    if (controller.selectedBatchId.value.isEmpty) {
      CustomDialog.showError(message: 'Please select a batch');
      return;
    }

    if (dateSelectorController.dateController.text.isEmpty) {
      CustomDialog.showError(message: 'Please select a date');
      return;
    }
    if (weight <= 0) {
      CustomDialog.showError(message: 'Please enter a Weight Gain');
      return;
    }
    try {
      isLoading.value = true;
      _showLoadingDialog();
      final response = await _repository.createDailyWeightGain(
        batchId: controller.selectedBatchId.value,
        adminId: adminId,
        weight: weight,
        date: dateSelectorController.dateController.text,
      );

      if (response.status == ApiStatus.SUCCESS) {
        Get.back(); // Close loading dialog
        CustomDialog.showSuccess(
            message: 'Daily weight gain recorded successfully!');
      } else {
        CustomDialog.showError(
            message: response.message ?? 'Failed to record daily weight gain');
      }
    } catch (e) {
      CustomDialog.showError(message: 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
