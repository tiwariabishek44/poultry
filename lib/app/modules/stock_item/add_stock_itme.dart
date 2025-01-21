// add_stock_item_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/stock_item/stock_item_controller.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddStockItemPage extends StatelessWidget {
  final controller = Get.find<StockItemController>();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  // Add RxString for selected category
  final Rx<String> selectedCategory = 'product'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Add Stock Item',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormCard(),
              SizedBox(height: 4.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
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
          _buildItemNameField(),
          SizedBox(height: 3.h),
          _buildCategorySelector(),
        ],
      ),
    );
  }

  Widget _buildItemNameField() {
    return CustomInputField(
      controller: nameController,
      label: 'Item Name',
      hint: 'Enter item name',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter item name';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.notoSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        FormField<String>(
          initialValue: selectedCategory.value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 2.w,
                  children: [
                    _buildChoiceChip('Product', 'product', field),
                    _buildChoiceChip('Service', 'service', field),
                  ],
                ),
                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildChoiceChip(
      String label, String value, FormFieldState<String> field) {
    return Obx(() => ChoiceChip(
          label: Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 15.sp,
              color: selectedCategory.value == value
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          selected: selectedCategory.value == value,
          selectedColor: AppColors.primaryColor,
          backgroundColor: Colors.grey[100],
          onSelected: (bool selected) {
            if (selected) {
              selectedCategory.value = value;
              field.didChange(value);
            }
          },
        ));
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (formKey.currentState?.validate() ?? false) {
            FocusManager.instance.primaryFocus?.unfocus();

            // Small delay to ensure keyboard is dismissed
            await Future.delayed(Duration(milliseconds: 100));

            controller.createStockItem(
                itemName: nameController.text,
                category: selectedCategory.value);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(LucideIcons.save, color: Colors.white),
        label: Text(
          'Save Item',
          style: GoogleFonts.notoSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
