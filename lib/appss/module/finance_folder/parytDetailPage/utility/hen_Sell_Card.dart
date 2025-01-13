import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/parytDetailPage/payment.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HenSaleCard extends StatelessWidget {
  final String partyName;
  final Map<String, dynamic> saleData;

  const HenSaleCard({
    Key? key,
    required this.saleData,
    required this.partyName,
  }) : super(key: key);

  String _formatAmount(num amount) {
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

  String _getFormattedDetails() {
    final saleUnit = saleData['saleUnit'] ?? 'गोटा';
    final rate = saleData['rate'] ?? 0;

    if (saleUnit == 'के.जी.') {
      final totalHenCount = saleData['totalHenCount'] ?? 0;
      final totalKgWeight = (saleData['totalKgWeight'] ?? 0).toDouble();
      return '${totalHenCount} वटा (${totalKgWeight.toStringAsFixed(2)} के.जी.) @ ₹$rate/के.जी.';
    } else {
      final totalHenCount = saleData['totalHenCount'] ?? 0;
      return '$totalHenCount वटा @ ₹$rate/गोटा';
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = (saleData['totalAmount'] ?? 0).toDouble();
    final creditAmount = (saleData['creditAmount'] ?? 0).toDouble();
    final saleUnit = saleData['saleUnit'] ?? 'गोटा';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
      child: InkWell(
        onTap: () => _showDetailBottomSheet(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              // Top Row: Date and Sale Unit
              Row(
                children: [
                  Icon(LucideIcons.calendar,
                      size: 14, color: AppTheme.textLight),
                  SizedBox(width: 1.w),
                  Text(
                    saleData['saleDate'] ?? '',
                    style:
                        AppTheme.bodyMedium.copyWith(color: AppTheme.textLight),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Middle Row: Amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${_formatAmount(totalAmount.toInt())}',
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        creditAmount > 0
                            ? LucideIcons.alertCircle
                            : LucideIcons.checkCircle2,
                        size: 16,
                        color: creditAmount > 0 ? Colors.red : Colors.green,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        creditAmount > 0
                            ? '₹ ${_formatAmount(creditAmount.toInt())} बाँकी'
                            : 'पूर्ण भुक्तानी',
                        style: AppTheme.bodyMedium.copyWith(
                          color: creditAmount > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Bottom Row: Hen Details
              Row(
                children: [
                  Icon(LucideIcons.bird, size: 16, color: AppTheme.textLight),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      _getFormattedDetails(),
                      style: AppTheme.bodyMedium
                          .copyWith(color: AppTheme.textLight),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context) {
    final totalAmount = (saleData['totalAmount'] ?? 0).toDouble();
    final paidAmount = (saleData['paidAmount'] ?? 0).toDouble();
    final creditAmount = (saleData['creditAmount'] ?? 0).toDouble();
    final saleUnit = saleData['saleUnit'] ?? 'गोटा';
    final rate = saleData['rate'] ?? 0;

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
                    Icon(LucideIcons.calendar,
                        color: AppTheme.primaryColor, size: 20),
                    SizedBox(width: 2.w),
                    Text(saleData['saleDate'] ?? '',
                        style: AppTheme.titleMedium),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Get.back(),
                ),
              ],
            ),

            Divider(height: 3.h),

            // Hen Details Section
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(LucideIcons.bird,
                      color: AppTheme.primaryColor, size: 20),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('कुखुरा बिक्री',
                          style: AppTheme.bodyLarge
                              .copyWith(fontWeight: FontWeight.w500)),
                      if (saleUnit == 'के.जी.') ...[
                        Text(
                          'कुल कुखुरा: ${saleData['totalHenCount']} वटा',
                          style: AppTheme.bodyMedium
                              .copyWith(color: AppTheme.textLight),
                        ),
                        Text(
                          'कुल तौल: ${(saleData['totalKgWeight'] ?? 0).toStringAsFixed(2)} के.जी. @ ₹$rate/के.जी.',
                          style: AppTheme.bodyMedium
                              .copyWith(color: AppTheme.textLight),
                        ),
                      ] else
                        Text(
                          '${saleData['totalHenCount']} वटा @ ₹$rate/गोटा',
                          style: AppTheme.bodyMedium
                              .copyWith(color: AppTheme.textLight),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Rest of the bottom sheet remains the same...
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

                  // Payment stream builder section remains the same...
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
                                      Text('भुक्तानी रकम',
                                          style: AppTheme.bodyLarge),
                                      Text(
                                        " (${payment['date']})",
                                        style: AppTheme.bodyMedium.copyWith(
                                            fontSize: 12,
                                            color: AppTheme.textLight),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹ ${_formatAmount(payment['amount'])}',
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

            SizedBox(height: 3.h),

            // Payment Status Button
            if (creditAmount > 0)
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => CreditPaymentPage(
                          partyId: saleData['partyId'],
                          salesId: saleData['saleId'],
                          saleType: 'henSales',
                          partyName: partyName,
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'भुक्तानी गर्नुहोस्',
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'पूर्ण भुक्तानी भएको',
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
