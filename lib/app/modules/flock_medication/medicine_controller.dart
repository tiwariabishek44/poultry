// lib/app/modules/medicine/medicine_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/medicine_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class MedicineController extends GetxController {
  static MedicineController get instance => Get.find();

  final _medicineRepository = MedicineRepository();
  final _loginController = Get.find<LoginController>();

  // Form controls
  final formKey = GlobalKey<FormState>();
  final medicineNameController = TextEditingController();

  // Observable variables
  final medicines = <MedicineResponseModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  @override
  void onClose() {
    medicineNameController.dispose();
    super.onClose();
  }

  // Fetch all medicines
  Future<void> fetchMedicines() async {
    final adminId = _loginController.adminUid;
    if (adminId == null) {
      CustomDialog.showError(
          message: 'Admin ID not found. Please login again.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _medicineRepository.getMedicines(adminId);
      if (response.status == ApiStatus.SUCCESS) {
        medicines.value = response.response ?? [];
      } else {
        CustomDialog.showError(
            message: response.message ?? 'Failed to fetch medicines');
      }
    } catch (e) {
      log("Error fetching medicines: $e");
      CustomDialog.showError(message: 'Failed to fetch medicines');
    } finally {
      isLoading.value = false;
    }
  }

  // Create new medicine
  Future<void> createMedicine() async {
    if (!formKey.currentState!.validate()) return;

    final adminId = _loginController.adminUid;
    if (adminId == null) {
      CustomDialog.showError(
          message: 'Admin ID not found. Please login again.');
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Adding Medicine...'),
      ),
      barrierDismissible: false,
    );

    try {
      final medicineData = {
        'medicineName': medicineNameController.text,
        'adminId': adminId,
      };

      final response = await _medicineRepository.createMedicine(medicineData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        CustomDialog.showSuccess(
          message: 'Medicine added successfully',
          onConfirm: () {
            fetchMedicines();
          },
        );
        _clearForm();
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to add medicine',
        );
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(
          message: 'Something went wrong while adding the medicine');
      log("Error creating medicine: $e");
    }
  }

  // Delete medicine
  Future<void> deleteMedicine(String medicineId) async {
    try {
      final response = await _medicineRepository.deleteMedicine(medicineId);
      if (response.status == ApiStatus.SUCCESS) {
        await fetchMedicines();
        CustomDialog.showSuccess(message: 'Medicine deleted successfully');
      } else {
        CustomDialog.showError(
            message: response.message ?? 'Failed to delete medicine');
      }
    } catch (e) {
      log("Error deleting medicine: $e");
      CustomDialog.showError(message: 'Failed to delete medicine');
    }
  }

  void _clearForm() {
    medicineNameController.clear();
  }

  // Validation
  String? validateMedicineName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter medicine name';
    }
    if (value.length < 2) {
      return 'Medicine name must be at least 2 characters long';
    }
    return null;
  }
}
