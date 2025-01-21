import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MortalityReportView extends StatefulWidget {
  @override
  State<MortalityReportView> createState() => _MortalityReportViewState();
}

class _MortalityReportViewState extends State<MortalityReportView> {
  final controller = Get.put(MonthlyReportController());
  final filterController = Get.put(FilterController());
  final numberFormat = NumberFormat('#,##,##0.0');

  @override
  void initState() {
    super.initState();
    _fetchData();
    ever(filterController.finalDate, (_) => _fetchData());
    ever(filterController.selectedBatchId, (_) => _fetchData());
  }

  void _fetchData() {
    controller.fetchMortalities();
  }

  Map<String, DeathSummary> _getDeathSummaries() {
    Map<String, DeathSummary> summaries = {};

    for (var death in controller.mortalities) {
      if (!summaries.containsKey(death.cause)) {
        summaries[death.cause] = DeathSummary();
      }
      summaries[death.cause]!.totalDeaths += death.deathCount;

      // Store the latest date for this cause
      if (summaries[death.cause]!.lastDate == null ||
          death.date.compareTo(summaries[death.cause]!.lastDate!) > 0) {
        summaries[death.cause]!.lastDate = death.date;
      }

      // Collect any notes
      if (death.notes != null && death.notes!.isNotEmpty) {
        summaries[death.cause]!.notes.add(death.notes!);
      }
    }

    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedBatchName =
          filterController.selectedBatch.value?.batchName ?? 'All Batches';
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
          title: 'No mortality records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.alertCircle,
        );
      }

      final deathSummaries = _getDeathSummaries();
      final totalDeaths = deathSummaries.values
          .fold(0, (sum, summary) => sum + summary.totalDeaths);

      return ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          // Summary Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MM-yyyy')
                        .format(filterController.selectedDate.value),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Batch: $selectedBatchName',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          color: AppColors.error,
                          size: 24.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${numberFormat.format(totalDeaths)} birds',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Cause-wise Details
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: deathSummaries.length,
            itemBuilder: (context, index) {
              final entry = deathSummaries.entries.elementAt(index);
              return _buildCauseCard(
                cause: entry.key,
                summary: entry.value,
                totalDeaths: totalDeaths,
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildCauseCard({
    required String cause,
    required DeathSummary summary,
    required int totalDeaths,
  }) {
    final percentage =
        (summary.totalDeaths / totalDeaths * 100).toStringAsFixed(1);

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 2.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.error.withOpacity(0.05),
              AppColors.error.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    cause,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${numberFormat.format(summary.totalDeaths)} birds',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: summary.totalDeaths / totalDeaths,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.error.withOpacity(0.7)),
                minHeight: 0.8.h,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '$percentage% of total deaths',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeathSummary {
  int totalDeaths = 0;
  String? lastDate;
  List<String> notes = [];
}
