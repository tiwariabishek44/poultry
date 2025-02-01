import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/transction_response_model.dart';
import 'package:poultry/app/modules/transction_main_screen/transction_controller.dart';
import 'package:poultry/app/widget/year_month_filter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransactionsScreen extends StatelessWidget {
  final controller = Get.put(TransactionsController());
  final numberFormat = NumberFormat("#,##,###");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leadingWidth: 64,
        title: Text(
          'Transactions',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: NepaliMonthYearPickers(
              onDateSelected: (string) {
                controller.selectedYearMonth.value = string;
                controller.fetchCurrentMonthTransactions();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchCurrentMonthTransactions,
              color: Colors.black87,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black54,
                    ),
                  );
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
      height: 48,
      margin: EdgeInsets.fromLTRB(2.w, 2.w, 20, 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            label: 'All',
            value: 'all',
            icon: LucideIcons.layoutGrid,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Sales',
            value: 'sale',
            icon: LucideIcons.shoppingBag,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Purchases',
            value: 'purchase',
            icon: LucideIcons.package,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Payment In',
            value: 'payment_in',
            icon: LucideIcons.arrowDownLeft,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Payment Out',
            value: 'payment_out',
            icon: LucideIcons.arrowUpRight,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Expense',
            value: 'expense',
            icon: LucideIcons.receipt,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
      return InkWell(
        onTap: () => controller.updateFilter(value),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black87 : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? Colors.black87 : Colors.grey.shade300,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.fileText,
              size: 32,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'कुनै कारोबार छैन',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions[index];
        if (transaction.transactionType == 'OPENING_BALANCE') {
          return const SizedBox.shrink();
        }

        final date = DateTime.parse(transaction.transactionDate);
        final formattedDate = "${date.day}/${date.month}/${date.year}";
        final time = transaction.transactionTime.split(':');
        final formattedTime = "${time[0]}:${time[1]}";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildTransactionIcon(transaction),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _getTransactionTypeDisplay(
                                        transaction.transactionType),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (_shouldShowStatus(transaction)) ...[
                                    const SizedBox(width: 8),
                                    _buildStatusBadge(transaction),
                                  ],
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.calendar,
                                    size: 14,
                                    color: Colors.black45,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$formattedDate · $formattedTime',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rs. ${numberFormat.format(transaction.totalAmount)}',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _getAmountColor(
                                    transaction.transactionType),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (transaction.remarks.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.alignLeft,
                              size: 16,
                              color: Colors.black45,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                transaction.remarks,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionIcon(TransactionResponseModel transaction) {
    final IconData icon;
    final Color color;

    switch (transaction.transactionType) {
      case 'SALE':
        icon = LucideIcons.shoppingBag;
        color = Colors.blue.shade700;
        break;
      case 'PURCHASE':
        icon = LucideIcons.package;
        color = Colors.purple.shade700;
        break;
      case 'PAYMENT_IN':
        icon = LucideIcons.arrowDownLeft;
        color = Colors.green.shade700;
        break;
      case 'PAYMENT_OUT':
        icon = LucideIcons.arrowUpRight;
        color = Colors.red.shade700;
        break;
      case 'EXPENSE':
        icon = LucideIcons.receipt;
        color = Colors.orange.shade700;
        break;
      default:
        icon = LucideIcons.fileText;
        color = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  bool _shouldShowStatus(TransactionResponseModel transaction) {
    return transaction.transactionType == 'SALE' ||
        transaction.transactionType == 'PURCHASE';
  }

  bool _shouldShowUnpaidAmount(TransactionResponseModel transaction) {
    return transaction.transactionType == 'SALE' ||
        transaction.transactionType == 'PURCHASE';
  }

  Widget _buildStatusBadge(TransactionResponseModel transaction) {
    Color color;
    String text;

    switch (transaction.status) {
      case "FULL_PAID":
        color = Colors.green.shade700;
        text = "Paid";
        break;
      case "PARTIAL_PAID":
        color = Colors.orange.shade700;
        text = "Partial";
        break;
      default:
        color = Colors.red.shade700;
        text = "Unpaid";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  String _getTransactionTypeDisplay(String type) {
    switch (type) {
      case 'SALE':
        return 'Sale';
      case 'PURCHASE':
        return 'Purchase';
      case 'PAYMENT_IN':
        return 'Payment Received';
      case 'PAYMENT_OUT':
        return 'Payment Made';
      case 'EXPENSE':
        return 'Expense';
      default:
        return type;
    }
  }

  Color _getAmountColor(String type) {
    switch (type) {
      case 'PAYMENT_IN':
      case 'SALE':
        return Colors.green.shade700;
      case 'PAYMENT_OUT':
      case 'EXPENSE':
        return Colors.red.shade700;
      default:
        return Colors.black87;
    }
  }
}
