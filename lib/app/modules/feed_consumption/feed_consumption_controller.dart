import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/feed_consumption_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:poultry/app/widget/feed_selection.dart';
import 'package:poultry/app/widget/loading_State.dart';

class FeedConsumptionController extends GetxController {
  static FeedConsumptionController get instance => Get.find();

  final _feedConsumptionRepository = FeedConsumptionRepository();
  final _loginController = Get.find<LoginController>();
  final batchesDropDownController = Get.put(BatchesDropDownController());
  final feedTypeSelectorController = Get.put(FeedTypeController());
  final selectedDateController = Get.put(DateSelectorController());

  // Loading state
  final isLoading = false.obs;

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Feed Consumption...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createFeedConsumption({
    required String quantityKg,
  }) async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    final selectedBatchId = batchesDropDownController.selectedBatchId.value;
    final selectedDate = NepaliDateFormat('yyyy-MM-dd')
        .format(selectedDateController.selectedDate.value);
    if (selectedBatchId.isEmpty) {
      CustomDialog.showError(
        message: 'Please select a batch first.',
      );
      return;
    }

    final selectedFeedType = feedTypeSelectorController.selectedFeedType.value;

    if (selectedFeedType.isEmpty) {
      CustomDialog.showError(
        message: 'Please select a feed type',
      );
      return;
    }

    _showLoadingDialog();
    isLoading.value = true;

    try {
      final consumptionData = {
        'batchId': selectedBatchId,
        'adminId': adminId,
        'yearMonth': selectedDate.substring(0, 7),
        'consumptionDate': selectedDate,
        'quantityKg': double.parse(quantityKg),
        'feedType': selectedFeedType,
      };

      final response = await _feedConsumptionRepository
          .createFeedConsumption(consumptionData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        // Print success response

        CustomDialog.showSuccess(
          message: 'Feed consumption recorded successfully.',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to record feed consumption',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording feed consumption',
      );
      log("Error creating feed consumption: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
