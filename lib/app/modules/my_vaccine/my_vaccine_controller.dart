// my_vaccine_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/vaccination_schedule_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/my_vaccine_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class MyVaccineController extends GetxController {
  static MyVaccineController get instance => Get.find();

  final _myVaccineRepository = MyVaccineRepository();
  final _loginController = Get.find<LoginController>();
  final batchesDropDownController = Get.put(BatchesDropDownController());

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observables and controllers
  final selectedVaccineName = ''.obs;
  final selectedDisease = ''.obs;
  final selectedMethod = ''.obs;
  final notesController = TextEditingController();
  final selectedAge = ''.obs;
  final selectedAgeUnit = ''.obs;

  // Loading state
  final isLoading = false.obs;

  // Vaccination schedule
  final vaccinationSchedule = VaccinationSchedule();

  @override
  void onInit() {
    super.onInit();

    // Check if we have arguments passed from VaccineSchedulePage
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      selectedVaccineName.value = args['vaccine'] ?? '';
      selectedDisease.value = args['disease'] ?? '';
      selectedMethod.value = args['method'] ?? '';
      selectedAge.value = args['age'] ?? '';
      selectedAgeUnit.value = args['ageUnit'] ?? '';
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Recording Vaccination...'),
      ),
      barrierDismissible: false,
    );
  }

  // Calculate bird age based on batch start date
  Map<String, dynamic> calculateBirdAge(String batchStartDate) {
    final startDate = NepaliDateTime.parse(batchStartDate);
    final today = NepaliDateTime.now();
    final difference = today.difference(startDate).inDays;

    if (difference >= 7 && difference % 7 == 0) {
      return {
        'age': difference ~/ 7,
        'unit': 'हप्ता',
      };
    }
    return {
      'age': difference,
      'unit': 'दिन',
    };
  }

  Future<void> recordVaccination(String date, String yearMonth) async {
    if (!formKey.currentState!.validate()) return;

    final adminId = _loginController.adminUid;
    if (adminId == null) {
      CustomDialog.showError(
          message: 'Admin ID not found. Please login again.');
      return;
    }

    final selectedBatchId = batchesDropDownController.selectedBatchId.value;
    if (selectedBatchId.isEmpty) {
      CustomDialog.showError(message: 'Please select a batch first.');
      return;
    }

    if (selectedVaccineName.value.isEmpty || selectedDisease.value.isEmpty) {
      CustomDialog.showError(message: 'Please select vaccine and disease.');
      return;
    }

    _showLoadingDialog();

    try {
      final birdAge =
          calculateBirdAge(batchesDropDownController.startingDate.value);

      final vaccineData = {
        'batchId': selectedBatchId,
        'adminId': adminId,
        'yearMonth': yearMonth,
        'vaccineDate': date,
        'vaccineName': selectedVaccineName.value,
        'disease': selectedDisease.value,
        'method': selectedMethod.value,
        'birdAge': '',
        'birdAgeUnit': birdAge['unit'],
        'isScheduled': true,
        'isCompleted': true,
        'notes': notesController.text,
      };

      final response =
          await _myVaccineRepository.recordVaccination(vaccineData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Vaccination Record Success =========");
        log("Vaccine ID: ${response.response?.vaccineId}");
        log("Batch ID: ${response.response?.batchId}");
        log("Vaccine: ${response.response?.vaccineName}");
        log("Disease: ${response.response?.disease}");
        log("Bird Age: ${response.response?.birdAge} ${response.response?.birdAgeUnit}");
        log("=========================================");

        CustomDialog.showSuccess(
          message: 'Vaccination recorded successfully.',
          onConfirm: () {
            Get.back();
            _clearForm();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to record vaccination',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while recording vaccination',
      );
      log("Error recording vaccination: $e");
    }
  }

  void _clearForm() {
    selectedVaccineName.value = '';
    selectedDisease.value = '';
    selectedMethod.value = '';
    notesController.clear();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
