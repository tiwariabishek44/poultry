import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropDown_controller.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class FeedConsumptionController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final batchDropDownControler = Get.put(BatchDropDownController());

  final feedPerHen = 0.0.obs;

  // Form controllers
  final totalFeedController = TextEditingController();

  // Get batches stream from Firestore
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

  Future<void> submitFeedConsumption() async {
    log(' the feed cateogyr is ${batchDropDownControler.currentFeed.value}');
    if (!validate()) return;

    try {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Saving feed consumption...'),
        ),
        barrierDismissible: false,
      );

      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        Get.back();
        Get.snackbar('Error', 'Admin data not found');
        return;
      }

      final consumptionRef = _firestore.collection('feedConsumptions').doc();

      final totalFeed = double.tryParse(totalFeedController.text) ?? 0.0;

      final consumptionData = {
        'consumptionId': consumptionRef.id,
        'adminUid': adminUid,
        'batchName': batchDropDownControler.selectedBatchName.value,
        'batchId': batchDropDownControler.selectedBatchId.value,
        'poultryName': loginController.adminData.value?.farmName,
        'feedCategory': batchDropDownControler.currentFeed.value,
        'totalFeed': totalFeed,
        'feedPerHen': feedPerHen.value,
        'yearMonth': NepaliDateTime.now().toIso8601String().substring(0, 7),
        'consumedAt': formatNepaliDate(NepaliDateTime.now()),
        'createdAt': NepaliDateTime.now().toIso8601String(),
        'stage': batchDropDownControler.flockStage.value,
      };

      await consumptionRef.set(consumptionData);

      Get.back(); // Close loading dialog

      await SuccessDialog.show(
          title: 'Consumption Saved!',
          subtitle: 'Total Feed: ${totalFeed.toStringAsFixed(2)} kg',
          additionalInfo: 'Date: ${formatNepaliDate(NepaliDateTime.now())}',
          onButtonPressed: () {
            Get.back(); // Close success dialog
            Get.back(); // Go back to previous screen
            clearForm();
          });
    } catch (e) {
      Get.back();
      log('Error submitting feed consumption: $e');
      Get.snackbar(
        'Error',
        'Failed to save feed consumption',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    totalFeedController.clear();
    feedPerHen.value = 0.0;
  }

  bool validate() {
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

    if (totalFeedController.text.isEmpty ||
        double.tryParse(totalFeedController.text) == null) {
      Get.snackbar(
        'Error',
        'Please enter valid feed quantity',
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
    totalFeedController.dispose();
    super.onClose();
  }
}
