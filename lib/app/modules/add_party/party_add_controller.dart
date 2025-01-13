import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/repository/party_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class PartyAddController extends GetxController {
  static PartyAddController get instance => Get.find();
  final partyController = Get.put(PartyController());

  final _partyRepository = PartyRepository();
  final _loginController = Get.find<LoginController>();

  // Form controls
  // Form controls
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final emailController = TextEditingController();
  final taxNumberController = TextEditingController();
  final creditAmountController = TextEditingController();

  // Observable variables
  final selectedPartyType = 'customer'.obs;
  final isTaxPan = true.obs;
  final parties = <PartyResponseModel>[].obs;
  final filteredParties = <PartyResponseModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs;
  // Observable for party details
  final partyDetails = Rxn<PartyResponseModel>();
  final isLoadingDetails = false.obs;
  final transactions = <Map<String, dynamic>>[].obs;

  double _parseCreditAmount() {
    if (creditAmountController.text.isEmpty) return 0.0;
    try {
      return double.parse(creditAmountController.text.replaceAll(',', ''));
    } catch (e) {
      log("Error parsing credit amount: $e");
      return 0.0;
    }
  }

  Future<void> createParty() async {
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
        child: const LoadingState(text: 'पार्टी थप्दै...'),
      ),
      barrierDismissible: false,
    );

    try {
      double creditAmount = _parseCreditAmount();
      if (selectedPartyType.value == 'customer') {
        creditAmount = creditAmount.abs();
      } else {
        creditAmount = creditAmount.abs();
      }

      final partyData = {
        'partyName': nameController.text,
        'partyType': selectedPartyType.value,
        'phoneNumber': phoneController.text,
        'address': addressController.text,
        'companyName': companyController.text,
        'email': emailController.text,
        'taxNumber': taxNumberController.text,
        'isPan': isTaxPan.value,
        'adminId': adminId,
        'creditAmount': creditAmount,
        'isCredited': creditAmount != 0,
      };

      final response = await _partyRepository.createParty(partyData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("Party created successfully: ${response.response?.partyId}");

        partyController.fetchParties();

        CustomDialog.showSuccess(
          message: 'पार्टी सफलतापूर्वक थपियो',
          onConfirm: () {
            Get.back();
            // fetchParties();
          },
        );
        _clearForm();
      } else {
        CustomDialog.showError(
          message: response.message ?? 'पार्टी थप्न सकिएन',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      log("Error creating party: $e");
      CustomDialog.showError(message: 'पार्टी थप्दा त्रुटि भयो');
    }
  }

  // to get the party details

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    taxNumberController.clear();
    emailController.clear();
    companyController.clear();
    creditAmountController.clear();
    selectedPartyType.value = 'customer';
    isTaxPan.value = true;
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया पार्टीको नाम लेख्नुहोस्';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the address';
    }
    // Making sure address is at least 3 characters long
    if (value.trim().length < 3) {
      return 'Address must be at least 3 characters long';
    }
    // Check if address contains any number or special character
    if (!RegExp(r'^[a-zA-Z\u0900-\u097F\s,.-]+$').hasMatch(value)) {
      return 'Please enter a valid address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया फोन नम्बर लेख्नुहोस्';
    }
    if (value.length != 10) {
      return 'फोन नम्बर १० अंकको हुनुपर्छ';
    }
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    taxNumberController.dispose();
    creditAmountController.dispose();
    emailController.dispose();
    companyController.dispose();

    super.onClose();
  }
}
