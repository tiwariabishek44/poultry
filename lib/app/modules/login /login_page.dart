import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/register/user_phone_verification.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top wave decoration
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo and App Name
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 25.w,
                                height: 25.w,
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 800),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            LucideIcons.egg,
                                            size: 12.w,
                                            color: AppColors.primaryColor,
                                          ),
                                          Positioned(
                                            bottom: 1.w,
                                            right: 1.w,
                                            child: Icon(
                                              LucideIcons.bird,
                                              size: 8.w,
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Poultry',
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textRich,
                                    ),
                                  ),
                                  Text(
                                    'Hub',
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 5.h),

                        // Welcome Text
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textRich,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // Instruction Text
                        Text(
                          'Please login to manage your farm',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 14.sp,
                            color: AppTheme.textMedium,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Phone Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: controller.phoneController,
                            validator: (value) =>
                                controller.validatePhoneNuber(value!),
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: GoogleFonts.notoSansDevanagari(
                                color: Colors.black38,
                                fontSize: 15,
                              ),
                              prefixText: '+977 ',
                              prefixStyle: GoogleFonts.notoSansDevanagari(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Icon(
                                LucideIcons.phone,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(4.w),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Login Button
                        Container(
                          width: double.infinity,
                          height: 6.5.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                // Dismiss keyboard first
                                FocusManager.instance.primaryFocus?.unfocus();

                                // Small delay to ensure keyboard is dismissed
                                await Future.delayed(
                                    Duration(milliseconds: 100));
                                controller.login();
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.logIn,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Login',
                                      style: GoogleFonts.notoSansDevanagari(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Register Link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Get.to(() => PhoneVerificationPage());
                            },
                            child: Text(
                              'Create New Account',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
