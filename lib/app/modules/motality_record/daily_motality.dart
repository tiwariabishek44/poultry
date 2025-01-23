import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class MortalityDailyRecords extends StatefulWidget {
  @override
  State<MortalityDailyRecords> createState() => _MortalityDailyRecordsState();
}

class _MortalityDailyRecordsState extends State<MortalityDailyRecords> {
  final controller = Get.find<MonthlyReportController>();
  final filterController = Get.find<FilterController>();
  final numberFormat = NumberFormat('#,##,##0');

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

      if (controller.mortalities.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.alertCircle,
        );
      }

      // Sort by date in descending order
      final sortedMortalities = controller.mortalities.toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: sortedMortalities.length,
        itemBuilder: (context, index) {
          final mortality = sortedMortalities[index];
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Date
                      Expanded(
                        flex: 3,
                        child: Text(
                          mortality.date,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      // Death Count
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${numberFormat.format(mortality.deathCount)} birds',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Cause and Notes
                  Padding(
                    padding: EdgeInsets.only(top: 2.h, left: 1.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cause: ${mortality.cause}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (mortality.notes != null &&
                            mortality.notes!.isNotEmpty) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            mortality.notes!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
