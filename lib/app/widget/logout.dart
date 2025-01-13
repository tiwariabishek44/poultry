// widget/logout_popup.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/constant/style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LogoutPopup extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutPopup({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: AppColors.primaryColor,
                size: 30.sp,
              ),
            ),
            SizedBox(height: 2.h),

            // Title
            Text(
              'Logout',
              style: AppStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 1.h),

            // Message
            Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: AppStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 3.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppStyles.bodyText.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),

                // Logout Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: AppStyles.bodyText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
