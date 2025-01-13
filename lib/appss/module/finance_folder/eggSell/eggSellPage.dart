import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/activity_folder/EggCollection/eggCollectionContorller.dart';
import 'package:poultry/appss/module/finance_folder/eggSell/eggSellController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EggSellScreen extends StatelessWidget {
  final String partyName;
  final String partyId;
  EggSellScreen({Key? key, required this.partyId, required this.partyName})
      : super(key: key);
  final eggSellcontroller = Get.put(EggSellController());

  final _isPageLoaded = false.obs;

  String _formatAmount(int amount) {
    // Convert the amount to a string
    String amountString = amount.toString();

    // If the amount has 3 or fewer digits, return as is (no formatting needed)
    if (amountString.length <= 3) {
      return amountString;
    }

    // Split the string into two parts: last three digits and the rest
    String lastThree = amountString.substring(amountString.length - 3);
    String remaining = amountString.substring(0, amountString.length - 3);

    // Add commas to the remaining part in groups of two digits
    String formattedRemaining = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (Match match) => '${match.group(1)},',
    );

    // Combine the formatted parts
    return '$formattedRemaining,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    eggSellcontroller.selectedParty.value = partyId;
    eggSellcontroller.selectedPartyName.value = partyName;
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text('Egg Sale'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.users, color: AppTheme.primaryColor),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Party: $partyName',
                      style: AppTheme.titleLarge.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            SizedBox(height: 3.h),
            // Egg Type Selection
            Text('Egg Type', style: AppTheme.titleMedium),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildSelectionButton(
                        title: 'Normal', // Translation for "Normal" in Nepali
                        isSelected: eggSellcontroller.eggType.value == 'normal',
                        onTap: () => eggSellcontroller.eggType.value = 'normal',
                      )),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Obx(() => _buildSelectionButton(
                        title:
                            'Crack', // Corrected translation for "Crack" in Nepali
                        isSelected: eggSellcontroller.eggType.value == 'crack',
                        onTap: () => eggSellcontroller.eggType.value = 'crack',
                      )),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Egg Category Selection
            Text('Egg Category', style: AppTheme.titleMedium),
            SizedBox(height: 1.h),
            Obx(() => Wrap(
                  spacing: 2.w,
                  runSpacing: 2.w,
                  children: ['Small', 'Medium', 'Large', 'Extra Large']
                      .map(
                        (category) => _buildSelectionButton(
                          title: category,
                          isSelected: eggSellcontroller.eggCategory.value ==
                              category.toLowerCase(),
                          onTap: () => eggSellcontroller.eggCategory.value =
                              category.toLowerCase(),
                          width: 45.w,
                        ),
                      )
                      .toList(),
                )),

            SizedBox(height: 3.h),

            // Quantity and Price Section
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sale Details', style: AppTheme.titleMedium),
                  SizedBox(height: 2.h),
                  _buildQuantityInput(
                    label: 'Total Crates (कुल क्रेट्स)',
                    controller: eggSellcontroller.crateController,
                    icon: Icons.grid_view,
                  ),
                  SizedBox(height: 2.h),
                  _buildQuantityInput(
                    label: 'Remaining Eggs (खुद्रा अण्डा)',
                    controller: eggSellcontroller.remainingEggsController,
                    icon: Icons.egg,
                  ),
                  SizedBox(height: 2.h),
                  _buildQuantityInput(
                    label: 'Rate per Egg (प्रति अण्डा दर)',
                    controller: eggSellcontroller.rateController,
                    icon: Icons.currency_rupee,
                  ),
                  SizedBox(height: 2.h),
                  Obx(() => Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount:', style: AppTheme.titleMedium),
                            Text(
                              '₹ ' +
                                  _formatAmount(
                                      eggSellcontroller.totalAmount.toInt()),
                              style: AppTheme.titleLarge
                                  .copyWith(color: AppTheme.gradientStart),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            _buildPaymentSection(),

            SizedBox(height: 4.h),

            // Submit Button
            Container(
              width: double.infinity,
              height: 6.h,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: eggSellcontroller.submitSale,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Complete Sale',
                    style: AppTheme.titleMedium.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    double? width,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.textLight,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.gradientStart.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: isSelected ? Colors.white : AppTheme.textMedium,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey, // Light grey color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textMedium),
          SizedBox(width: 3.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: AppTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: AppTheme.bodyLarge,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTheme.bodyMedium,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('भुक्तानी विवरण', style: AppTheme.titleMedium),
          SizedBox(height: 2.h),
          _buildQuantityInput(
            label: 'Paid Amount (भुक्तानी रकम)',
            controller: eggSellcontroller.paidAmountController,
            icon: Icons.payments_outlined,
          ),
          SizedBox(height: 2.h),
          Obx(() => Container(
                width: 100.w,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: eggSellcontroller.creditAmount.value > 0
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'बाँकी रकम',
                      style: AppTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '₹ ${_formatAmount(eggSellcontroller.creditAmount.toInt())}',
                      style: AppTheme.titleLarge.copyWith(
                        color: eggSellcontroller.creditAmount.value > 0
                            ? Colors.red
                            : Colors.green,
                        fontSize: 20.sp,
                      ),
                    ),
                    if (eggSellcontroller.creditAmount.value > 0)
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          'उधारो रकम',
                          style: AppTheme.titleMedium.copyWith(
                            color: Colors.red,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
