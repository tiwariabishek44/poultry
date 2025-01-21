import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/modules/transction_main_screen/transction_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Screen
class TransactionsScreen extends StatelessWidget {
  final controller = Get.put(TransactionsController());
  final numberFormat = NumberFormat("#,##,###");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchCurrentMonthTransactions,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.filteredTransactions.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildTransactionList();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            SizedBox(width: 12),
            _buildFilterChip('Sales', 'sale'),
            SizedBox(width: 12),
            // _buildFilterChip('Purchases', 'purchase'),
            SizedBox(width: 12),
            _buildFilterChip('Payment In', 'payment_in'),
            SizedBox(width: 12),
            // _buildFilterChip('Paid', 'payment_out'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
      return InkWell(
        onTap: () => controller.updateFilter(value),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : const Color.fromARGB(255, 15, 15, 15)!,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.notoSans(
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 30, 30, 30),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.fileText,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions Available',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      itemCount: controller.filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions[index];
        if (transaction.transactionType == 'OPENING_BALANCE') {
          return SizedBox.shrink();
        }

        final statusColor = transaction.status == "FULL_PAID"
            ? Color(0xFF2E7D32)
            : transaction.status == "PARTIAL_PAID"
                ? Color(0xFFED6C02)
                : Color(0xFFD32F2F);

        final date = DateTime.parse(transaction.transactionDate);
        final formattedDate = "${date.day}/${date.month}/${date.year}";
        final time = transaction.transactionTime.split(':');
        final formattedTime = "${time[0]}:${time[1]}";

        // Function to get display text for transaction type
        String getTransactionTypeDisplay() {
          switch (transaction.transactionType) {
            case 'SALE':
              return 'Sale';
            case 'PURCHASE':
              return 'Purchase';
            case 'PAYMENT_IN':
              return 'Payment Received';
            case 'PAYMENT_OUT':
              return 'Payment Made';
            default:
              return transaction.transactionType;
          }
        }

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
                      getTransactionTypeDisplay(),
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
                      '$formattedDate - $formattedTime',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color.fromARGB(255, 7, 7, 7),
                      ),
                    ),
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
                        if (transaction.unpaidAmount != null &&
                            transaction.unpaidAmount! > 0)
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Unpaid: Rs. ${numberFormat.format(transaction.unpaidAmount ?? 0)}',
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
                    Expanded(
                      child: Text(
                        transaction.remarks,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
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
  }
}
