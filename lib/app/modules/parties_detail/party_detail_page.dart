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
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
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
              // _buildQuickActions(),
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
    final party = controller.partyDetails.value!;
    final isCustomer = party.partyType == 'customer';
    final isCredited = party.isCredited;
    final balanceText =
        isCredited ? (isCustomer ? 'To Receive' : 'To Give') : 'Settled';
    final balanceColor = isCredited
        ? (isCustomer ? Color(0xFF2E7D32) : Color(0xFFD32F2F))
        : AppColors.primaryColor;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: balanceColor,
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
                  color: balanceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  balanceText,
                  style: TextStyle(
                    color: balanceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Rs. ${numberFormat.format(party.creditAmount)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: balanceColor,
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
          // Format the transaction time to show only hour and minute
          final time = transaction.transactionTime.split(':');
          final formattedTime = "${time[0]}:${time[1]}";
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate + ' - ' + formattedTime,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 7, 7, 7),
                        ),
                      ),
                      if (transaction.transactionType != 'OPENING_BALANCE')
                        Column(
                          children: [
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
                            if (transaction.transactionType !=
                                    'OPENING_BALANCE' &&
                                transaction.unpaidAmount != null &&
                                transaction.unpaidAmount! >
                                    0) // Add null check here
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  'Unpaid :Rs. ${numberFormat.format(transaction.unpaidAmount ?? 0)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                          ],
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
                backgroundColor: Color.fromARGB(255, 165, 44, 35),
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
                controller.partyDetails.value!.partyType == 'customer'
                    ? 'Payment Recived'
                    : "Payment Give",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 54, 140, 57),
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
