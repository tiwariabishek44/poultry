import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class EggSellController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isSubmitEnabled = false.obs;

  late final TextEditingController remainingEggsController;
  late final TextEditingController paidAmountController;
  late final TextEditingController crateController;
  late final TextEditingController rateController;

  final selectedParty = ''.obs;
  final selectedPartyName = ''.obs;
  final eggType = 'normal'.obs;
  final eggCategory = 'medium'.obs;
  final paymentMethod = 'cash'.obs;
  final totalAmount = 0.0.obs;
  final creditAmount = 0.0.obs;
  final selectedBatch = ''.obs;

  // Track if controllers are disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    remainingEggsController = TextEditingController();
    paidAmountController = TextEditingController();
    crateController = TextEditingController();
    rateController = TextEditingController();

    // Add listeners
    crateController.addListener(calculateTotal);
    rateController.addListener(calculateTotal);
    remainingEggsController.addListener(calculateTotal);
    paidAmountController.addListener(calculateCredit);
  }

  void calculateTotal() {
    if (crateController.text.isNotEmpty ||
        remainingEggsController.text.isNotEmpty) {
      int crates = int.tryParse(crateController.text) ?? 0;
      int remainingEggs = int.tryParse(remainingEggsController.text) ?? 0;
      double rate = double.tryParse(rateController.text) ?? 0;

      // Calculate total eggs: (crates × 30) + remaining eggs
      int totalEggs = (crates * 30) + remainingEggs;
      totalAmount.value = totalEggs * rate;
      calculateCredit(); // Update credit whenever total changes
    }
  }

  void calculateCredit() {
    double paid = double.tryParse(paidAmountController.text) ?? 0.0;
    creditAmount.value = totalAmount.value - paid;
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void onBatchSelected(String? batchId) {
    if (batchId != null) {
      selectedBatch.value = batchId;
    }
  }

  void resetForm() {
    // If controllers are disposed, reinitialize them
    if (_isDisposed) {
      _initializeControllers();
      _isDisposed = false;
    }

    // Reset observable values
    eggType.value = 'normal';
    eggCategory.value = 'medium';
    totalAmount.value = 0;
    creditAmount.value = 0;
    selectedBatch.value = '';
    selectedParty.value = '';
    selectedPartyName.value = '';

    // Clear text controllers safely
    if (!_isDisposed) {
      crateController.clear();
      rateController.clear();
      remainingEggsController.clear();
      paidAmountController.clear();
    }
  }

  Future<void> submitSale() async {
    if (!validate()) return;

    try {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Processing sale...'),
        ),
        barrierDismissible: false,
      );

      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        Get.back();
        Get.snackbar('Error', 'Admin data not found');
        return;
      }

      // Start a batch write
      final batch = _firestore.batch();

      // Prepare sale document
      final saleRef = _firestore.collection('eggSales').doc();
      final crates = int.tryParse(crateController.text) ?? 0;
      final remainingEggs = int.tryParse(remainingEggsController.text) ?? 0;
      final totalEggs = (crates * 30) + remainingEggs;
      final ratePerEgg = double.tryParse(rateController.text) ?? 0;
      final paidAmount = double.tryParse(paidAmountController.text) ?? 0.0;
      final currentCreditAmount = totalAmount.value - paidAmount;

      final saleData = {
        'saleId': saleRef.id,
        'adminUid': adminUid,
        'batchId': selectedBatch.value,
        'poultryName': loginController.adminData.value?.farmName,
        'partyId': selectedParty.value,
        'partyName': selectedPartyName.value,
        'eggType': eggType.value,
        'eggCategory': eggCategory.value,
        'crates': crates,
        'remainingEggs': remainingEggs,
        'totalEggs': totalEggs,
        'ratePerEgg': ratePerEgg,
        'totalAmount': totalAmount.value,
        'paidAmount': paidAmount,
        'yearMonth': NepaliDateTime.now().toIso8601String().substring(0, 7),
        'creditAmount': currentCreditAmount,
        'saleDate': formatNepaliDate(NepaliDateTime.now()),
        'createdAt': NepaliDateTime.now().toIso8601String(),
      };

      // Add sale document to batch
      batch.set(saleRef, saleData);

      // Update admin's financial details
      batch.update(_firestore.collection('admins').doc(adminUid), {
        'cash': FieldValue.increment(paidAmount),
        'amountReceivable': FieldValue.increment(currentCreditAmount),
      });

      // If there's a paid amount, create a payment record
      if (paidAmount > 0) {
        final paymentRef = _firestore.collection('payments').doc();
        final paymentData = {
          'adminUid': adminUid,
          'paymentId': paymentRef.id,
          'saleId': saleRef.id,
          'partyId': selectedParty.value,
          'partyName': loginController.adminData.value?.farmName,
          'amount': paidAmount,
          'paymentType': 'egg_sale_payment',
          'date': formatNepaliDate(NepaliDateTime.now()),
          'createdAt': NepaliDateTime.now().toIso8601String(),
        };
        batch.set(paymentRef, paymentData);
      }

      // If there's credit amount, update party's credit status
      if (currentCreditAmount > 0) {
        batch.update(
            FirebaseFirestore.instance
                .collection('parties')
                .doc(selectedParty.value),
            {
              'creditAmount': FieldValue.increment(currentCreditAmount),
              'isCredit': true,
            });
      }

      // Commit the batch
      await batch.commit();

      Get.back(); // Close loading dialog

      await SuccessDialog.show(
        title: 'Success !',
        subtitle: '''
कुल रकम: ₹${totalAmount.value.toStringAsFixed(2)}
भुक्तानी रकम: ₹${paidAmount.toStringAsFixed(2)}
${currentCreditAmount > 0 ? 'बाँकी रकम (उधारो): ₹${currentCreditAmount.toStringAsFixed(2)}' : 'पूर्ण भुक्तानी'}''',
        additionalInfo: '''
मिति: ${formatNepaliDate(NepaliDateTime.now())}
कुल अण्डा: $totalEggs (${crates} क्रेट + $remainingEggs अण्डा)''',
        onButtonPressed: () {
          Get.back(); // Close success dialog
          resetForm(); // Use resetForm instead of clearForm
          Get.back(); // Close egg sale page
        },
      );
    } catch (e) {
      Get.back();
      log('Error submitting sale: $e');
      Get.snackbar(
        'Error',
        'Failed to process sale',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool validate() {
    if (eggCategory.isEmpty) {
      Get.snackbar('Error', 'Please select egg category',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (crateController.text.isEmpty && remainingEggsController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter either crates or remaining eggs',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (rateController.text.isEmpty ||
        double.tryParse(rateController.text) == null) {
      Get.snackbar('Error', 'Please enter valid rate per egg',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (paidAmountController.text.isEmpty) {
      Get.snackbar(
          'Error', 'Please enter paid amount (कृपया भुक्तानी रकम हाल्नुहोस्)',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    double paid = double.tryParse(paidAmountController.text) ?? 0.0;
    if (paid > totalAmount.value) {
      Get.snackbar('Error',
          'Paid amount cannot be greater than total amount (भुक्तानी रकम कुल रकम भन्दा बढी हुन सक्दैन)',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    if (!_isDisposed) {
      crateController.dispose();
      rateController.dispose();
      remainingEggsController.dispose();
      paidAmountController.dispose();
      _isDisposed = true;
    }
    super.onClose();
  }
}
