import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3AB98C); // Example: Green shade

  // Secondary colors
  static const accentPurple = Color(0xFF9C27B0);
  static const accentTeal = Color(0xFF009688);
  static const successGreen = Color(0xFF00BFA5);
  static const warningOrange = Color(0xFFFF9800);

  // Background colors
  static const backgroundLight = Color(0xFFF8F9FE);
  static const cardLight = Colors.white;

  // Text colors
  static const textRich = Color(0xFF2C3E50);
  static const textMedium = Color(0xFF546E7A);
  static const textLight = Color.fromARGB(255, 96, 115, 124);
// Updated Colors for Green Gradient
  static const Color gradientStart = Color(0xFF3AB98C); // Green Shade
  static const Color gradientEnd = Color(0xFF3AB98C); // Light Green Shade

// Updated Gradient
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryColor],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FE)],
  );

  // Enhanced Typography
  static TextStyle get displayLarge => GoogleFonts.notoSansDevanagari(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textRich,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.notoSansDevanagari(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textRich,
        letterSpacing: -0.3,
      );

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textRich,
        letterSpacing: -0.2,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textMedium,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textRich,
        letterSpacing: 0.1,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textMedium,
      );
}
