import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/onboardingScreen/onboardingScreenController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../poultryLogin/poultryLoginPage.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Wave decoration at top
          Container(
            height: 15.h,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
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

          // PageView for onboarding screens
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updateCurrentPage,
            children: [
              _buildOnboardingPage(
                mainIcon: LucideIcons.layoutDashboard,
                secondaryIcon: LucideIcons.clipboardList,
                title: 'Smart Dashboard',
                description:
                    'Manage your entire poultry farm with our intuitive dashboard. Track batches, employees, and farm statistics in real-time.',
                mainIconColor: AppTheme.primaryColor,
                secondaryIconColor: AppTheme.accentTeal,
              ),
              _buildOnboardingPage(
                mainIcon: LucideIcons.egg,
                secondaryIcon: LucideIcons.trendingUp,
                title: 'Production Tracking',
                description:
                    'Monitor daily egg production, classify eggs, and manage sales. Get detailed reports and analytics at your fingertips.',
                mainIconColor: AppTheme.primaryColor,
                secondaryIconColor: AppTheme.accentTeal,
              ),
              _buildOnboardingPage(
                mainIcon: LucideIcons.bird,
                secondaryIcon: LucideIcons.heartPulse,
                title: 'Health Management',
                description:
                    'Track vaccination schedules, mortality rates, and health records. Keep your flock healthy with timely monitoring.',
                mainIconColor: AppTheme.primaryColor,
                secondaryIconColor: AppTheme.accentTeal,
              ),
            ],
          ),

          // Skip button with animated container
          Positioned(
            top: 6.h,
            right: 4.w,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(50 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: GestureDetector(
                      onTap: () => controller.skipOnboarding(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Skip',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 14.sp,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Icon(
                              LucideIcons.skipForward,
                              size: 16.sp,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom navigation and indicators
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Animated page indicator
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.h),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SmoothPageIndicator(
                            controller: controller.pageController,
                            count: 3,
                            effect: WormEffect(
                              activeDotColor: AppTheme.primaryColor,
                              dotColor: Colors.grey.shade200,
                              dotHeight: 1.2.h,
                              dotWidth: 1.2.h,
                              spacing: 2.w,
                              strokeWidth: 1,
                              paintStyle: PaintingStyle.fill,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // Next/Start button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Obx(() => Container(
                        width: double.infinity,
                        height: 6.5.h,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.25),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => controller.nextPage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.currentPage.value == 2
                                    ? 'Get Started'
                                    : 'Next',
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                controller.currentPage.value == 2
                                    ? LucideIcons.logIn
                                    : LucideIcons.moveRight,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required IconData mainIcon,
    required IconData secondaryIcon,
    required String title,
    required String description,
    required Color mainIconColor,
    required Color secondaryIconColor,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 20.h, 8.w, 0),
      child: Column(
        children: [
          // Animated icon container
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 30.w,
                  height: 30.w,
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        mainIcon,
                        size: 15.w,
                        color: mainIconColor,
                      ),
                      Positioned(
                        bottom: 2.w,
                        right: 2.w,
                        child: Icon(
                          secondaryIcon,
                          size: 8.w,
                          color: secondaryIconColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          // Animated text content
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textRich,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        description,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 14.sp,
                          color: AppTheme.textMedium,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
