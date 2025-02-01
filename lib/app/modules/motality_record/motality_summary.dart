// Summary Tab Widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_report_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MortalitySummaryTab extends StatelessWidget {
  MortalitySummaryTab({Key? key}) : super(key: key);

  final controller = Get.find<BatchReportController>();
  final numberFormat = NumberFormat('#,##,##0');

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

      if (controller.mortalities.isEmpty) {
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
            _buildOverviewCard(),
            _buildCauseAnalysisCard(),
          ],
        ),
      );
    });
  }

  Widget _buildOverviewCard() {
    // Calculate total deaths
    final totalDeaths = controller.mortalities
        .fold<int>(0, (sum, mortality) => sum + mortality.deathCount);

    // // Calculate mortality rate (using total birds from the batch if available)
    // final totalBirds = filterController.selectedBatch.value?.totalBirds ?? 0;
    // final mortalityRate = totalBirds > 0
    //     ? (totalDeaths / totalBirds * 100)
    //     : 0.0;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary ',
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
                'Total Deaths',
                numberFormat.format(totalDeaths),
                'Birds',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.shade200,
              ),
              _buildOverviewItem(
                'Mortality Rate',
                ' 20 %',
                'of total flock',
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
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCauseAnalysisCard() {
    // Group deaths by cause
    final causesMap = <String, int>{};
    int totalDeaths = 0;

    for (var mortality in controller.mortalities) {
      causesMap[mortality.cause] =
          (causesMap[mortality.cause] ?? 0) + mortality.deathCount;
      totalDeaths += mortality.deathCount;
    }

    // Convert to list and sort by death count
    final causesList = causesMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cause Analysis',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...causesList.map((cause) {
            final percentage =
                totalDeaths > 0 ? (cause.value / totalDeaths * 100) : 0.0;

            return Column(
              children: [
                _buildCauseItem(
                  cause.key,
                  percentage,
                  '${percentage.toStringAsFixed(1)}%',
                ),
                SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCauseItem(
      String cause, double percentage, String displayPercentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cause,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            Text(
              displayPercentage,
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
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}
