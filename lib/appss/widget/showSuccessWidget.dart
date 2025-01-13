import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/appss/config/constant.dart';

class SuccessDialog {
  static Future<void> show({
    String? title = 'Success!',
    String? subtitle,
    String? additionalInfo,
    String buttonText = 'Done',
    VoidCallback? onButtonPressed,
  }) async {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                title!,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              if (additionalInfo != null) ...[
                const SizedBox(height: 4),
                Text(
                  additionalInfo,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onButtonPressed ??
                      () {
                        Get.back();
                        Get.back();
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
