import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/party_repository.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class PartyController extends GetxController {
  static PartyController get instance => Get.find();
  final _transactionRepository = TransactionRepository();

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

// Update the transactions observable to use TransactionResponseModel
  final transactions = <TransactionResponseModel>[].obs;
  final isLoadingTransactions = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchParties();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    switch (selectedFilter.value) {
      case 'all':
        filteredParties.value = parties;
        break;
      case 'supplier':
        filteredParties.value =
            parties.where((party) => party.partyType == 'supplier').toList();
        break;
      case 'customer':
        filteredParties.value =
            parties.where((party) => party.partyType == 'customer').toList();
        break;
    }
  }

  double _parseCreditAmount() {
    if (creditAmountController.text.isEmpty) return 0.0;
    try {
      return double.parse(creditAmountController.text.replaceAll(',', ''));
    } catch (e) {
      log("Error parsing credit amount: $e");
      return 0.0;
    }
  }

  Future<void> fetchParties() async {
    isLoading.value = true;
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        CustomDialog.showError(
            message: 'Admin ID not found. Please login again.');
        return;
      }

      final response = await _partyRepository.getParties(adminId);

      if (response.status == ApiStatus.SUCCESS) {
        parties.value = response.response ?? [];
        _applyFilter(); // Apply current filter to new data
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to fetch parties',
        );
      }
    } catch (e) {
      log("Error fetching parties: $e");
      CustomDialog.showError(message: 'Error fetching parties');
    } finally {
      isLoading.value = false;
    }
  }

  // to get the party details

  Future<void> fetchPartyDetails(String partyId) async {
    isLoadingDetails.value = true;
    isLoadingTransactions.value = true;
    try {
      // Fetch party details
      final partyResponse = await _partyRepository.getParty(partyId);
      if (partyResponse.status == ApiStatus.SUCCESS) {
        partyDetails.value = partyResponse.response;

        // Fetch and sort transactions
        final transactionResponse =
            await _transactionRepository.getPartyTransactions(partyId);
        if (transactionResponse.status == ApiStatus.SUCCESS) {
          var sortedTransactions = transactionResponse.response ?? [];
          sortedTransactions.sort((a, b) => DateTime.parse(b.transactionDate)
              .compareTo(DateTime.parse(a.transactionDate)));
          transactions.value = sortedTransactions;
        } else {
          CustomDialog.showError(
            message:
                transactionResponse.message ?? 'Failed to fetch transactions',
          );
        }
      } else {
        CustomDialog.showError(
          message: partyResponse.message ?? 'Failed to fetch party details',
        );
      }
    } catch (e) {
      log("Error fetching party details and transactions: $e");
      CustomDialog.showError(message: 'Error fetching data');
    } finally {
      isLoadingDetails.value = false;
      isLoadingTransactions.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
