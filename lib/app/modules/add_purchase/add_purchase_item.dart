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
  const AddPurchaseItemsPage({super.key});

  @override
  State<AddPurchaseItemsPage> createState() => _AddPurchaseItemsPageState();
}

class _AddPurchaseItemsPageState extends State<AddPurchaseItemsPage> {
  // Original controllers from previous implementation
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final rateController = TextEditingController();
  final unitController = TextEditingController();
  final stockItemcontroller = Get.put(StockItemsSelectorController());

  double totalAmount = 0.0;
  final numberFormat = NumberFormat("#,##,###");

  // Original units list
  final List<String> commonUnits = [
    'kg',
    'piece',
    'box',
    'Bora',
    'Bottel',

    // Add more units as needed
  ];

  @override
  void initState() {
    super.initState();
    // Original listeners
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

  // Original calculation logic
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Add Purchase Item',
        style: GoogleFonts.notoSansDevanagari(
          fontSize: 18.sp,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemSelector(),
              SizedBox(height: 2.h),
              _buildInputSection(),
              SizedBox(height: 2.h),
              _buildTotalAmount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemSelector() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF3182CE),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'सामान छनोट',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(const Duration(milliseconds: 50));
                    StockSelectorSheet.showSelector();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Select'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: BorderSide(color: AppColors.primaryColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              final selectedItem = stockItemcontroller.selectedItem.value;
              if (selectedItem == null) return const SizedBox.shrink();

              return Container(
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF8FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _getCategoryIcon(selectedItem.category),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedItem.itemName,
                            style: GoogleFonts.notoSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            selectedItem.category.capitalize!,
                            style: GoogleFonts.notoSans(
                              fontSize: 14.sp,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          children: [
            CustomInputField(
              controller: quantityController,
              label: 'Quantity',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
            _buildUnitDropdown(),
            SizedBox(height: 2.h),
            CustomInputField(
              controller: rateController,
              label: 'Rate',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: unitController.text.isEmpty ? null : unitController.text,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              border: InputBorder.none,
            ),
            hint: Text(
              'Select Unit',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            items: commonUnits.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(
                  unit,
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                unitController.text = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'जम्मा रकम',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Rs. ${numberFormat.format(totalAmount)}',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(() {
        final selectedItem = stockItemcontroller.selectedItem.value;
        return ElevatedButton(
          onPressed: selectedItem == null
              ? null
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
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        );
      }),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20.sp),
    );
  }
}
