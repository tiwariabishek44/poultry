import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class PartyGetController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  final allParties = <QueryDocumentSnapshot>[].obs;
  final filteredParties = <QueryDocumentSnapshot>[].obs;
  final selectedParty = 'customer'.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchParties();
  }

  // Function to fetch parties from Firestore
  Future<void> fetchParties() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');

      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        hasError(true);
        errorMessage('Admin data not found. Please login again.');
        Get.snackbar(
          'Error',
          'Admin data not found. Please login again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Set up real-time listener for parties
      _firestore
          .collection('parties')
          .where('adminUid', isEqualTo: adminUid)
          .where('status', isEqualTo: 'active')
          .snapshots()
          .listen(
        (QuerySnapshot snapshot) {
          allParties.value = snapshot.docs;
          filterParties(); // Apply current filter
        },
        onError: (error) {
          print('Error fetching parties: $error');
          hasError(true);
          errorMessage('Failed to fetch parties. Please try again.');
          Get.snackbar(
            'Error',
            'Failed to fetch parties. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } finally {
      isLoading(false);
    }
  }

  // Function to filter parties based on selected type
  void filterParties() {
    filteredParties.value = allParties.where((party) {
      final partyData = party.data() as Map<String, dynamic>;
      final partyType = partyData['type']?.toString().toLowerCase() ?? '';
      return partyType == selectedParty.value.toLowerCase();
    }).toList();
  }

  // Function to select party type (customer/supplier)
  void selectParty(String type) {
    selectedParty.value = type.toLowerCase();
    filterParties();
  }

  // Function to refresh parties
  Future<void> refreshParties() async {
    await fetchParties();
  }
}
