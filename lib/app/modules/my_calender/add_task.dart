import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/my_calender/my_calender_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key});

  final controller = Get.find<CalendarController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(LucideIcons.calendar, size: 18.sp),
              SizedBox(width: 2.w),
              Text(
                'Add New Task',
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
            onPressed: () {
              FocusScope.of(context).unfocus();
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(5.w, 5.w, 5.w, 12.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTaskInputSection(),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInputSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date Select: ${controller.selectedDate.value}",
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Title',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: controller.titleController,
            validator: controller.validateTitle,
            style: GoogleFonts.notoSansDevanagari(fontSize: 16.sp),
            decoration: InputDecoration(
              hintText: 'उदाहरण: दाना खरिद गर्ने',
              prefixIcon:
                  Icon(LucideIcons.penTool, color: AppColors.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dividerColor),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Description',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: controller.descriptionController,
            validator: controller.validateDescription,
            maxLines: 3,
            style: GoogleFonts.notoSansDevanagari(fontSize: 16.sp),
            decoration: InputDecoration(
              hintText: 'विस्तृत विवरण लेख्नुहोस्...',
              prefixIcon:
                  Icon(LucideIcons.alignLeft, color: AppColors.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dividerColor),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Obx(
          () => ElevatedButton.icon(
            onPressed: controller.isLoading.value ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            icon: controller.isLoading.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(LucideIcons.checkCircle2, color: Colors.white),
            label: Text(
              controller.isLoading.value ? 'Saving...' : 'Save',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    // Dismiss keyboard first
    FocusManager.instance.primaryFocus?.unfocus();

    // Small delay to ensure keyboard is dismissed
    await Future.delayed(Duration(milliseconds: 100));

    // Then proceed with form submission
    await controller.createEvent();
  }
}
