import 'package:flutter/material.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/constant/style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoadingState extends StatelessWidget {
  final String? text;

  const LoadingState({
    Key? key,
    this.text = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 4.h,
            width: 4.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            text!,
            style: AppStyles.bodyText,
          ),
        ],
      ),
    );
  }
}
