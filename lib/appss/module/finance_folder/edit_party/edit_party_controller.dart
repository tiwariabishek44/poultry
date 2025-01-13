import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';

class EditPartyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginController = Get.find<PoultryLoginController>();

  final formKey = GlobalKey<FormState>();

  // Controllers for editing party details
  late TextEditingController nameController;
  late TextEditingController companyController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController notesController;

  var isLoading = false.obs;
  final String partyId;

  EditPartyController(this.partyId);

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _fetchPartyDetails();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    companyController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    notesController = TextEditingController();
  }

  void _fetchPartyDetails() async {
    try {
      isLoading(true);
      final partyDoc =
          await _firestore.collection('parties').doc(partyId).get();

      if (partyDoc.exists) {
        final partyData = partyDoc.data()!;

        nameController.text = partyData['name'] ?? '';
        companyController.text = partyData['company'] ?? '';
        phoneController.text = partyData['phone'] ?? '';
        emailController.text = partyData['email'] ?? '';
        addressController.text = partyData['address'] ?? '';
        notesController.text = partyData['notes'] ?? '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load party details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void updatePartyDetails() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading(true);
        _showLoadingDialog();

        final partyRef = _firestore.collection('parties').doc(partyId);

        final updatedPartyData = {
          'name': nameController.text.trim(),
          'company': companyController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'notes': notesController.text.trim(),
        };

        await partyRef.update(updatedPartyData);

        // Show success dialog and go back
        await SuccessDialog.show(
          title: 'Party Updated!',
          subtitle: 'Party details have been updated successfully',
          additionalInfo: nameController.text,
          onButtonPressed: () {
            Get.back(); // Close success dialog
            Get.back(); // Go back to party details
          },
        );
      } catch (e) {
        print('Error updating party: $e');
        Get.snackbar(
          'Error',
          'Failed to update party. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingWidget(text: 'Updating Party...'),
      ),
      barrierDismissible: false,
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter party name';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    if (value.length != 10) {
      return 'Please enter valid 10-digit phone number';
    }
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
