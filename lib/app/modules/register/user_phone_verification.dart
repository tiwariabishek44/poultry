import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/register/user_detail_page.dart';
import 'package:poultry/app/widget/loading_State.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:poultry/app/modules/register/register_controller.dart';

class PhoneVerificationPage extends StatelessWidget {
  PhoneVerificationPage({super.key});

  final controller = Get.put(RegisterController());
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Verifying phone number...'),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and description
                      Text(
                        'Enter Phone Number',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'We\'ll verify your phone number to get started',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Phone input field
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
                          controller: phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            if (value.length != 10) {
                              return 'Enter a valid 10-digit phone number';
                            }
                            return null;
                          },
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

                      // Verify Button
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
                              if (formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();

                                // Show loading dialog
                                _showLoadingDialog();

                                // Simulate verification delay
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                // Close loading dialog and navigate
                                Get.back();
                                Get.to(() => UserDetailsPage(
                                      phoneNumber: phoneController.text,
                                    ));
                              }
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.arrowRight,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Verify',
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
                    ],
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
