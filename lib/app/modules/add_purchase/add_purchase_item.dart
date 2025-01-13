import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/purchase_repsonse_model.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddPurchaseItemsPage extends StatefulWidget {
  @override
  State<AddPurchaseItemsPage> createState() => _AddPurchaseItemsPageState();
}

class _AddPurchaseItemsPageState extends State<AddPurchaseItemsPage> {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final rateController = TextEditingController();
  final unitController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedCategory = 'product';
  var selectedSubcategory = 'feed';
  double totalAmount = 0.0;

  final categories = ['product', 'service'];
  final productSubcategories = ['feed', 'medicine', 'equipment', 'other'];
  final serviceSubcategories = ['maintenance', 'veterinary', 'labor', 'other'];
  final numberFormat = NumberFormat("#,##,###");

  @override
  void initState() {
    super.initState();
    quantityController.addListener(calculateTotal);
    rateController.addListener(calculateTotal);
  }

  @override
  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    rateController.dispose();
    unitController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void calculateTotal() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    setState(() {
      totalAmount = quantity * rate;
    });
  }

  List<String> get currentSubcategories => selectedCategory == 'product'
      ? productSubcategories
      : serviceSubcategories;

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 2.w,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(
            category.toUpperCase(),
            style: TextStyle(
              color: selectedCategory == category
                  ? Colors.white
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: selectedCategory == category,
          selectedColor: AppColors.primaryColor,
          backgroundColor: Colors.grey[200],
          onSelected: (selected) {
            setState(() {
              selectedCategory = category;
              selectedSubcategory = currentSubcategories[0];
              itemNameController.clear();
              quantityController.clear();
              rateController.clear();
              calculateTotal();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSubcategoryChips() {
    return Wrap(
      spacing: 2.w,
      children: currentSubcategories.map((subcategory) {
        return ChoiceChip(
          label: Text(
            subcategory.toUpperCase(),
            style: TextStyle(
              color: selectedSubcategory == subcategory
                  ? Colors.white
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: selectedSubcategory == subcategory,
          selectedColor: AppColors.primaryColor,
          backgroundColor: Colors.grey[200],
          onSelected: (selected) {
            setState(() {
              selectedSubcategory = subcategory;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Purchase Item',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Category',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildCategoryChips(),
                SizedBox(height: 2.h),
                Text(
                  'Select Subcategory',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildSubcategoryChips(),
                SizedBox(height: 2.h),
                CustomInputField(
                  controller: itemNameController,
                  label: 'Item Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomInputField(
                        controller: quantityController,
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: CustomInputField(
                        controller: unitController,
                        label: 'Unit',
                        hint: 'kg/pcs',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                CustomInputField(
                  controller: rateController,
                  label: 'Rate',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                CustomInputField(
                  controller: descriptionController,
                  label: 'Description (Optional)',
                  maxLines: 2,
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Rs. ${numberFormat.format(totalAmount)}',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(2.h),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final item = PurchaseItem(
                  itemName: itemNameController.text,
                  category: selectedCategory,
                  subcategory: selectedSubcategory,
                  quantity: double.parse(quantityController.text),
                  unit:
                      unitController.text.isEmpty ? null : unitController.text,
                  rate: double.parse(rateController.text),
                  total: totalAmount,
                  description: descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                );

                Get.back(result: item);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Add Item',
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
}
