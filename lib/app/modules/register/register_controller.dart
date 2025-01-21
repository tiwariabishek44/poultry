// modules/register/register_controller.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/model/user_response_model.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/loading_State.dart';
import '../../repository/register_repository.dart';
import '../login /login_page.dart';

class RegisterController extends GetxController {
  final RegisterRepository _registerRepository = RegisterRepository();
  var isRegisterLoading = false.obs;
  var registerApiResponse = ApiResponse<UserResponseModel>.initial().obs;

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Creating your account...'),
      ),
      barrierDismissible: false,
    );
  }

  void registerUser(Map<String, dynamic> userData) async {
    // Show loading dialog
    _showLoadingDialog();

    try {
      isRegisterLoading.value = true;

      // Call repository to register user
      final response = await _registerRepository.registerUser(userData);
      registerApiResponse.value = response;

      // Handle response
      if (response.status == ApiStatus.SUCCESS) {
        // Close loading dialog
        Get.back();

        // Show success message
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
          duration: const Duration(seconds: 2),
        );

        // Delay slightly to allow snackbar to be seen
        await Future.delayed(const Duration(seconds: 1));

        // Navigate back to login page
        Get.offAll(() => LoginPage());
      } else {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to create account',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFF44336),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error message
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
      );

      log('Register error: $e');
    } finally {
      isRegisterLoading.value = false;
    }
  }

  // For mocking phone verification (will be replaced with actual OTP verification)
  Future<bool> verifyPhone(String phone) async {
    try {
      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      log('Phone verification error: $e');
      return false;
    }
  }

  // Method to validate phone number
  String? validatePhone(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  // Method to validate email
  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isEmail(value)) {
        return 'Enter a valid email address';
      }
    }
    return null;
  }

  // Method to validate required fields
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  void onClose() {
    // Clean up any controllers or resources if needed
    super.onClose();
  }
}
