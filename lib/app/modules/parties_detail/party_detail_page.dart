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
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 64,
        scrolledUnderElevation: 0,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(LucideIcons.chevronLeft,
                  color: Colors.black87, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.partyDetails.value?.partyName ?? 'Party Details',
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  controller.partyDetails.value?.partyType == 'supplier'
                      ? 'Supplier'
                      : 'Customer',
                  style: GoogleFonts.inter(
                    color:
                        controller.partyDetails.value?.partyType == 'supplier'
                            ? Colors.blue
                            : Colors.green,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )),
        centerTitle: false,
        toolbarHeight: 70,
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black54,
            ),
          );
        }

        final party = controller.partyDetails.value;
        if (party == null) {
          return Center(
            child: Text(
              'No data available',
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildBalanceCard()),
            // SliverToBoxAdapter(child: _buildQuickActions()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      "All  Transactions",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            _buildTransactionList(),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoadingDetails.value) return const SizedBox.shrink();
        return _buildBottomActions();
      }),
    );
  }

  Widget _buildBalanceCard() {
    final party = controller.partyDetails.value!;
    final isCustomer = party.partyType == 'customer';
    final isCredited = party.isCredited;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isCredited
                ? (isCustomer ? Colors.green : Colors.red)
                : Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: GoogleFonts.inter(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rs. ${numberFormat.format(party.creditAmount)}',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCredited
                      ? (isCustomer ? Colors.green : Colors.red)
                      : Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCredited
                      ? (isCustomer ? 'To Receive' : 'To Pay')
                      : 'Settled',
                  style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          // if (isCredited) ...[
          //   const SizedBox(height: 20),
          //   Container(
          //     padding: const EdgeInsets.all(12),
          //     decoration: BoxDecoration(
          //       color: Colors.grey.shade50,
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Last Transaction',
          //               style: GoogleFonts.inter(
          //                 fontSize: 12,
          //                 color: Colors.black54,
          //               ),
          //             ),
          //             const SizedBox(height: 4),
          //             Text(
          //               '2 days ago',
          //               style: GoogleFonts.inter(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w500,
          //                 color: Colors.black87,
          //               ),
          //             ),
          //           ],
          //         ),
          //         Container(
          //           height: 24,
          //           width: 1,
          //           color: Colors.grey.shade200,
          //         ),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Payment Due',
          //               style: GoogleFonts.inter(
          //                 fontSize: 12,
          //                 color: Colors.black54,
          //               ),
          //             ),
          //             const SizedBox(height: 4),
          //             Text(
          //               'In 5 days',
          //               style: GoogleFonts.inter(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w500,
          //                 color: Colors.orange.shade700,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: LucideIcons.phone,
            label: 'फोन गर्नुहोस्',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.picture_as_pdf_outlined,
            label: 'पैसा तिरेको विवरण',
            onTap: () {},
          ),
          _buildActionButton(
            icon: LucideIcons.share2,
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 19.sp,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Obx(() {
      if (controller.isLoadingTransactions.value) {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black54,
            ),
          ),
        );
      }

      if (controller.transactions.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.clipboardList,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions yet',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final transaction = controller.transactions[index];
            return _buildTransactionTile(transaction);
          },
          childCount: controller.transactions.length,
        ),
      );
    });
  }

  Widget _buildTransactionTile(TransactionResponseModel transaction) {
    final date = DateTime.parse(transaction.transactionDate);
    final formattedDate = "${date.day}/${date.month}/${date.year}";
    final time = transaction.transactionTime.split(':');
    final formattedTime = "${time[0]}:${time[1]}";

    final isPayment = transaction.transactionType.contains("PAYMENT");
    final isPurchase = !isPayment;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            getTransactionTypeColor(transaction.transactionType)
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                          getTransactionTypeIcon(transaction.transactionType),
                          size: 16,
                          color: getTransactionTypeColor(
                              transaction.transactionType)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.transactionType,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$formattedDate · $formattedTime',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${numberFormat.format(transaction.totalAmount)}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (transaction.transactionType != 'OPENING_BALANCE' &&
                            transaction.transactionType != 'PAYMENT_OUT' &&
                            transaction.transactionType != 'PAYMENT_IN') ...[
                          const SizedBox(height: 4),
                          _buildStatusChip(transaction),
                          SizedBox(height: 2.h),
                        ]
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (transaction.transactionType != 'OPENING_BALANCE' &&
                        transaction.transactionType != 'PAYMENT_OUT' &&
                        transaction.transactionType != 'PAYMENT_IN')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unpaid Amount',
                            style: GoogleFonts.inter(
                              fontSize: 14.5.sp,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs. ${numberFormat.format(transaction.unpaidAmount ?? 0.0)}',
                            style: GoogleFonts.inter(
                              fontSize: 15.5.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Balance Due',
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${numberFormat.format(transaction.balance ?? 0.0)}',
                          style: GoogleFonts.inter(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to get icon for transaction type
  IconData getTransactionTypeIcon(String transactionType) {
    switch (transactionType) {
      case 'SALE':
        return LucideIcons.shoppingCart;
      case 'PURCHASE':
        return LucideIcons.shoppingCart;
      case 'PAYMENT_IN':
        return LucideIcons.arrowDownLeft;
      case 'PAYMENT_OUT':
        return LucideIcons.arrowUpRight;
      case 'EXPENSE':
        return LucideIcons.creditCard;
      default:
        return LucideIcons.fileText;
    }
  }

  Color getTransactionTypeColor(String transactionType) {
    switch (transactionType) {
      case 'PAYMENT_IN':
        return Colors.green;
      case 'PAYMENT_OUT':
        return Colors.red;
      case 'EXPENSE':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Widget _buildStatusChip(TransactionResponseModel transaction) {
    Color statusColor;
    String statusText;

    switch (transaction.status) {
      case "FULL_PAID":
        statusColor = Colors.green.shade700;
        statusText = "Paid";
        break;
      case "PARTIAL_PAID":
        statusColor = Colors.orange.shade700;
        statusText = "Partial";
        break;
      default:
        statusColor = Colors.red.shade700;
        statusText = "Unpaid";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Get.to(() =>
                    PaymentRecordPage(party: controller.partyDetails.value!));
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: const Color.fromARGB(255, 109, 108, 108)),
                ),
              ),
              child: Text(
                controller.partyDetails.value!.partyType == 'customer'
                    ? 'Payment Revice'
                    : "Payment Give",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (controller.partyDetails.value!.partyType == 'customer') {
                  Get.to(
                      () => AddSalePage(party: controller.partyDetails.value!));
                } else {
                  Get.to(() =>
                      AddPurchasePage(party: controller.partyDetails.value!));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 54, 140, 57),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                controller.partyDetails.value!.partyType == 'customer'
                    ? 'New Sale'
                    : 'New Purchase',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
