// lib/app/widgets/metrics_carousel.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MetricsCarousel extends StatelessWidget {
  MetricsCarousel({
    Key? key,
    required this.thisMonthSales,
    required this.thisMonthPurchase,
    required this.amountToReceive,
    required this.amountToPay,
    this.backgroundColor = Colors.white,
    this.primaryColor = const Color(0xFF1976D2),
  }) : super(key: key);

  final double thisMonthSales;
  final double thisMonthPurchase;
  final double amountToReceive;
  final double amountToPay;
  final Color backgroundColor;
  final Color primaryColor;

  final _currentPage = 0.obs;
  final _currencyFormat = NumberFormat('#,##,###');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            height: 155,
            child: PageView(
              onPageChanged: (index) => _currentPage.value = index,
              children: [
                _buildMetricCard(
                  'Sales This Month',
                  thisMonthSales,
                  LucideIcons.trendingUp,
                  const Color(0xFFF3F8FF),
                  Colors.blue.shade700,
                  '+2.4% vs last month',
                ),
                _buildMetricCard(
                  'Purchase This Month',
                  thisMonthPurchase,
                  LucideIcons.shoppingCart,
                  const Color(0xFFF6FFF8),
                  Colors.green.shade700,
                  '-3.2% vs last month',
                ),
                _buildMetricCard(
                  'To Receive',
                  amountToReceive,
                  LucideIcons.wallet,
                  const Color(0xFFFFF8F3),
                  Colors.orange.shade700,
                  'From 12 parties',
                ),
                _buildMetricCard(
                  'To Pay',
                  amountToPay,
                  LucideIcons.creditCard,
                  const Color(0xFFFFF3F3),
                  Colors.red.shade700,
                  'To 8 parties',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Enhanced page indicator
          SizedBox(
            height: 4,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _currentPage.value == index ? 20 : 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: _currentPage.value == index
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    double amount,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
    String statusText,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and label
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Amount
            Text(
              'Rs ${_currencyFormat.format(amount)}',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            // Status text
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
