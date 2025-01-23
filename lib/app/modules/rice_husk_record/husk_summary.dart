// rice_husk_summary.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RiceHuskSummary extends StatelessWidget {
  RiceHuskSummary({Key? key}) : super(key: key);

  final controller = Get.find<MonthlyReportController>();
  final filterController = Get.find<FilterController>();
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

      if (controller.riceHusks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.sprout,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 2.h),
              Text(
                'No data available for this period',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            _buildMonthlyOverview(),
          ],
        ),
      );
    });
  }

  Widget _buildMonthlyOverview() {
    // Calculate total bags used
    final totalBags =
        controller.riceHusks.fold<int>(0, (sum, husk) => sum + husk.totalBags);

    // Calculate daily average
    final daysInPeriod = controller.riceHusks.length;
    final double dailyAverage =
        daysInPeriod > 0 ? totalBags / daysInPeriod : 0.0;

    // Get batch name
    final selectedBatchName =
        filterController.selectedBatch.value?.batchName ?? 'All';

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      NepaliDateFormat('MMMM yyyy')
                          .format(filterController.selectedDate.value),
                      style: GoogleFonts.lato(
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

          // Statistics
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total ',
                    numberFormat.format(totalBags),
                    'बोरा',
                    LucideIcons.package,
                  ),
                ),
                Container(
                  height: 12.h,
                  width: 1,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: _buildStatCard(
                    'Daily Average',
                    numberFormat.format(dailyAverage),
                    'बोरा/day',
                    LucideIcons.calendarClock,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String subtitle, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            color: Color.fromARGB(255, 19, 19, 19),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15.sp,
            color: const Color.fromARGB(255, 28, 27, 27),
          ),
        ),
      ],
    );
  }
}
