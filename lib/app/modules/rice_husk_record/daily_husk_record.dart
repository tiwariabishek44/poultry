import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RiceHuskDailyRecords extends StatefulWidget {
  @override
  State<RiceHuskDailyRecords> createState() => _RiceHuskDailyRecordsState();
}

class _RiceHuskDailyRecordsState extends State<RiceHuskDailyRecords> {
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

      if (controller.riceHusks.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.sprout,
        );
      }

      // Sort by date in descending order
      final sortedHusks = controller.riceHusks.toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: sortedHusks.length,
        itemBuilder: (context, index) {
          final husk = sortedHusks[index];
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
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Date
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                LucideIcons.sprout,
                                color: AppColors.primaryColor,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              husk.date,
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bags Count
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${numberFormat.format(husk.totalBags)} bags',
                          style: GoogleFonts.lato(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Notes (if any)
                  if (husk.notes != null && husk.notes!.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      husk.notes!,
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
