import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_finance/batch_finance_controller.dart';
import 'package:poultry/app/modules/batch_finance/report_geneartor.dart';
import 'package:poultry/app/widget/loading_State.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class BatchFinancePage extends StatelessWidget {
  final controller = Get.put(BatchFinanceController());
  final String batchId;
  final numberFormat = NumberFormat("#,##,###");

  BatchFinancePage({required this.batchId}) {
    controller.loadBatchFinanceSummary(batchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: LoadingState(text: 'वित्तीय विवरण लोड गर्दै...'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadBatchFinanceSummary(batchId),
          color: Colors.black87,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickStats(),
                _buildFinancialOverview(),
                _buildDetailedAnalysis(),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leadingWidth: 64,
      leading: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon:
                Icon(LucideIcons.chevronLeft, color: Colors.black87, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch Finance',
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'ब्याच वित्तीय विवरण',
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.helpCircle, color: Colors.black54),
          onPressed: () => _showHelpDialog(),
        ),
        // IconButton(
        //   icon: Icon(LucideIcons.fileText, color: Colors.black54),
        //   onPressed: () => Get.to(() => BatchFinancePdfPage(
        //         batchName: 'Abishek Tiwari batch ',
        //       )),
        // ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      height: 120,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickStatCard(
              title: 'Total Revenue',
              nepaliTitle: 'कुल आम्दानी',
              amount: controller.totalSales.value,
              icon: LucideIcons.trendingUp,
              color: const Color(0xFF38A169),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickStatCard(
              title: 'Total Cost',
              nepaliTitle: 'कुल लागत',
              amount: controller.totalPurchases.value +
                  controller.totalExpenses.value,
              icon: LucideIcons.trendingDown,
              color: const Color(0xFFE53E3E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard({
    required String title,
    required String nepaliTitle,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            nepaliTitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rs. ${numberFormat.format(amount)}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview() {
    final isProfit = controller.profit.value >= 0;
    final profitColor =
        isProfit ? const Color(0xFF38A169) : const Color(0xFFE53E3E);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.wallet,
                  color: Color(0xFF3182CE),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'वित्तीय सारांश',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    'Financial Summary',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: profitColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isProfit ? 'Profit' : 'Loss',
                  style: TextStyle(
                    color: profitColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: profitColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net ${isProfit ? 'Profit' : 'Loss'}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Rs. ${numberFormat.format(controller.profit.value.abs())}',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: profitColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildBreakdownItem(
            title: 'Sales Revenue',
            nepaliTitle: 'बिक्री आम्दानी',
            amount: controller.totalSales.value,
            icon: LucideIcons.shoppingBag,
            color: const Color(0xFF38A169),
          ),
          const Divider(height: 24),
          _buildBreakdownItem(
            title: 'Purchase Cost',
            nepaliTitle: 'खरिद लागत',
            amount: controller.totalPurchases.value,
            icon: LucideIcons.shoppingCart,
            color: const Color(0xFF3182CE),
          ),
          const Divider(height: 24),
          _buildBreakdownItem(
            title: 'Operating Expenses',
            nepaliTitle: 'सञ्चालन खर्च',
            amount: controller.totalExpenses.value,
            icon: LucideIcons.receipt,
            color: const Color(0xFFDD6B20),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem({
    required String title,
    required String nepaliTitle,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nepaliTitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D3748),
                ),
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
        Text(
          'Rs. ${numberFormat.format(amount)}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Text(
            "Detailed Analysis",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.3,
            ),
          ),
        ),
        _buildAnalysisSection(
          title: 'Sales Breakdown',
          nepaliTitle: 'बिक्री विश्लेषण',
          items: controller.topSellingCategories,
          total: controller.totalSales.value,
          getPercentage: controller.getSalesPercentage,
          icon: LucideIcons.barChart2,
          color: const Color(0xFF38A169),
        ),
        const SizedBox(height: 16),
        _buildAnalysisSection(
          title: 'Purchase Analysis',
          nepaliTitle: 'खरिद विश्लेषण',
          items: controller.topPurchasedItems,
          total: controller.totalPurchases.value,
          getPercentage: controller.getPurchasePercentage,
          icon: LucideIcons.shoppingCart,
          color: const Color(0xFF3182CE),
        ),
        const SizedBox(height: 16),
        _buildAnalysisSection(
          title: 'Expense Categories',
          nepaliTitle: 'खर्च श्रेणीहरू',
          items: controller.topExpenseCategories,
          total: controller.totalExpenses.value,
          getPercentage: controller.getExpensePercentage,
          icon: LucideIcons.receipt,
          color: const Color(0xFFDD6B20),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAnalysisSection({
    required String title,
    required String nepaliTitle,
    required List<MapEntry<String, double>> items,
    required double total,
    required double Function(String) getPercentage,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nepaliTitle,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Rs. ${numberFormat.format(total)}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.searchX,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'कुनै डाटा उपलब्ध छैन',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                final percentage = getPercentage(item.key);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.key,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          'Rs. ${numberFormat.format(item.value)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      LucideIcons.helpCircle,
                      color: Color(0xFF3182CE),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'रिपोर्ट बारे जानकारी',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ..._buildHelpItem(
                'नाफा/नोक्सान',
                'कुल बिक्री - (कुल खरिद + कुल खर्च)',
                LucideIcons.calculator,
              ),
              ..._buildHelpItem(
                'कुल बिक्री',
                'सबै बिक्री गरिएका वस्तुहरूको कुल रकम',
                LucideIcons.shoppingBag,
              ),
              ..._buildHelpItem(
                'कुल खरिद',
                'सबै खरिद गरिएका वस्तुहरूको कुल रकम',
                LucideIcons.shoppingCart,
              ),
              ..._buildHelpItem(
                'कुल खर्च',
                'दैनिक खर्चहरूको कुल रकम (बिजुली, पानी, आदि)',
                LucideIcons.receipt,
              ),
              ..._buildHelpItem(
                'प्रतिशत',
                'प्रत्येक श्रेणीको कुल रकममा योगदान',
                LucideIcons.percent,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    backgroundColor: const Color(0xFFEBF8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'बुझें',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF3182CE),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHelpItem(String title, String description, IconData icon) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ];
  }
}
