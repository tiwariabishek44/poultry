// my_vaccine_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/my_vaccine/my_vaccine_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyVaccinePage extends StatelessWidget {
  MyVaccinePage({super.key});

  final controller = Get.put(MyVaccineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Flocks Vaccination ',
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
          tooltip: 'पछाडि जानुहोस्', // Back in Nepali
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vaccine Information Card with Visual Indicators
              _buildVaccineCard(),
              SizedBox(height: 3.h),

              // Date Selection with Calendar View
              _buildDateSelection(),
              SizedBox(height: 3.h),

              // Batch Selection with Visual Guide
              _buildBatchSelection(),
              SizedBox(height: 3.h),

              // Batch Information Dashboard
              _buildBatchDashboard(),
              SizedBox(height: 3.h),

              // Notes Section with Voice Input Option
              _buildNotesSection(),
              SizedBox(height: 4.h),

              // Large, Clear Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(String label, int step, bool isActive) {
    return Column(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 12.sp,
            color: isActive ? AppColors.primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 15.w,
      height: 2,
      color: isActive ? AppColors.primaryColor : Colors.grey[300],
    );
  }

  Widget _buildVaccineCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clock4,
                  color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 2.w),
              Obx(() => Expanded(
                    child: Text(
                      'सिफारिस गरिएको उमेर: ${controller.selectedAge} ${controller.selectedAgeUnit}',
                      style: GoogleFonts.notoSansDevanagari(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 2.h),

          // Vaccine Name with Icon
          Row(
            children: [
              Text("Vaccine Name ",
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 17.sp,
                    color: AppColors.textPrimary,
                  )),
              SizedBox(width: 2.w),
              Obx(() => Expanded(
                    child: Text(
                      controller.selectedVaccineName.value,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 2.h),

          // Disease with Icon
          Row(
            children: [
              Text("रोग:",
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 17.sp,
                    color: Colors.red[400],
                  )),
              SizedBox(width: 2.w),
              Expanded(
                child: Obx(() => Text(
                      controller.selectedDisease.value,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 17.sp,
                        color: Colors.red[400],
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Method with Visual Guide
          Row(
            children: [
              Icon(LucideIcons.droplets,
                  color: AppColors.textSecondary, size: 20.sp),
              SizedBox(width: 2.w),
              Expanded(
                child: Obx(() => Text(
                      controller.selectedMethod.value,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'खोप मिति छान्नुहोस्',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'मिति छान्नुहोस्',
            controller: controller.dateController,
            validator: controller.validateDate,
            prefix: Icon(LucideIcons.calendar, color: AppColors.primaryColor),
            onTap: () => controller.pickDate(),
            readOnly: true,
            label: 'Select Date of Vaccination',
          ),
        ],
      ),
    );
  }

  Widget _buildBatchSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bird, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'Select Batch ',
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

  Widget _buildBatchDashboard() {
    return Obx(() {
      if (controller
          .batchesDropDownController.selectedBatchId.value.isNotEmpty) {
        final birdAge = controller.calculateBirdAge(
            controller.batchesDropDownController.startingDate.value);
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDashboardItem(
                icon: LucideIcons.bird,
                label: 'हालको चल्ला संख्या:',
                value:
                    '${controller.batchesDropDownController.currentFlockCount}',
              ),
              Divider(height: 3.h),
              _buildDashboardItem(
                icon: LucideIcons.calendar,
                label: 'चल्लाको उमेर:',
                value: '${birdAge['age']} ${birdAge['unit']}',
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _buildDashboardItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20.sp),
        SizedBox(width: 3.w),
        Text(
          label,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'Note:',
            controller: controller.notesController,
            maxLines: 3,
            suffix:
                const Icon(Icons.description, color: AppColors.primaryColor),
            label: 'Note :',
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
        onPressed: controller.recordVaccination,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
        icon: Icon(LucideIcons.checkCircle2, color: Colors.white),
        label: Text(
          'Save ',
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
