// sales_tab.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/parytDetailPage/payment.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompactSaleCard extends StatelessWidget {
  final String partyName;
  final Map<String, dynamic> saleData;

  const CompactSaleCard({
    Key? key,
    required this.saleData,
    required this.partyName,
  }) : super(key: key);

  String _formatAmount(int amount) {
    String amountString = amount.toString();
    if (amountString.length <= 3) return amountString;
    String lastThree = amountString.substring(amountString.length - 3);
    String remaining = amountString.substring(0, amountString.length - 3);
    String formattedRemaining = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (Match match) => '${match.group(1)},',
    );
    return '$formattedRemaining,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = (saleData['totalAmount'] ?? 0).toDouble();
    final creditAmount = (saleData['creditAmount'] ?? 0).toDouble();
    final totalEggs = saleData['totalEggs'] ?? 0;
    final crates = saleData['crates'] ?? 0;
    final remainingEggs = saleData['remainingEggs'] ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
      child: InkWell(
        onTap: () => _showDetailBottomSheet(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              // Top Row: Date and Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: AppTheme.textLight),
                      SizedBox(width: 1.w),
                      Text(
                        saleData['saleDate'] ?? '',
                        style: AppTheme.bodyMedium
                            .copyWith(color: AppTheme.textLight),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      saleData['eggType'] == 'normal' ? 'Normal' : 'Crack',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Egg Type Badge
                  SizedBox(width: 1.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      saleData['eggCategory']?.toString().toUpperCase() ?? '',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textMedium,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Middle Row: Amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Amount
                  Text(
                    '₹ ${_formatAmount(totalAmount.toInt())}',
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Payment Status
                  Row(
                    children: [
                      creditAmount > 0
                          ? Row(
                              children: [
                                Icon(
                                  Icons.arrow_circle_down_outlined,
                                  size: 18, // Increased from 16
                                  color: Colors.red,
                                ),
                                SizedBox(width: 1.2.w), // Slightly increased
                                Text(
                                  '₹${_formatAmount(creditAmount.toInt())}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16.sp, // Increased from 15.sp
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'पूर्ण भुक्तानी',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.green,
                              ),
                            ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Bottom Row: Egg Details
              Row(
                children: [
                  Icon(Icons.egg_outlined, size: 16, color: AppTheme.textLight),
                  SizedBox(width: 1.w),
                  Text(
                    '$crates क्रेट + $remainingEggs खुद्रा ',
                    style:
                        AppTheme.bodyMedium.copyWith(color: AppTheme.textLight),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
// Inside CompactSaleCard class, update the _showDetailBottomSheet method:

  void _showDetailBottomSheet(BuildContext context) {
    final totalAmount = (saleData['totalAmount'] ?? 0).toDouble();
    final paidAmount = (saleData['paidAmount'] ?? 0).toDouble();
    final creditAmount = (saleData['creditAmount'] ?? 0).toDouble();
    final crates = saleData['crates'] ?? 0;
    final remainingEggs = saleData['remainingEggs'] ?? 0;
    final totalEggs = saleData['totalEggs'] ?? 0;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(4.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: AppTheme.primaryColor, size: 20),
                    SizedBox(width: 2.w),
                    Text(
                      saleData['saleDate'] ?? '',
                      style: AppTheme.titleMedium,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),

            Divider(height: 3.h),

            // Egg Type and Category Section
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.egg_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 2.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saleData['eggType'] == 'normal'
                          ? 'साधारण अण्डा'
                          : 'चुँकेको अण्डा',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      saleData['eggCategory']?.toString().toUpperCase() ?? '',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Quantities Section
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuantityColumn('क्रेट', crates.toString()),
                  Container(
                    height: 8.h,
                    width: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  _buildQuantityColumn('खुद्रा', remainingEggs.toString()),
                  Container(
                    height: 8.h,
                    width: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  _buildQuantityColumn('जम्मा', totalEggs.toString(),
                      highlighted: true),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Amount Details Section
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildAmountRow('कुल रकम', totalAmount.toInt(), isBold: true),
                  SizedBox(height: 1.h),

                  // Stream builder for payments
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('payments')
                        .where('saleId', isEqualTo: saleData['saleId'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return _buildAmountRow(
                            'भुक्तानी रकम', paidAmount.toInt(),
                            isGreen: true);
                      }

                      final payments = snapshot.data?.docs ?? [];

                      return Column(
                        children: [
                          for (var payment in payments)
                            Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'भुक्तानी रकम',
                                        style: AppTheme.bodyLarge,
                                      ),
                                      Text(
                                        " (${payment['date']})",
                                        style: AppTheme.bodyMedium.copyWith(
                                            fontSize: 12,
                                            color: AppTheme.textLight),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹ ${_formatAmount(payment['amount'].toInt())}',
                                    style: AppTheme.titleMedium.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  if (creditAmount > 0) ...[
                    SizedBox(height: 1.h),
                    _buildAmountRow('बाँकी रकम', creditAmount.toInt(),
                        isRed: true),
                  ],
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Rate Details
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'प्रति अण्डा दर',
                    style: AppTheme.bodyLarge,
                  ),
                  Text(
                    '₹ ${saleData['ratePerEgg'] ?? 0}',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Payment Status
            if (creditAmount > 0)
              // Payment Button for Credit
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close bottom sheet
                    Get.to(() => CreditPaymentPage(
                        partyId: saleData['partyId'],
                        salesId: saleData['saleId'],
                        saleType: 'eggSales',
                        partyName: partyName));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Collect Payment',
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildQuantityColumn(String label, String value,
      {bool highlighted = false}) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textLight,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            color: highlighted ? AppTheme.primaryColor : Colors.black,
            fontWeight: highlighted ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(String label, int amount,
      {bool isBold = false, bool isGreen = false, bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '₹ ${_formatAmount(amount)}',
          style: AppTheme.titleMedium.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isGreen ? Colors.green : (isRed ? Colors.red : Colors.black),
          ),
        ),
      ],
    );
  }
}
