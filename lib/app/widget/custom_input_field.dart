import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isNumber;
  final bool isRequired;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final Function(String)? onChanged;
  final VoidCallback? onTap; // Added onTap callback
  final bool enabled;
  final bool readOnly; // Added readOnly flag
  final FocusNode? focusNode;

  const CustomInputField({
    Key? key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isNumber = false,
    this.isRequired = true,
    this.maxLength,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onTap, // Added to constructor
    this.enabled = true,
    this.readOnly = false, // Added to constructor
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 15.sp,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 1.h),

        // Input Field
        TextFormField(
          enabled: widget.enabled,
          readOnly: widget.readOnly, // Added readOnly property
          controller: widget.controller,
          focusNode: widget.focusNode,
          onTap: widget.onTap, // Added onTap callback
          validator: widget.validator ?? null,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          inputFormatters:
              widget.isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 15.sp,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.notoSansDevanagari(
              fontSize: 15.sp,
              color: AppColors.textLight,
            ),
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
            filled: true,
            fillColor: widget.enabled
                ? AppColors.surfaceColor
                : AppColors.surfaceColor.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.dividerColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
