// constant/dimens.dart
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// constant/styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dimens {
  // Font Sizes
  static double h1 = 24.sp;
  static double h2 = 20.sp;
  static double h3 = 18.sp;
  static double body = 16.sp;
  static double small = 14.sp;
  static double tiny = 12.sp;

  // Padding & Margin
  static double horizontalPadding = 4.w; // 4% of screen width
  static double verticalPadding = 2.h; // 2% of screen height
  static double defaultPadding = 16.sp;
  static double smallPadding = 8.sp;
  static double largePadding = 24.sp;

  // Button Sizes
  static double buttonHeight = 6.h;
  static double iconSize = 24.sp;
  static double smallIconSize = 18.sp;

  // Border Radius
  static double borderRadius = 8.sp;
  static double cardRadius = 12.sp;

  // Card & Container
  static double cardElevation = 4.sp;
  static double defaultHeight = 56.h;
}

class AppStyles {
  // Text Styles using Google Fonts
  static TextStyle heading1 = GoogleFonts.notoSansDevanagari(
    fontSize: Dimens.h1,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.notoSansDevanagari(
    fontSize: Dimens.h2,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyText = GoogleFonts.notoSansDevanagari(
    fontSize: Dimens.body,
    color: AppColors.textPrimary,
  );

  // Button Styles
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(
        horizontal: Dimens.horizontalPadding, vertical: Dimens.smallPadding),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.borderRadius),
    ),
    minimumSize: Size(90.w, Dimens.buttonHeight), // 90% of screen width
  );

  // Input Decoration
  static final InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.borderRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.borderRadius),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.borderRadius),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dimens.horizontalPadding,
      vertical: Dimens.verticalPadding,
    ),
    errorStyle: GoogleFonts.notoSansDevanagari(
      fontSize: Dimens.small,
      color: AppColors.error,
    ),
  );

  // Card Decoration
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardColor,
    borderRadius: BorderRadius.circular(Dimens.cardRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: Dimens.cardElevation,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
