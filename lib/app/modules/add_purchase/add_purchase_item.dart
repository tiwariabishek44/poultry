import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/purchase_repsonse_model.dart';
import 'package:poultry/app/modules/stock_item/stock_item_controller.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/stock_item_selector.dart';
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
  final stockItemcontroller = Get.put(StockItemsSelectorController());

  var selectedCategory = 'product';
  var selectedSubcategory = 'feed';
  double totalAmount = 0.0;

  final categories = ['product', 'service'];
  final productSubcategories = ['feed', 'medicine', 'equipment', 'other'];
  final serviceSubcategories = ['maintenance', 'veterinary', 'other'];
  final numberFormat = NumberFormat("#,##,###");

  final List<String> commonUnits = [
    'kg', // Kilograms

    'pieces', // Pieces
    'ltr', // Liters
    'ml', // Milliliters
    'box', // Box
    'bag', // Bag
    'dozen', // Dozen
    'pack' // Pack
  ];
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
    super.dispose();
  }

  void calculateTotal() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    setState(() {
      totalAmount = quantity * rate;
    });
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
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Selected Item:',
                            style: GoogleFonts.notoSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  StockSelectorSheet.showSelector(),
                              icon: Icon(Icons.add_circle_outline),
                              label: Text('Select Item'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                side: BorderSide(color: AppColors.primaryColor),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.5.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        final selectedItem =
                            stockItemcontroller.selectedItem.value;
                        if (selectedItem == null) return SizedBox.shrink();

                        return Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _getCategoryIcon(selectedItem.category),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedItem.itemName,
                                          style: GoogleFonts.notoSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          selectedItem.category.capitalize!,
                                          style: GoogleFonts.notoSans(
                                            fontSize: 14.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                CustomInputField(
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
                SizedBox(height: 1.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit',
                      style: GoogleFonts.notoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: unitController.text.isEmpty
                              ? null
                              : unitController.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            'Select Unit',
                            style: GoogleFonts.notoSans(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          items: [
                            ...commonUnits.map((unit) => DropdownMenuItem(
                                  value: unit,
                                  child: Text(
                                    unit,
                                    style:
                                        GoogleFonts.notoSans(fontSize: 16.sp),
                                  ),
                                )),
                            // Add custom option at the end
                            DropdownMenuItem(
                              value: 'custom',
                              child: Row(
                                children: [
                                  Icon(Icons.add,
                                      size: 16.sp,
                                      color: AppColors.primaryColor),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Custom Unit',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == 'custom') {
                              // Show dialog for custom unit input
                              Get.dialog(
                                Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Enter Custom Unit',
                                          style: GoogleFonts.notoSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        CustomInputField(
                                          controller: TextEditingController(),
                                          label: 'Unit',
                                          hint: 'Enter unit name',
                                        ),
                                        SizedBox(height: 2.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: Text('Cancel'),
                                            ),
                                            SizedBox(width: 2.w),
                                            ElevatedButton(
                                              onPressed: () {
                                                final customUnit = Get.find<
                                                        TextEditingController>()
                                                    .text;
                                                if (customUnit.isNotEmpty) {
                                                  unitController.text =
                                                      customUnit;
                                                }
                                                Get.back();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                              ),
                                              child: Text('Add'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (value != null) {
                              unitController.text = value;
                            }
                          },
                          style: GoogleFonts.notoSans(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
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
          child: Obx(() {
            final selectedItem = stockItemcontroller.selectedItem.value;

            return ElevatedButton(
              onPressed: selectedItem == null
                  ? null // Disable button if no item selected
                  : () {
                      if (formKey.currentState?.validate() ?? false) {
                        final item = PurchaseItem(
                          itemName: selectedItem.itemName,
                          category: selectedItem.category,
                          quantity: double.parse(quantityController.text),
                          unit: unitController.text.isEmpty
                              ? null
                              : unitController.text,
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
            );
          }),
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData icon;
    Color color;

    switch (category.toLowerCase()) {
      case 'product':
        icon = Icons.inventory_2_outlined;
        color = Colors.blue;
        break;
      case 'service':
        icon = Icons.build_outlined;
        color = Colors.green;
        break;
      default:
        icon = Icons.category_outlined;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20.sp),
    );
  }
}
