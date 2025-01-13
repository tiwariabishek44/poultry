import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginPage.dart';
import 'package:poultry/appss/widget/poultryRegister/poultryRegister.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';

class PoultryRegistrationController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final registerFormKey = GlobalKey<FormState>();
  late TextEditingController nameController,
      farmNameController,
      phoneController,
      addressController;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    farmNameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  Future<void> simulatePhoneVerification() async {
    if (!GetUtils.isPhoneNumber(phoneController.text)) {
      Get.snackbar('Error', 'Enter valid phone number');
      return;
    }
    final email = '${phoneController.text}@gmail.com';

    isLoading.value = true;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingWidget(text: 'Verifying phone number...'),
      ),
      barrierDismissible: false,
    );

    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 2));

    Get.back(); // Close loading dialog
    isLoading.value = false;

    // Navigate to details page
    Get.to(() => RegisterDetailsPage());
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Creating Account...'),
        ),
        barrierDismissible: false,
      );

      final email = '${phoneController.text}@gmail.com';
      final password = phoneController.text;
      final NepaliDateTime now = NepaliDateTime.now();
      final String nepaliDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // Create user account
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user != null) {
        // Save user data to Firestore
        await _firestore.collection('admins').doc(userCred.user!.uid).set({
          'uid': userCred.user!.uid,
          'name': nameController.text.trim(),
          'farmName': farmNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'email': email,
          'createdAt': nepaliDate,
        });

        Get.back(); // Close loading dialog

        // Show success dialog
        await CustomSuccessDialog.show(
            title: 'Account Created Successfully!',
            subtitle: '''Farm Name: ${farmNameController.text.trim()}
Owner Name: ${nameController.text.trim()}''',
            additionalInfo: '''Date: $nepaliDate
Phone: ${phoneController.text.trim()}''',
            buttonText: 'OK',
            onButtonPressed: () {
              Get.back(); // Close success dialog
              Get.offAll(() => PoultryLoginPage()); // Navigate to login page
            });
      }
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close loading dialog
      String message = 'Failed to create account';

      if (e.code == 'email-already-in-use') {
        message = 'This phone number is already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid phone number format';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Account creation is temporarily disabled';
      }

      Get.snackbar(
        'Error',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'An unexpected error occurred during registration',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      log('Registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class CustomSuccessDialog {
  static Future<void> show({
    String? title = 'सफल भयो!',
    String? subtitle,
    String? additionalInfo,
    String buttonText = 'ठिक छ',
    Color successColor = Colors.green,
    VoidCallback? onButtonPressed,
  }) async {
    return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: successColor.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.checkCircle2,
                        color: successColor,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Title with Growing Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.8, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ],

              if (additionalInfo != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    additionalInfo,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Custom Button with Gradient
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      successColor,
                      successColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: successColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onButtonPressed ??
                        () {
                          Get.back(); // Close dialog
                          Get.back(); // Go back to previous screen
                        },
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Text(
                        buttonText,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
