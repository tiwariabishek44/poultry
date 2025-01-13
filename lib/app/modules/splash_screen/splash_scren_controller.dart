// modules/splash/splash_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/constant/style.dart';
import 'package:poultry/app/modules/base_screen/base_screen.dart';
import 'package:poultry/app/modules/home_screen/home_screen.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/login%20/login_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// splash_controller.dart
class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final uid = await storage.read('admin_uid');
      if (uid != null) {
        if (!Get.isRegistered<LoginController>()) {
          Get.put(LoginController());
        }
        Get.off(() => BaseScreen());
      } else {
        Get.off(() => LoginPage());
      }
    } catch (e) {
      log("Error in splash screen: $e");
      Get.off(() => LoginPage());
    }
  }
}
