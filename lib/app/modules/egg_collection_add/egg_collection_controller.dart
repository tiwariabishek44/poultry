import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/egg_collection_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/egg_category_dropdown.dart';
import 'package:poultry/app/widget/loading_State.dart';

class EggsCollectionController extends GetxController {
  static EggsCollectionController get instance => Get.find();

  final _eggCollectionRepository = EggCollectionRepository();
  final _loginController = Get.find<LoginController>();
  final batchesDropDownControler = Get.put(BatchesDropDownController());
  final eggDropdownController = Get.put(EggDropdownController());
  // Loading state

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Collection...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createEggCollection({
    required String crates,
    required String remaining,
  }) async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }
    final selectedBatchId = batchesDropDownControler.selectedBatchId.value;
    if (selectedBatchId.isEmpty) {
      CustomDialog.showError(
        message: 'Please select a batch first.',
      );
      return;
    }

    if ((crates == "0" || crates.isEmpty) &&
        (remaining == "0" || remaining.isEmpty)) {
      CustomDialog.showError(
        message: 'Please enter either crates or remaining eggs.',
      );
      return;
    }
    _showLoadingDialog();

    try {
      final DateTime now = NepaliDateTime.now();
      final collectionData = {
        'batchId': batchesDropDownControler
            .selectedBatchId.value, // This should come from selected batch
        'adminId': adminId,
        'yearMonth': NepaliDateTime.now()
            .toIso8601String()
            .substring(0, 7), // This should be converted from current date
        'collectionDate':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'eggCategory': eggDropdownController.selectedCategory.value,
        'eggSize': eggDropdownController.selectedSize.value,
        'totalCrates': int.parse(crates),
        'remainingEggs': int.parse(remaining),
        'henCount': batchesDropDownControler.currentFlockCount.value,
      };

      final response =
          await _eggCollectionRepository.createEggCollection(collectionData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        // Print success response
        log("========= Egg Collection Success =========");
        log("Collection ID: ${response.response?.collectionId}");
        log("Batch ID: ${response.response?.batchId}");
        log("Category: ${response.response?.eggCategory}");
        log("Size: ${response.response?.eggSize}");
        log("Total Crates: ${response.response?.totalCrates}");
        log("Remaining Eggs: ${response.response?.remainingEggs}");
        log("Total Eggs: ${response.response?.getTotalEggs()}");
        log("=======================================");
        Get.back(); // Close loading dialog

        // Show success dialog
        CustomDialog.showSuccess(
          message: 'Egg collection recorded successfully.',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        Get.back(); // Close loading dialog

        CustomDialog.showError(
          message: response.message ?? 'Failed to record egg collection',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog

      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording collection',
      );
      log("Error creating egg collection: $e");
    } finally {
      Get.back(); // Close loading dialog
    }
  }
}
