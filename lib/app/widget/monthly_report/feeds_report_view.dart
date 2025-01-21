import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedsReportView extends StatefulWidget {
  @override
  State<FeedsReportView> createState() => _FeedsReportViewState();
}

class _FeedsReportViewState extends State<FeedsReportView> {
  final controller = Get.put(MonthlyReportController());
  final filterController = Get.put(FilterController());
  final numberFormat = NumberFormat('#,##,##0.0');

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    _fetchData();

    // Listen to filter changes
    ever(filterController.finalDate, (_) => _fetchData());
    ever(filterController.selectedBatchId, (_) => _fetchData());
  }

  void _fetchData() {
    controller.fetchFeedConsumptions();
  }

  // Calculate totals for each feed type
  Map<String, double> _getFeedTypeTotals() {
    Map<String, double> totals = {
      'L0': 0.0,
      'L1': 0.0,
      'L2': 0.0,
      'PL': 0.0,
      'L3': 0.0,
    };

    for (var consumption in controller.feedConsumptions) {
      if (totals.containsKey(consumption.feedType)) {
        totals[consumption.feedType] =
            (totals[consumption.feedType] ?? 0) + consumption.quantityKg;
      }
    }

    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show selected filters info
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

      if (controller.feedConsumptions.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.wheat,
        );
      }

      final feedTypeTotals = _getFeedTypeTotals();
      final totalConsumption =
          feedTypeTotals.values.fold(0.0, (sum, qty) => sum + qty);

      return ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          // Month and Total Summary

          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MM-yyyy')
                      .format(filterController.selectedDate.value),
                  style: GoogleFonts.lato(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Batch: $selectedBatchName',
                  style: GoogleFonts.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Total : ${numberFormat.format(totalConsumption)} kg',
                  style: GoogleFonts.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Feed Types List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                ...feedTypeTotals.entries.map((entry) {
                  return Column(
                    children: [
                      _buildFeedTypeRow(entry.key, entry.value),
                      if (entry.key != feedTypeTotals.keys.last)
                        Divider(height: 1, color: Colors.grey[300]),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFeedTypeRow(String feedType, double quantity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ' $feedType',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${numberFormat.format(quantity)} kg',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
