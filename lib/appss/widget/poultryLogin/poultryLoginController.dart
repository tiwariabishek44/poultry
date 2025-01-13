import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:poultry/appss/model/poultryUserModel.dart';
import 'package:poultry/appss/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginPage.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';

class PoultryLoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final Rx<PoultryAdminModel?> adminData = Rx<PoultryAdminModel?>(null);

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingWidget(text: 'Login.......'),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> getAdminData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('admins').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        final updatedData = {
          ...data,
          'lastLogin': DateTime.now().toIso8601String(),
        };

        final admin = PoultryAdminModel.fromJson(updatedData);
        adminData.value = admin;

        // Update last login time in Firestore
        await _firestore.collection('admins').doc(uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });

        return true;
      }
      return false;
    } catch (e) {
      print('Error getting admin data: $e');
      return false;
    }
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        _showLoadingDialog();
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim() + "@gmail.com",
          password: emailController.text.trim(),
        );

        if (userCredential.user != null) {
          final success = await getAdminData(userCredential.user!.uid);
          log('Login success: ${success.toString()}');

          if (success) {
            Get.back(); // Hide loading dialog
            // Navigate to main screen instead of exiting
            Get.offAll(() => PoultryMainScreen());
          } else {
            Get.back(); // Hide loading dialog
            Get.snackbar(
              'Error',
              'Admin account not found',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            await logout();
          }
        }
      } on FirebaseAuthException catch (e) {
        Get.back(); // Hide loading dialog
        String message = 'Login failed';
        if (e.code == 'user-not-found') {
          message = 'Invalid Phone Number';
        } else if (e.code == 'wrong-password') {
          message = 'Invalid Phone Number';
        }
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.back(); // Hide loading dialog
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  var logooutLoading = false.obs;
  Future<void> logout() async {
    try {
      logooutLoading.value = true;
      await _auth.signOut();
      Get.offAll(() => PoultryLoginPage());
      logooutLoading(false);
    } catch (e) {
      logooutLoading(false);
      print('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Logout failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String? validateEmail(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "Please enter a valid phone number";
    }
    return null;
  }
}
