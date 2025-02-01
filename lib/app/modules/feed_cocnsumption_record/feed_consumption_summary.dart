import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_report_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedConsumptionSummary extends StatelessWidget {
  FeedConsumptionSummary({Key? key}) : super(key: key);

  final controller = Get.find<BatchReportController>();
  final numberFormat = NumberFormat('#,##,###.##');

  String formatFeedAmount(double amount) {
    return '${numberFormat.format(amount)} kg';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.error.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(
                'Error: ${controller.error.value}',
                style: TextStyle(fontSize: 16.sp, color: Colors.red[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      if (controller.feedConsumptions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.no_food_outlined, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No feed data available for this period',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () {
          return controller.fetchFeedConsumptions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildTotalFeedCard(),
              _buildFeedTypeDistribution(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTotalFeedCard() {
    final totalFeed = controller.feedConsumptions
        .fold<double>(0.0, (sum, item) => sum + item.quantityKg.toDouble());

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'कुल दाना प्रयोग',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Total Feed Used',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  formatFeedAmount(totalFeed),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTypeDistribution() {
    final feedTypeMap = <String, double>{};
    double totalFeed = 0.0;

    for (var consumption in controller.feedConsumptions) {
      feedTypeMap[consumption.feedType] =
          (feedTypeMap[consumption.feedType] ?? 0.0) +
              consumption.quantityKg.toDouble();
      totalFeed += consumption.quantityKg.toDouble();
    }

    final sortedEntries = feedTypeMap.entries.toList()
      ..sort(
          (a, b) => b.value.compareTo(a.value)); // Sort by quantity descending

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.pie_chart_outline,
                    color: Colors.green[700],
                    size: 20.sp,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'दाना वितरण',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Feed Distribution',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...sortedEntries.map((entry) {
              final percentage = (entry.value / totalFeed) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildFeedTypeProgressBar(
                  entry.key,
                  percentage,
                  formatFeedAmount(entry.value),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTypeProgressBar(
      String type, double percentage, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                minHeight: 12,
                color: AppColors.primaryColor,
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: percentage > 50 ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
