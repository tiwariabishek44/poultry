import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropDown_controller.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';

class BatchVaccineController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginController = Get.find<PoultryLoginController>();

  final batchDropDownControler = Get.put(BatchDropDownController());
  final RxBool isLoading = false.obs;

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> addVaccine({
    required String vaccineName,
    required int flockCount,
    required String vaccinateDate,
    required String age,
  }) async {
    try {
      // Show loading dialog
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Adding vaccine...'),
        ),
        barrierDismissible: false,
      );

      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        Get.back(); // Close loading dialog
        throw Exception('Admin data not found');
      }

      final String myVaccineId = _firestore.collection('myVaccines').doc().id;

      final vaccineData = {
        'adminUid': adminUid,
        'batchId': batchDropDownControler.selectedBatchId.value,
        'batchName': batchDropDownControler.selectedBatchName.value,
        'flockCount': flockCount,
        'isVaccinated': true,
        'myVaccineId': myVaccineId,
        'age': age,
        'vaccineName': vaccineName,
        'yearMonth': NepaliDateTime.now().toIso8601String().substring(0, 7),
        'vaccinationDate': vaccinateDate,
      };

      await _firestore
          .collection('myVaccines')
          .doc(myVaccineId)
          .set(vaccineData);

      Get.back(); // Close loading dialog

      // Show success dialog
      await SuccessDialog.show(
        title: 'Vaccine Added!',
        subtitle: 'Vaccine: $vaccineName',
        additionalInfo: 'Date: $vaccinateDate',
        onButtonPressed: () {
          Get.back(); // Close success dialog
        },
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to add vaccine: $e',
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
}
