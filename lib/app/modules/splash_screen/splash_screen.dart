import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/modules/splash_screen/splash_scren_controller.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/splashScreen/poultrySplashScreenController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 10.0.h, bottom: 8.0.h),
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 5.h,
                ), // Center content
                Container(
                  width: 40.w,
                  height: 40.w,
                  padding: EdgeInsets.all(6.w),
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
                    duration: const Duration(milliseconds: 1200),
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
                              size: 20.w,
                              color: AppTheme.primaryColor,
                            ),
                            Positioned(
                              bottom: 2.w,
                              right: 2.w,
                              child: Icon(
                                LucideIcons.bird,
                                size: 14.w,
                                color: AppTheme.primaryColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 3.h),
                // App Name with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Poultry',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textRich,
                              ),
                            ),
                            Text(
                              'Hub',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 2.h),
                // Tagline with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Text(
                        'कुखुरा फार्म व्यवस्थापन सजिलो बनाउँछौं',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16.sp,
                          color: AppTheme.textMedium,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),
                // Loading Indicator
                SizedBox(
                  width: 8.w,
                  height: 8.w,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Text(
                    'Version 1.0.0',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14.sp,
                      color: AppTheme.textMedium.withOpacity(0.7),
                    ),
                  ),
                ),
                // Bottom Section with Version and Gradient
              ],
            )),
      ),
    );
  }
}
