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
        title: Row(
          children: [
            Text(
              'New Batch / नयाँ बैच',
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
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Date Selection Card
              _buildInfoCard(
                title: 'मिति विवरण',
                icon: LucideIcons.calendar,
                children: [
                  CustomInputField(
                    label: 'सुरु मिति / Starting Date',
                    hint: 'मिति छान्नुहोस्',
                    controller: controller.startingDateController,
                    validator: controller.validateStartingDate,
                    prefix: Icon(LucideIcons.calendar,
                        color: AppColors.primaryColor),
                    suffix: Icon(LucideIcons.chevronsUpDown,
                        color: AppColors.primaryColor),
                    onTap: () => controller.pickDate(),
                    readOnly: true,
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Stage Selection Card
              _buildInfoCard(
                title: 'चरण छनौट',
                icon: LucideIcons.layers,
                children: [
                  Text(
                    'हालको अवस्था / Current Stage',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 15.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildStageDropdown(),
                ],
              ),
              SizedBox(height: 5.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Dismiss keyboard first
                    FocusManager.instance.primaryFocus?.unfocus();

                    // Small delay to ensure keyboard is dismissed
                    await Future.delayed(Duration(milliseconds: 100));
                    controller.createBatch();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(LucideIcons.plus, color: Colors.white),
                  label: Text(
                    'Save ',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String label, int number, bool isActive) {
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
              '$number',
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

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 10.w,
      height: 1,
      color: isActive ? AppColors.primaryColor : Colors.grey[300],
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

  Widget _buildStageDropdown() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedStage.value,
              isExpanded: true,
              icon: Icon(LucideIcons.chevronsUpDown,
                  color: AppColors.primaryColor),
              items: controller.stages.map((String stage) {
                return DropdownMenuItem<String>(
                  value: stage,
                  child: Row(
                    children: [
                      Icon(
                        _getStageIcon(stage),
                        color: AppColors.primaryColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        stage,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 15.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedStage.value = newValue;
                }
              },
            ),
          ),
        ));
  }

  IconData _getStageIcon(String stage) {
    switch (stage.toLowerCase()) {
      case 'chick':
        return LucideIcons.egg;
      case 'grower':
        return LucideIcons.bird;
      case 'layer':
        return LucideIcons.bird;
      default:
        return LucideIcons.bird;
    }
  }
}
