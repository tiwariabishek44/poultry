import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/poultryRegister/poultryRegisterController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneEntryPage extends GetView<PoultryRegistrationController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PoultryRegistrationController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          'फोन प्रमाणीकरण',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),
                  Text(
                    'फोन नम्बर हाल्नुहोस्',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'हामी तपाईंको फोन नम्बर प्रमाणित गर्नेछौं',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Phone number input field
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
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'फोन नम्बर',
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
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(4.w),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Verify button
                  Container(
                    width: double.infinity,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.simulatePhoneVerification,
                        borderRadius: BorderRadius.circular(15),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.checkCircle2,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'प्रमाणित गर्नुहोस्',
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
          ],
        ),
      ),
    );
  }
}
