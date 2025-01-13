// onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../poultryLogin/poultryLoginPage.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void updateCurrentPage(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value == 2) {
      // If on last page, complete onboarding
      completeOnboarding();
    } else {
      // Go to next page
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    // Mark as not first time
    box.write('isFirstTime', false);
    // Navigate to login page
    Get.off(() => PoultryLoginPage());
  }
}
