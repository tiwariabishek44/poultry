// add_expense_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_expense/add_expense_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddExpensePage extends StatelessWidget {
  final controller = Get.put(ExpenseController());
  final dateSelectorController = Get.put(DateSelectorController());

  @override
  Widget build(BuildContext context) {
    final expenseTypes = ['General', 'Batch'];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'New Expense',
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
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExpenseTypeSection(expenseTypes),
              SizedBox(height: 2.h),
              _buildExpenseDetailsCard(),
              SizedBox(height: 2.h),
              DateSelectorWidget(
                label: 'Select Date',
                showCard: false,
                hint: 'Choose a date',
              ),
              SizedBox(height: 2.h),
              _buildNotesCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

// Completing the expense page
  Widget _buildExpenseTypeSection(List<String> expenseTypes) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.receipt,
                    size: 18,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'खर्चको प्रकार',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Batch',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 15.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Obx(
                    () => Switch.adaptive(
                      value: controller.expenseType.value == 'batch',
                      onChanged: (value) {
                        controller.expenseType.value =
                            value ? 'batch' : 'GENERAL';
                      },
                      activeColor: AppColors.primaryColor,
                      activeTrackColor: AppColors.primaryColor.withOpacity(0.2),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(() {
            if (controller.expenseType.value == 'batch') {
              // Add your batch-specific widgets here if needed
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: BatchesDropDown(
                    isDropDown: true), // Make sure to import this widget
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }

  Widget _buildExpenseDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.receipt, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'Expense Details',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Category',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonFormField<String>(
              value: controller.category.value.isEmpty
                  ? null
                  : controller.category.value,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                border: InputBorder.none,
              ),
              hint: Text(
                'Select Category',
                style: GoogleFonts.notoSans(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              items: controller.expenseCategories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style:
                              GoogleFonts.notoSansDevanagari(fontSize: 16.sp),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.category.value = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            controller: controller.amountController,
            label: 'Amount',
            hint: 'Enter amount',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                'Notes',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            controller: controller.notes,
            hint: 'Add any additional notes here...',
            maxLines: 3,
            label: 'Write Any Notes',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
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
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(Duration(milliseconds: 100));
            controller.createExpenseRecord(
              dateSelectorController.dateController.text,
              dateSelectorController.selectedMonthYear.value,
            );
          },
          icon: Icon(LucideIcons.checkCircle2, color: Colors.white),
          label: Text(
            'Save Expense',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
