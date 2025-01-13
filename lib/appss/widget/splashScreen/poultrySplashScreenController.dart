import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/bottom_navigation_bar/bottom_navigation_bar.dart';

import 'package:poultry/appss/module/activity_folder/activity_folder_mainScreen/activity_folder_mainScreen.dart';
import 'package:poultry/appss/widget/onboardingScreen/onboaridingScreen.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginPage.dart';
// poultrySplashScreenController.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../poultryLogin/poultryLoginPage.dart';

class PoultrtySplashController extends GetxController {
  final PoultryLoginController _loginController =
      Get.put(PoultryLoginController());
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndNavigate();
  }

  void checkFirstTime() {
    bool isFirstTime = box.read('isFirstTime') ?? true;
    if (isFirstTime) {
      Get.off(() => OnboardingScreen());
    } else {
      Get.off(() => PoultryLoginPage());
    }
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash screen delay

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get admin data and navigate accordingly
      final success = await _loginController.getAdminData(user.uid);
      if (success) {
        Get.offAll(() => PoultryMainScreen());
      } else {
        await FirebaseAuth.instance.signOut();
        checkFirstTime();
      }
    } else {
      checkFirstTime();
    }
  }
}
