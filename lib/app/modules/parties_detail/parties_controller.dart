import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/party_repository.dart';
import 'package:poultry/app/repository/transction_fetch_repositoyr.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class PartyController extends GetxController {
  static PartyController get instance => Get.find();
  final _partyRepository = PartyRepository();
  final _loginController = Get.find<LoginController>();
  final transctionFetchRepositr = TransactionFetchRepository();

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
  final partyDetails = Rxn<PartyResponseModel>();
  final isLoadingDetails = false.obs;
  final transactions = <TransactionResponseModel>[].obs;
  final isLoadingTransactions = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchParties();
    fetchMetrics();
  }

// In PartyController
  final thisMonthSales = 0.0.obs;
  final thisMonthPurchase = 0.0.obs;
  final totalReceivable = 0.0.obs;
  final totalPayable = 0.0.obs;

// Add this method to fetch metrics
  Future<void> fetchMetrics() async {
    try {
      final currentDate = NepaliDateTime.now();
      final yearMonth =
          '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}';

      // Fetch this month's sales and purchases
      // Add your Firebase queries here

      // Update the values
      thisMonthSales.value = 20;
      thisMonthPurchase.value = 20;
      totalReceivable.value = 20;
      totalPayable.value = 20;
    } catch (e) {
      print('Error fetching metrics: $e');
    }
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    filteredParties.value = parties.where((party) {
      switch (selectedFilter.value) {
        case 'all':
          return true;

        case 'supplier':
          return party.partyType == 'supplier';

        case 'customer':
          return party.partyType == 'customer';

        case 'to_receive':
          // Show customers with credited amount
          return party.partyType == 'customer' &&
              party.isCredited &&
              party.creditAmount > 0;

        case 'to_pay':
          // Show suppliers with credited amount
          return party.partyType == 'supplier' &&
              party.isCredited &&
              party.creditAmount > 0;

        case 'settled':
          // Show parties with no credit or credit amount is 0
          return !party.isCredited || party.creditAmount == 0;

        default:
          return true;
      }
    }).toList();
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

  // Helper method to combine date and time for sorting
  DateTime _getFullDateTime(String date, String time) {
    try {
      final dateTime = DateTime.parse(date);
      final timeParts = time.split(':');

      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        int.parse(timeParts[0]), // hours
        int.parse(timeParts[1]), // minutes
        int.parse(timeParts[2]), // seconds
      );
    } catch (e) {
      log("Error parsing date/time: $e");
      return DateTime.parse(
          date); // Fallback to just date if time parsing fails
    }
  }

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
            await transctionFetchRepositr.getPartyTransactions(partyId);
        if (transactionResponse.status == ApiStatus.SUCCESS) {
          var sortedTransactions = transactionResponse.response ?? [];

          // Sort by date and time
          sortedTransactions.sort((a, b) {
            final aDateTime =
                _getFullDateTime(a.transactionDate, a.transactionTime);
            final bDateTime =
                _getFullDateTime(b.transactionDate, b.transactionTime);
            return bDateTime
                .compareTo(aDateTime); // Descending order (recent first)
          });

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
