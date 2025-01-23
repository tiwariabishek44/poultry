// feed_consumption_summary.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedConsumptionSummary extends StatelessWidget {
  FeedConsumptionSummary({Key? key}) : super(key: key);

  final controller = Get.find<MonthlyReportController>();
  final filterController = Get.find<FilterController>();
  final numberFormat = NumberFormat('#,##,###.#');

  String formatFeedAmount(double amount) {
    return '${numberFormat.format(amount)} kg';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.error.value != null) {
        return Center(child: Text('Error: ${controller.error.value}'));
      }

      if (controller.feedConsumptions.isEmpty) {
        return Center(
          child: Text(
            'No data available for this period',
            style: TextStyle(fontSize: 16.sp),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            _buildMonthlyOverview(),
            _buildFeedTypeBreakdown(),
          ],
        ),
      );
    });
  }

  Widget _buildMonthlyOverview() {
    // Calculate total feed used
    final double totalFeed = controller.feedConsumptions
        .fold<double>(0.0, (sum, item) => sum + item.quantityKg.toDouble());

    // Calculate daily average
    final int daysInPeriod = controller.feedConsumptions.length;
    final double dailyAverage =
        daysInPeriod > 0 ? totalFeed / daysInPeriod : 0.0;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 170, 170, 170)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary  (${NepaliDateFormat('MMMM yyyy').format(filterController.selectedDate.value)})',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOverviewItem(
                'Total Feed',
                formatFeedAmount(totalFeed),
                '',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.shade200,
              ),
              _buildOverviewItem(
                'Daily Average',
                formatFeedAmount(dailyAverage),
                '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String title, String value, String subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color.fromARGB(255, 26, 24, 24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTypeBreakdown() {
    // Group consumptions by feed type
    final feedTypeMap = <String, double>{};
    double totalFeed = 0.0;

    for (var consumption in controller.feedConsumptions) {
      feedTypeMap[consumption.feedType] =
          (feedTypeMap[consumption.feedType] ?? 0.0) +
              consumption.quantityKg.toDouble();
      totalFeed += consumption.quantityKg.toDouble();
    }

    // Sort feed types alphabetically
    final sortedEntries = feedTypeMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 154, 154, 154)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feed Type Distribution',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...sortedEntries.map((entry) {
            final double percentage = (entry.value / totalFeed) * 100;
            return Column(
              children: [
                _buildFeedTypeItem(
                    entry.key, percentage, formatFeedAmount(entry.value)),
                SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFeedTypeItem(String type, double percentage, String amount) {
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
                color: Colors.black87,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            minHeight: 8,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
