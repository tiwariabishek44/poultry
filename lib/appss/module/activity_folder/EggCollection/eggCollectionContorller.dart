import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropDown_controller.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class EggCollectionController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final batchDropDownControler = Get.put(BatchDropDownController());

  // final selectedBatch = ''.obs;
  final eggType = 'normal'.obs;
  final eggCategory = ''.obs;
  final isLoading = false.obs;
  final selectBatchName = ''.obs;
  final crateController = TextEditingController();
  final remainingEggsController = TextEditingController();

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

  Future<void> submitCollection() async {
    log("this is the current count  ${batchDropDownControler.currentCount.value}  ");
    if (!validate()) return;

    try {
      // close the keyboard
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Saving collection...'),
        ),
        barrierDismissible: false,
      );

      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        Get.back();
        Get.snackbar('Error', 'Admin data not found');
        return;
      }

      final collectionRef = _firestore.collection('eggCollections').doc();

      final total = ((int.tryParse(crateController.text) ?? 0) * 30) +
          (int.tryParse(remainingEggsController.text) ?? 0);
      log(' total egg is $total  and total hen is ${batchDropDownControler.currentCount.value}');

      log(' this is the efficency ${total / batchDropDownControler.currentCount.value}');

      final collectionData = {
        'collectionId': collectionRef.id,
        'adminUid': adminUid,
        'batchName':
            batchDropDownControler.selectedBatchName.value, // Add batch name
        'batchId': batchDropDownControler.selectedBatchId.value,
        'poultryName': loginController.adminData.value?.farmName,
        'eggType': eggType.value,
        'eggCategory': eggCategory.value,
        'crates': int.tryParse(crateController.text) ?? 0,
        'remainingEggs': int.tryParse(remainingEggsController.text) ?? 0,
        'totalEggs': total,
        'yearMonth': NepaliDateTime.now().toIso8601String().substring(0, 7),
        'collectedAt': formatNepaliDate(NepaliDateTime.now()),
        'createdAt': NepaliDateTime.now().toIso8601String(),
        'efficiency': (total / batchDropDownControler.currentCount.value)
            .toStringAsFixed(2),
      };

      await collectionRef.set(collectionData);

      Get.back(); // Close loading dialog

      await SuccessDialog.show(
          title: 'Collection Saved!',
          subtitle: 'Total Eggs: $total',
          additionalInfo: 'Date: ${formatNepaliDate(NepaliDateTime.now())}',
          onButtonPressed: () {
            Get.back(); // Close success dialog
            Get.back(); // Go back to previous screen
            clearForm();
          });
    } catch (e) {
      Get.back();
      log('Error submitting collection: $e');
      Get.snackbar(
        'Error',
        'Failed to save collection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    crateController.clear();
    remainingEggsController.clear();
    eggType.value = 'normal';
    eggCategory.value = '';
  }

  bool validate() {
    log(remainingEggsController.text);
    if (batchDropDownControler.selectedBatchId.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a batch',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: const EdgeInsets.all(8),
      );
      return false;
    }
    if (eggCategory.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select Egg Size',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: const EdgeInsets.all(8),
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    crateController.dispose();
    remainingEggsController.dispose();
    super.onClose();
  }
}
