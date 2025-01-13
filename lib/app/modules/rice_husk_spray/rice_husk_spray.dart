// rice_husk_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/rice_husk_spray/rice_husk_spray_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RiceHuskPage extends StatelessWidget {
  RiceHuskPage({super.key});

  final controller = Get.put(RiceHuskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              ' भुस Record ',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          tooltip: 'पछाडि जानुहोस्',
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Info Card
                _buildInfoCard(),
                SizedBox(height: 3.h),

                // Batch Selection
                _buildBatchSelection(),
                SizedBox(height: 3.h),

                // Number of Bags Input
                _buildBagsInput(),
                SizedBox(height: 3.h),

                // Notes Input
                _buildNotesInput(),
                SizedBox(height: 4.h),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.info,
            color: AppColors.primaryColor,
            size: 20.sp,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'धानको भुस   खोरमा बिछ्याउनको लागि प्रयोग गरिन्छ',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchSelection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bird, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'बैच चयन गर्नुहोस्',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          BatchesDropDown(),
        ],
      ),
    );
  }

  Widget _buildBagsInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.package, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'धानको भुस बोरा संख्या',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'बोरा संख्या लेख्नुहोस्',
            controller: controller.bagsController,
            keyboardType: TextInputType.number,
            isNumber: true,
            prefix: Icon(LucideIcons.package, color: AppColors.primaryColor),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'कृपया बोरा संख्या लेख्नुहोस्';
              }
              if (int.tryParse(value) == null) {
                return 'कृपया मान्य संख्या लेख्नुहोस्';
              }
              if (int.parse(value) <= 0) {
                return 'बोरा संख्या ० भन्दा बढी हुनुपर्छ';
              }
              return null;
            },
            label: 'Enter total  number of bags',
          ),
        ],
      ),
    );
  }

  Widget _buildNotesInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.pencil, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'टिप्पणीहरू',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'कुनै अतिरिक्त टिप्पणीहरू लेख्नुहोस्',
            controller: controller.notesController,
            maxLines: 3,
            suffix: Icon(Icons.description, color: AppColors.primaryColor),
            label: 'Enter any additional notes',
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: () {
          if (controller.formKey.currentState!.validate()) {
            controller.createRiceHuskRecord();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
        icon: Icon(LucideIcons.checkCircle2, color: Colors.white),
        label: Text(
          'धानको भुस रेकर्ड गर्नुहोस्',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
