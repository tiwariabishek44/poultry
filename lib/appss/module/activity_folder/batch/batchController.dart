import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class BatchController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final batchNameController = TextEditingController();
  final quantityController = TextEditingController();
  final selectedMonth = ''.obs;
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final selectedDate = NepaliDateTime.now();

  @override
  void onInit() {
    super.onInit();
    selectedMonth.value = formatNepaliDate(selectedDate).substring(0, 7);
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  String formatFullNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingWidget(text: 'Creating batch...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createBatch() async {
    if (formKey.currentState!.validate()) {
      try {
        _showLoadingDialog();

        final adminUid = loginController.adminData.value?.uid;
        if (adminUid == null) {
          Get.back(); // Close loading dialog
          Get.snackbar(
            'Error',
            'Admin data not found. Please login again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        final batchName = batchNameController.text.isEmpty
            ? '${selectedMonth.value}-BATCH'
            : batchNameController.text;
        final batchRef = _firestore.collection('batches').doc();

        final batchData = {
          'batchId': batchRef.id,
          'adminUid': adminUid,
          'batchName': batchName + '-BATCH',
          'quantity': int.parse(quantityController.text),
          'createdAt': formatFullNepaliDate(NepaliDateTime.now()),
          'status': 'active',
          'poultryName': loginController.adminData.value?.farmName,
          'totalDeath': 0,
          'currentQuantity': int.parse(quantityController.text),
          'stage': 'Laying Stage',
          'initialDate': DateTime.now(),
          'currentFeed': 'L3',
        };

        await batchRef.set(batchData);
        Get.back(); // Close loading dialog

        await SuccessDialog.show(
            title: 'Batch Created Successfully!',
            subtitle: 'Batch: $batchName',
            additionalInfo: 'Total Birds: ${quantityController.text}',
            onButtonPressed: () {
              Get.back(); // Close success dialog
              Get.back(); // Go back to previous screen
            });
      } catch (e) {
        Get.back(); // Close loading dialog
        print('Error creating batch: $e');
        Get.snackbar(
          'Error',
          'Failed to create batch. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    batchNameController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
