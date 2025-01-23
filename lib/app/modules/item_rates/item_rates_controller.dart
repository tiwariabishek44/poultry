// Controller
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/item_rate_response_model.dart';
import 'package:poultry/app/repository/item_rate_repositry.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

import '../login /login_controller.dart';

class FeedRateController extends GetxController {
  final _feedRateRepository = FeedRateRepository();
  final _firebaseClient = FirebaseClient();
  final _loginController = Get.find<LoginController>();

  final itemNameController = TextEditingController();
  final categoryController = TextEditingController();
  final rateController = TextEditingController();
  final selectedFeed = ''.obs;
  final selectedFeedType = ''.obs;
  final selectedFeedRate = 0.0.obs;

  void updateFeedType(String type, double rate) {
    selectedFeedType.value = type;
    selectedFeedRate.value = rate;
  }

  RxList<ItemsRateResponseModel> feedRates = <ItemsRateResponseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFeedRates();
  }

  @override
  void onClose() {
    itemNameController.dispose();
    categoryController.dispose();
    rateController.dispose();
    super.onClose();
  }

  Stream<List<ItemsRateResponseModel>> streamFeedRates() {
    return _firebaseClient
        .streamCollection(
          collectionPath: FirebasePath.itemRates,
          queryBuilder: (query) =>
              query.where('adminId', isEqualTo: _loginController.adminUid),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => ItemsRateResponseModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  rateId: doc.id,
                ))
            .toList());
  }

  void _loadFeedRates() {
    feedRates.bindStream(streamFeedRates());
  }

  Future<void> createFeedRate() async {
    if (_loginController.adminUid == null) {
      CustomDialog.showError(message: 'Please login again');
      return;
    }

    if (!_validateInputs()) return;

    try {
      final rateData = {
        'adminId': _loginController.adminUid,
        'category': categoryController.text,
        'itemName': itemNameController.text,
        'rate': double.parse(rateController.text),
      };

      final response = await _feedRateRepository.createFeedRate(rateData);

      Get.back(); // Close dialog

      if (response.status == ApiStatus.SUCCESS) {
        _clearInputs();
        CustomDialog.showSuccess(
          message: 'Rate added successfully',
        );
      } else {
        CustomDialog.showError(
            message: response.message ?? 'Failed to add rate');
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(message: 'Error adding rate');
      log('Error in createFeedRate: $e');
    }
  }

  Future<void> updateFeedRate(String rateId) async {
    if (!_validateInputs()) return;

    try {
      final rateData = {
        'adminId': _loginController.adminUid,
        'category': categoryController.text,
        'itemName': itemNameController.text,
        'rate': double.parse(rateController.text),
      };

      final response =
          await _feedRateRepository.updateFeedRate(rateId, rateData);

      Get.back(); // Close dialog

      if (response.status == ApiStatus.SUCCESS) {
        _clearInputs();
        CustomDialog.showSuccess(
          message: 'Rate updated successfully',
        );
      } else {
        CustomDialog.showError(
            message: response.message ?? 'Failed to update rate');
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(message: 'Error updating rate');
      log('Error in updateFeedRate: $e');
    }
  }

  bool _validateInputs() {
    if (itemNameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        rateController.text.isEmpty) {
      CustomDialog.showError(message: 'Please fill all fields');
      return false;
    }

    if (double.tryParse(rateController.text) == null) {
      CustomDialog.showError(message: 'Please enter valid rate');
      return false;
    }

    return true;
  }

  void _clearInputs() {
    itemNameController.clear();
    categoryController.clear();
    rateController.clear();
  }
}
