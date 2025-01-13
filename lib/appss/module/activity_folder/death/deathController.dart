import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropDown_controller.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class DeathEntryController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final batchDropDownControler = Get.put(BatchDropDownController());
  final deathCountController = TextEditingController();
  final remarksController = TextEditingController();
  final isLoading = false.obs;

  // For tracking batch details
  RxMap<String, dynamic> selectedBatchData = <String, dynamic>{}.obs;
  final selectBatchName = ''.obs;

  Stream<QuerySnapshot> getBatchesStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('batches')
        .where('adminUid', isEqualTo: adminUid)
        .snapshots();
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> submitDeathRecord() async {
    if (!validate()) return;

    try {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Saving record...'),
        ),
        barrierDismissible: false,
      );

      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        Get.back();
        Get.snackbar('Error', 'Admin data not found');
        return;
      }

      final deathCount = int.parse(deathCountController.text);
      final currentQuantity = batchDropDownControler.currentCount.value;
      final totalDeath = (batchDropDownControler.totaldeath.value) + deathCount;

      if (deathCount > currentQuantity) {
        Get.back();
        Get.snackbar(
          'Error',
          'Death count cannot be greater than current quantity (${currentQuantity})',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create death record
      final deathRef = _firestore.collection('deaths').doc();
      final deathData = {
        'deathId': deathRef.id,
        'adminUid': adminUid,
        'batchId': batchDropDownControler.selectedBatchId.value,
        'batchName':
            batchDropDownControler.selectedBatchName.value, // Add batch name
        'yearMonth': NepaliDateTime.now().toIso8601String().substring(0, 7),

        'poultryName': loginController.adminData.value?.farmName,
        'deathCount': deathCount,
        'remarks': remarksController.text.trim(),
        'recordedAt': formatNepaliDate(NepaliDateTime.now()),
        'createdAt': DateTime.now().toIso8601String(),
        'stage': batchDropDownControler.flockStage.value,
      };
      // Update batch statistics
      final batchRef = _firestore
          .collection('batches')
          .doc(batchDropDownControler.selectedBatchId.value);
      final batchUpdates = {
        'currentQuantity': currentQuantity - deathCount,
        'totalDeath': totalDeath,
      };

      // Perform both operations in a batch write
      final batch = _firestore.batch();
      batch.set(deathRef, deathData);
      batch.update(batchRef, batchUpdates);
      await batch.commit();

      Get.back();

      await SuccessDialog.show(
          title: 'Death Record Saved!',
          subtitle: 'Deaths: ${deathCount}',
          additionalInfo: '''Date: ${formatNepaliDate(NepaliDateTime.now())}
Remaining  : ${currentQuantity - deathCount}
Total Deaths: $totalDeath''',
          onButtonPressed: () {
            Get.back(); // Close success dialog
            Get.back(); // Go back to previous screen
            clearForm();
          });
    } catch (e) {
      Get.back();
      log('Error submitting death record: $e');
      Get.snackbar(
        'Error',
        'Failed to save death record',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    deathCountController.clear();
    remarksController.clear();
    selectedBatchData.clear();
  }

  bool validate() {
    if (batchDropDownControler.selectedBatchId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a batch',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (deathCountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter number of deaths',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    final deathCount = int.tryParse(deathCountController.text);
    if (deathCount == null || deathCount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid death count',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    deathCountController.dispose();
    remarksController.dispose();
    super.onClose();
  }
}
