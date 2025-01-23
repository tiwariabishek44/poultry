import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EggCollectionDailyRecords extends StatefulWidget {
  @override
  State<EggCollectionDailyRecords> createState() =>
      _EggCollectionDailyRecordsState();
}

class _EggCollectionDailyRecordsState extends State<EggCollectionDailyRecords> {
  final controller = Get.find<MonthlyReportController>();
  final filterController = Get.find<FilterController>();

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

      if (controller.collections.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.egg,
        );
      }

      // Sort collections by date in descending order (most recent first)
      final sortedCollections = controller.collections.toList()
        ..sort((a, b) => b.collectionDate.compareTo(a.collectionDate));

      return ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: sortedCollections.length,
        itemBuilder: (context, index) {
          final collection = sortedCollections[index];
          return _buildDailyRecordCard(collection);
        },
      );
    });
  }

  Widget _buildDailyRecordCard(EggCollectionResponseModel collection) {
    final totalEggs = collection.getTotalEggs();
    final totalCrates = totalEggs ~/ 30;
    final remainingEggs = totalEggs % 30;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              collection.collectionDate,
              style: GoogleFonts.lato(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${totalCrates} crates + ${remainingEggs} pcs',
              style: GoogleFonts.lato(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
