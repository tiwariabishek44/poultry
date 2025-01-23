// feed_consumption_daily_records.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedConsumptionDailyRecords extends StatefulWidget {
  @override
  State<FeedConsumptionDailyRecords> createState() =>
      _FeedConsumptionDailyRecordsState();
}

class _FeedConsumptionDailyRecordsState
    extends State<FeedConsumptionDailyRecords> {
  final controller = Get.find<MonthlyReportController>();
  final filterController = Get.find<FilterController>();
  final numberFormat = NumberFormat('#,##,##0.0');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedBatchName =
          filterController.selectedBatch.value?.batchName ?? 'All';
      final selectedMonth = filterController.selectedDate.value.month;
      final selectedYear = filterController.selectedDate.value.year;

      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.error.value != null) {
        return Center(child: Text('Error: ${controller.error.value}'));
      }

      if (controller.feedConsumptions.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.wheat,
        );
      }

      // Sort collections by date in descending order (most recent first)
      final sortedConsumptions = controller.feedConsumptions.toList()
        ..sort((a, b) => b.consumptionDate.compareTo(a.consumptionDate));

      return ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: sortedConsumptions.length,
        itemBuilder: (context, index) {
          final consumption = sortedConsumptions[index];
          return _buildConsumptionRow(consumption);
        },
      );
    });
  }

  Widget _buildConsumptionRow(FeedConsumptionResponseModel consumption) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        child: Row(
          children: [
            // Date
            Expanded(
              flex: 3,
              child: Text(
                DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(consumption.consumptionDate)),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            // Feed Type
            Expanded(
              flex: 2,
              child: Text(
                consumption.feedType,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Quantity
            Expanded(
              flex: 2,
              child: Text(
                '${numberFormat.format(consumption.quantityKg)} kg',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
