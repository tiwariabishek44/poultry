import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_batch/add_batch_controller.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddBatchPage extends StatelessWidget {
  AddBatchPage({super.key});

  final controller = Get.put(AddBatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Batch / नयाँ बैच',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
          tooltip: 'पछाडि जानुहोस्',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Batch Information Card
              _buildInfoCard(
                title: 'बैच विवरण',
                icon: LucideIcons.clipboardList,
                children: [
                  CustomInputField(
                    label: 'बैच नाम / Batch Name',
                    hint: 'उदाहरण: बैच A / Batch A',
                    controller: controller.batchNameController,
                    validator: controller.validateBatchName,
                    prefix:
                        Icon(LucideIcons.tag, color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 3.h),
                  CustomInputField(
                    label: 'चल्लाको संख्या / Number of Chicks',
                    hint: 'उदाहरण: १०००',
                    controller: controller.initialFlockController,
                    validator: controller.validateInitialFlock,
                    keyboardType: TextInputType.number,
                    isNumber: true,
                    prefix:
                        Icon(LucideIcons.bird, color: AppColors.primaryColor),
                    onChanged: (value) {
                      // Update remaining flock when initial flock changes
                      controller.updateRemainingFlock();
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Date Selection Card with Year, Month, Day inputs
              _buildInfoCard(
                title: 'Batch Start Date / बैच सुरु मिति',
                icon: LucideIcons.calendar,
                children: [
                  Row(
                    children: [
                      // Year Input
                      Expanded(
                        child: CustomInputField(
                          label: 'वर्ष / Year',
                          hint: 'YYYY',
                          controller: controller.yearController,
                          validator: controller.validateYear,
                          keyboardType: TextInputType.number,
                          isNumber: true,
                          prefix: Icon(LucideIcons.calendar,
                              color: AppColors.primaryColor),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      // Month Input
                      Expanded(
                        child: CustomInputField(
                          label: 'महिना / Month',
                          hint: 'MM',
                          controller: controller.monthController,
                          validator: controller.validateMonth,
                          keyboardType: TextInputType.number,
                          isNumber: true,
                          prefix: Icon(LucideIcons.calendar,
                              color: AppColors.primaryColor),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      // Day Input
                      Expanded(
                        child: CustomInputField(
                          label: 'दिन / Day',
                          hint: 'DD',
                          controller: controller.dayController,
                          validator: controller.validateDay,
                          keyboardType: TextInputType.number,
                          isNumber: true,
                          prefix: Icon(LucideIcons.calendar,
                              color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(Duration(milliseconds: 100));
                    controller.createBatch();
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    'Save ',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
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
              Icon(icon, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                title,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...children,
        ],
      ),
    );
  }
}
