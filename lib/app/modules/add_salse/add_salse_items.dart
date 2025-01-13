import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/salse_resonse_model.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddSaleItemSPage extends StatefulWidget {
  @override
  State<AddSaleItemSPage> createState() => _AddSaleItemSPageState();
}

class _AddSaleItemSPageState extends State<AddSaleItemSPage> {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final cratesController = TextEditingController();
  final remainingController = TextEditingController();
  final rateController = TextEditingController();
  final quantityController = TextEditingController();

  var selectedCategory = 'egg';
  String selectedEggType = 'medium';
  double totalAmount = 0.0;

  final categories = ['egg', 'hen', 'manure'];
  final eggTypes = ['small', 'medium', 'large', 'large_plus'];
  final numberFormat = NumberFormat("#,##,###");

  @override
  void initState() {
    super.initState();
    updateItemName();
    cratesController.addListener(calculateQuantityAndTotal);
    remainingController.addListener(calculateQuantityAndTotal);
    rateController.addListener(calculateQuantityAndTotal);
  }

  @override
  void dispose() {
    itemNameController.dispose();
    cratesController.dispose();
    remainingController.dispose();
    rateController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void updateItemName() {
    if (selectedCategory == 'egg') {
      itemNameController.text = '${selectedEggType}_egg';
    } else {
      itemNameController.text = selectedCategory;
    }
  }

  void calculateQuantityAndTotal() {
    if (selectedCategory == 'egg') {
      final crates = int.tryParse(cratesController.text) ?? 0;
      final remaining = int.tryParse(remainingController.text) ?? 0;
      final quantity = (crates * 30) + remaining;
      quantityController.text = quantity.toString();
    }

    final quantity = double.tryParse(quantityController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    setState(() {
      totalAmount = quantity * rate;
    });
  }

  bool hasAtLeastOneValue() {
    return (cratesController.text.isNotEmpty &&
            int.tryParse(cratesController.text) != null) ||
        (remainingController.text.isNotEmpty &&
            int.tryParse(remainingController.text) != null);
  }

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
              if (selectedCategory != 'egg') {
                selectedEggType = '';
                cratesController.clear();
                remainingController.clear();
                quantityController.clear();
                rateController.clear();
              } else {
                selectedEggType = 'medium';
              }
              updateItemName();
              calculateQuantityAndTotal();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildEggTypeChips() {
    return Wrap(
      spacing: 2.w,
      children: eggTypes.map((type) {
        return ChoiceChip(
          label: Text(
            type.toUpperCase().replaceAll('_', ' '),
            style: TextStyle(
              color: selectedEggType == type
                  ? Colors.white
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: selectedEggType == type,
          selectedColor: AppColors.primaryColor,
          backgroundColor: Colors.grey[200],
          onSelected: (selected) {
            setState(() {
              selectedEggType = type;
              updateItemName();
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
          'Add Sale Item',
          style: GoogleFonts.inter(
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
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildCategoryChips(),
                SizedBox(height: 2.h),
                if (selectedCategory == 'egg') ...[
                  Text(
                    'Select Egg Type',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildEggTypeChips(),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          label: 'Total Crates',
                          hint: 'Enter number of crates',
                          controller: cratesController,
                          keyboardType: TextInputType.number,
                          isNumber: true,
                          validator: (value) {
                            if (selectedCategory == 'egg' &&
                                !hasAtLeastOneValue()) {
                              return 'Please enter either crates or remaining eggs';
                            }
                            if (value != null && value.isNotEmpty) {
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: CustomInputField(
                          label: 'खुद्रा अण्डा',
                          hint: 'Enter remaining eggs',
                          controller: remainingController,
                          keyboardType: TextInputType.number,
                          isNumber: true,
                          validator: (value) {
                            if (selectedCategory == 'egg' &&
                                !hasAtLeastOneValue()) {
                              return 'Please enter either crates or remaining eggs';
                            }
                            if (value != null && value.isNotEmpty) {
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (int.parse(value) >= 30) {
                                return 'Remaining eggs should be less than 30';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ] else if (selectedCategory == 'manure') ...[
                  CustomInputField(
                    controller: quantityController,
                    label: 'Enter total bag ( बोरा संख्या)',
                    keyboardType: TextInputType.number,
                    isNumber: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total bag';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  CustomInputField(
                    controller: quantityController,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                    isNumber: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: 3.h),
                CustomInputField(
                  controller: rateController,
                  label: 'Rate',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter rate';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
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
                      if (selectedCategory == 'egg')
                        Text(
                          'Total Quantity: ${quantityController.text}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      SizedBox(height: 1.h),
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Rs. ${numberFormat.format(totalAmount)}',
                        style: TextStyle(
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
                final item = SaleItem(
                  itemName: itemNameController.text,
                  category: selectedCategory,
                  quantity: double.parse(quantityController.text),
                  rate: double.parse(rateController.text),
                  total: totalAmount,
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
