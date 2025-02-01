// login_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poultry/app/model/user_response_model.dart';
import 'package:poultry/app/modules/base_screen/base_screen.dart';
import 'package:poultry/app/modules/home_screen/home_screen.dart';
import 'package:poultry/app/modules/login%20/login_page.dart';
import 'package:poultry/app/repository/login_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final storage = GetStorage();
  final _loginRepository = LoginRepository();
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  final Rx<UserResponseModel?> currentAdmin = Rx<UserResponseModel?>(null);
  final isLoggedIn = false.obs;
  var isLoginLoading = false.obs;
  var isProfileLoading = false.obs;

  // Check storage in init
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final uid = await storage.read('admin_uid');
    if (uid != null) {
      isLoggedIn.value = true;
      // Fetch fresh user data
      getUserData(uid);
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Login.......'),
      ),
      barrierDismissible: false,
    );
  }

  // login_controller.dart
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    _showLoadingDialog();

    try {
      final reqBody = {
        "phoneNumber": phoneController.text.trim(),
      };

      final response = await _loginRepository.login(reqBody);

      if (response.status == ApiStatus.SUCCESS &&
          response.response?.uid != null) {
        // Now we should have the uid
        await storage.write('admin_uid', response.response!.uid);
        currentAdmin.value = response.response;
        isLoggedIn.value = true;

        Get.back(); // Close loading
        Get.offAll(() => BaseScreen());
      } else {
        Get.back();
        CustomDialog.showError(
          message: response.message ?? 'Unknown error',
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      CustomDialog.showError(
        message: 'Something went wrong',
        onConfirm: () {
          Get.back();
        },
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> getUserData(String uid) async {
    isProfileLoading.value = true;
    try {
      final response = await _loginRepository.getUserData(uid);
      if (response.status == ApiStatus.SUCCESS) {
        currentAdmin.value = response.response;
      }
    } catch (e) {
      log("Error fetching user data: $e");
    } finally {
      isProfileLoading.value = false;
    }
  }

  String? get adminUid => storage.read('admin_uid');

  Future<void> logout() async {
    await storage.remove('admin_uid');
    currentAdmin.value = null;
    isLoggedIn.value = false;
    Get.offAll(() => LoginPage());
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  String? validatePhoneNuber(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "Please enter a valid phone number";
    }
    return null;
  }
}
