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

class EggReportView extends StatefulWidget {
  @override
  State<EggReportView> createState() => _EggReportViewState();
}

class _EggReportViewState extends State<EggReportView> {
  final controller = Get.put(MonthlyReportController());
  final filterController = Get.put(FilterController());

  @override
  void initState() {
    super.initState();
    _fetchData();
    ever(filterController.finalDate, (_) => _fetchData());
    ever(filterController.selectedBatchId, (_) => _fetchData());
  }

  void _fetchData() {
    controller.fetchEggCollections();
  }

  Map<String, CategoryTotal> _getCategoryTotals() {
    Map<String, CategoryTotal> totals = {
      'Large Plus': CategoryTotal(),
      'Large': CategoryTotal(),
      'Medium': CategoryTotal(),
      'Small': CategoryTotal(),
      'Crack': CategoryTotal(),
      'Waste': CategoryTotal(),
    };

    for (var collection in controller.collections) {
      // Add Large Plus eggs
      totals['Large Plus']!.totalEggs += collection.totalLargePlusEggs;
      // Add Large eggs
      totals['Large']!.totalEggs += collection.totalLargeEggs;
      // Add Medium eggs
      totals['Medium']!.totalEggs += collection.totalMediumEggs;
      // Add Small eggs
      totals['Small']!.totalEggs += collection.totalSmallEggs;
      // Add Crack eggs
      totals['Crack']!.totalEggs += collection.totalCrackEggs;
      // Add Waste eggs
      totals['Waste']!.totalEggs += collection.totalWasteEggs;
    }

    totals.forEach((key, value) {
      value.calculateCratesAndRemaining();
    });

    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedBatchName =
          filterController.selectedBatch.value?.batchName ?? 'All  ';
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

      final categoryTotals = _getCategoryTotals();
      final totalEggs = categoryTotals.values
          .fold(0, (sum, category) => sum + category.totalEggs);
      final totalCrates = totalEggs ~/ 30;
      final totalRemaining = totalEggs % 30;

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
                  'Total: ${totalCrates} crates + ${totalRemaining} pcs',
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

          // Categories List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildCategoryRow('Large Plus', categoryTotals['Large Plus']!),
                _buildDivider(),
                _buildCategoryRow('Large', categoryTotals['Large']!),
                _buildDivider(),
                _buildCategoryRow('Medium', categoryTotals['Medium']!),
                _buildDivider(),
                _buildCategoryRow('Small', categoryTotals['Small']!),
                _buildDivider(),
                _buildCategoryRow('Crack', categoryTotals['Crack']!),
                _buildDivider(),
                _buildCategoryRow('Waste', categoryTotals['Waste']!),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCategoryRow(String name, CategoryTotal total) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${total.crates}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                TextSpan(
                  text: ' crates ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: ' + ${total.remaining}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                TextSpan(
                  text: ' pcs',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300]);
  }
}

class CategoryTotal {
  int totalEggs = 0;
  int crates = 0;
  int remaining = 0;

  void calculateCratesAndRemaining() {
    crates = totalEggs ~/ 30;
    remaining = totalEggs % 30;
  }
}
