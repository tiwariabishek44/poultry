import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/modules/add_purchase/add_purchase.dart';
import 'package:poultry/app/modules/add_salse/add_sale.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/modules/payment/payment_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PartyDetailsPage extends StatelessWidget {
  final String partyId;
  final controller = Get.put(PartyController());
  final numberFormat = NumberFormat("#,##,###");

  PartyDetailsPage({required this.partyId}) {
    controller.fetchPartyDetails(partyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Obx(() => Text(
              controller.partyDetails.value?.partyName ?? 'Party Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return Center(child: CircularProgressIndicator());
        }

        final party = controller.partyDetails.value;
        if (party == null) {
          return Center(child: Text('Party not found'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              _buildQuickActions(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "All Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildTransactionList(),
              SizedBox(height: 100), // Space for floating buttons
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.isLoadingDetails.value) {
          return SizedBox.shrink();
        }
        return _buildFloatingButtons();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: controller.partyDetails.value!.isCredited
              ? Color(0xFF2E7D32)
              : AppColors.primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: controller.partyDetails.value!.isCredited
                      ? Colors.green.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.partyDetails.value!.isCredited
                      ? 'To Recive'
                      : 'Settled',
                  style: TextStyle(
                    color: controller.partyDetails.value!.isCredited
                        ? Color(0xFF2E7D32)
                        : AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Rs. ${numberFormat.format(controller.partyDetails.value!.creditAmount)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: controller.partyDetails.value!.isCredited
                  ? Color(0xFF2E7D32)
                  : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: Icons.call,
            label: 'फोन गर्नुहोस्',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.history,
            label: 'पैसा तिरेको विवरण',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.share,
            label: 'विवरण पठाउनुहोस्',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Obx(() {
      if (controller.isLoadingTransactions.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.transactions.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No transactions found',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          final statusColor = transaction.status == "FULL_PAID"
              ? Color(0xFF2E7D32)
              : transaction.status == "PARTIAL_PAID"
                  ? Color(0xFFED6C02)
                  : Color(0xFFD32F2F);

          final date = DateTime.parse(transaction.transactionDate);
          final formattedDate = "${date.day}/${date.month}/${date.year}";

          return Card(
            margin: EdgeInsets.only(bottom: 1.5.h),
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: transaction.transactionType == "PAYMENT_IN"
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                children: [
                  // Header with Type and Date
                  Row(
                    children: [
                      Icon(
                        transaction.transactionType == "PAYMENT_IN"
                            ? LucideIcons.arrowDownLeft
                            : transaction.transactionType == "PAYMENT_OUT"
                                ? LucideIcons.arrowUpRight
                                : LucideIcons.shoppingCart,
                        color: transaction.transactionType == "PAYMENT_IN"
                            ? Colors.green
                            : transaction.transactionType == "PAYMENT_OUT"
                                ? Colors.red
                                : Colors.blue,
                        size: 18.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        transaction.transactionType,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Rs. ${numberFormat.format(transaction.totalAmount)}',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: transaction.transactionType == "PAYMENT_IN"
                              ? Colors.green.shade700
                              : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1.h),
                  // Amount and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (transaction.transactionType != 'OPENING_BALANCE')
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            transaction.getStatusDisplay(),
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Balance Due :',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: const Color.fromARGB(255, 32, 31, 31),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Rs. ${numberFormat.format(transaction.balance)}',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 22, 21, 21),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (controller.partyDetails.value!.partyType == 'customer') {
                  Get.to(
                      () => AddSalePage(party: controller.partyDetails.value!));
                } else {
                  Get.to(() => AddPurchasePage(
                        party: controller.partyDetails.value!,
                      ));
                }
              },
              label: Text(
                controller.partyDetails.value!.partyType == 'customer'
                    ? 'Sell'
                    : 'Purchase',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(() =>
                    PaymentRecordPage(party: controller.partyDetails.value!));
              },
              label: Text(
                'Payment Recived',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
