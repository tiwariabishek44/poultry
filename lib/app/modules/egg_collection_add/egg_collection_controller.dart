import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/egg_collection_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

// class EggsCollectionController extends GetxController {
//   static EggsCollectionController get instance => Get.find();

//   final _eggCollectionRepository = EggCollectionRepository();
//   final _loginController = Get.find<LoginController>();
//   final batchesDropDownControler = Get.put(BatchesDropDownController());
//   final eggDropdownController = Get.put(EggDropdownController());
//   // Loading state

//   void _showLoadingDialog() {
//     Get.dialog(
//       Dialog(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         child: const LoadingState(text: 'Recording Collection...'),
//       ),
//       barrierDismissible: false,
//     );
//   }

//   Future<void> createEggCollection({
//     required String crates,
//     required String remaining,
//   }) async {
//     final adminId = _loginController.adminUid;

//     if (adminId == null) {
//       CustomDialog.showError(
//         message: 'Admin ID not found. Please login again.',
//       );
//       return;
//     }
//     final selectedBatchId = batchesDropDownControler.selectedBatchId.value;
//     if (selectedBatchId.isEmpty) {
//       CustomDialog.showError(
//         message: 'Please select a batch first.',
//       );
//       return;
//     }

//     if ((crates == "0" || crates.isEmpty) &&
//         (remaining == "0" || remaining.isEmpty)) {
//       CustomDialog.showError(
//         message: 'Please enter either crates or remaining eggs.',
//       );
//       return;
//     }
//     _showLoadingDialog();

//     try {
//       final DateTime now = NepaliDateTime.now();
//       final collectionData = {
//         'batchId': batchesDropDownControler
//             .selectedBatchId.value, // This should come from selected batch
//         'adminId': adminId,
//         'yearMonth': NepaliDateTime.now()
//             .toIso8601String()
//             .substring(0, 7), // This should be converted from current date
//         'collectionDate':
//             '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
//         'eggCategory': eggDropdownController.selectedCategory.value,
//         'eggSize': '',
//         'totalCrates': int.parse(crates),
//         'remainingEggs': int.parse(remaining),
//         'henCount': batchesDropDownControler.currentFlockCount.value,
//       };

//       final response =
//           await _eggCollectionRepository.createEggCollection(collectionData);

//       Get.back(); // Close loading dialog

//       if (response.status == ApiStatus.SUCCESS) {
//         // Show success dialog
//         CustomDialog.showSuccess(
//           message: 'Egg collection recorded successfully.',
//           onConfirm: () {
//             Get.back();
//           },
//         );
//       } else {
//         Get.back(); // Close loading dialog

//         CustomDialog.showError(
//           message: response.message ?? 'Failed to record egg collection',
//         );
//       }
//     } catch (e) {
//       Get.back(); // Close loading dialog

//       Get.back(); // Close loading dialog
//       CustomDialog.showError(
//         message: 'Something went wrong while recording collection',
//       );
//       log("Error creating egg collection: $e");
//     }
//   }
// }

class EggsCollectionController extends GetxController {
  static EggsCollectionController get instance => Get.find();

  final _eggCollectionRepository = EggCollectionRepository();
  final _loginController = Get.find<LoginController>();
  final batchesDropDownControler = Get.put(BatchesDropDownController());

  // TextEditingControllers for each category
  final largePlusCratesController = TextEditingController();
  final largePlusRemainingController = TextEditingController();

  final largeCratesController = TextEditingController();
  final largeRemainingController = TextEditingController();

  final mediumCratesController = TextEditingController();
  final mediumRemainingController = TextEditingController();

  final smallCratesController = TextEditingController();
  final smallRemainingController = TextEditingController();

  final crackCratesController = TextEditingController();
  final crackRemainingController = TextEditingController();

  final wasteCratesController = TextEditingController();
  final wasteRemainingController = TextEditingController();

  @override
  void onClose() {
    // Dispose all controllers
    largePlusCratesController.dispose();
    largePlusRemainingController.dispose();
    largeCratesController.dispose();
    largeRemainingController.dispose();
    mediumCratesController.dispose();
    mediumRemainingController.dispose();
    smallCratesController.dispose();
    smallRemainingController.dispose();
    crackCratesController.dispose();
    crackRemainingController.dispose();
    wasteCratesController.dispose();
    wasteRemainingController.dispose();
    super.onClose();
  }

  // Helper function to calculate total eggs from crates and remaining
  int _calculateTotalEggs(String crates, String remaining) {
    final cratesCount = int.tryParse(crates) ?? 0;
    final remainingCount = int.tryParse(remaining) ?? 0;
    return (cratesCount * 30) + remainingCount;
  }

  // Helper function to check if at least one category has data
  bool hasAtLeastOneEntry() {
    return [
      largePlusCratesController,
      largePlusRemainingController,
      largeCratesController,
      largeRemainingController,
      mediumCratesController,
      mediumRemainingController,
      smallCratesController,
      smallRemainingController,
      crackCratesController,
      crackRemainingController,
      wasteCratesController,
      wasteRemainingController,
    ].any((controller) =>
        controller.text.isNotEmpty && int.tryParse(controller.text) != null);
  }

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

  Future<void> createEggCollection() async {
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

    if (!hasAtLeastOneEntry()) {
      CustomDialog.showError(
        message: 'Please enter at least one egg collection entry.',
      );
      return;
    }

    _showLoadingDialog();

    try {
      final DateTime now = NepaliDateTime.now();
      final collectionData = {
        'batchId': selectedBatchId,
        'adminId': adminId,
        'yearMonth': NepaliDateTime.now().toIso8601String().substring(0, 7),
        'collectionDate':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'totalLargePlusEggs': _calculateTotalEggs(
          largePlusCratesController.text,
          largePlusRemainingController.text,
        ),
        'totalLargeEggs': _calculateTotalEggs(
          largeCratesController.text,
          largeRemainingController.text,
        ),
        'totalMediumEggs': _calculateTotalEggs(
          mediumCratesController.text,
          mediumRemainingController.text,
        ),
        'totalSmallEggs': _calculateTotalEggs(
          smallCratesController.text,
          smallRemainingController.text,
        ),
        'totalCrackEggs': _calculateTotalEggs(
          crackCratesController.text,
          crackRemainingController.text,
        ),
        'totalWasteEggs': _calculateTotalEggs(
          wasteCratesController.text,
          wasteRemainingController.text,
        ),
        'henCount': batchesDropDownControler.currentFlockCount.value,
      };

      final response =
          await _eggCollectionRepository.createEggCollection(collectionData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        // Clear all controllers
        [
          largePlusCratesController,
          largePlusRemainingController,
          largeCratesController,
          largeRemainingController,
          mediumCratesController,
          mediumRemainingController,
          smallCratesController,
          smallRemainingController,
          crackCratesController,
          crackRemainingController,
          wasteCratesController,
          wasteRemainingController,
        ].forEach((controller) => controller.clear());

        CustomDialog.showSuccess(
          message: 'Egg collection recorded successfully.',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to record egg collection',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording collection',
      );
      log("Error creating egg collection: $e");
    }
  }
}
