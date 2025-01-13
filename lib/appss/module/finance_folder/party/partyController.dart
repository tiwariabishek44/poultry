import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';

class AddPartyController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rx variables for party type and loading state
  var partyTypeRx = 'customer'.obs;
  var isLoading = false.obs;

  // Controllers for the form fields
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final gstController = TextEditingController();
  final notesController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  void setPartyType(String type) {
    partyTypeRx.value = type;
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingWidget(text: 'Creating Party...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        _showLoadingDialog();

        final adminUid = loginController.adminData.value?.uid;
        if (adminUid == null) {
          Get.snackbar(
            'Error',
            'Admin data not found. Please login again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        final partyRef = _firestore.collection('parties').doc();

        final partyData = {
          'partyId': partyRef.id,
          'adminUid': adminUid,
          'poultryName': loginController.adminData.value?.farmName,
          'name': nameController.text.trim(),
          'company': companyController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'pan/Vat': "",
          'notes': notesController.text.trim(),
          'type': partyTypeRx.value, // Use the selected party type
          'status': 'active',
          'creditAmount': 0, // Initial credit amount
          'lastTransaction': null,
          'isCredit': false, // Track if party has any credit
        };

        await partyRef.set(partyData);

        // Show success dialog and go back to the main page
        await SuccessDialog.show(
          title: 'Party Added!',
          subtitle: 'Party has been added successfully',
          additionalInfo: '${partyData['name']} - ${partyData['type']}',
          onButtonPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Close dialog
            Get.back(); // Go back to the main page (or previous screen)

            // Reset form fields
            nameController.clear();
            companyController.clear();
            phoneController.clear();
            emailController.clear();
            addressController.clear();
            gstController.clear();
            notesController.clear();
            partyTypeRx.value = 'customer'; // Reset to default party type
          },
        );
      } catch (e) {
        print('Error adding party: $e');
        Get.snackbar(
          'Error',
          'Failed to add party. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    gstController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
