import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:get/get.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';

class SummaryTab extends StatelessWidget {
  SummaryTab({Key? key}) : super(key: key);

  final controller = Get.find<MonthlyReportController>();
  final filterController = Get.find<FilterController>();

  String formatEggCount(int totalEggs) {
    final crates = totalEggs ~/ 30;
    final pieces = totalEggs % 30;
    return '$crates crates + $pieces pcs';
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

      final collections = controller.collections;
      if (collections.isEmpty) {
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
            _buildSummaryOverview(collections),
            _buildGradeDistribution(collections),
            _buildQualityMetrics(collections),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryOverview(List<EggCollectionResponseModel> collections) {
    // Calculate total eggs
    final totalEggs = collections.fold(
        0, (sum, collection) => sum + collection.getTotalEggs());

    // Calculate daily average
    final averageEggs = totalEggs ~/ collections.length;

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
            'Summary  ( ${NepaliDateFormat('MM-yyyy').format(filterController.selectedDate.value)})',
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
                'Total Collection',
                formatEggCount(totalEggs),
                '',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.shade200,
              ),
              _buildOverviewItem(
                'Daily Average',
                formatEggCount(averageEggs),
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
              color: const Color.fromARGB(255, 30, 30, 30),
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
          if (subtitle.isNotEmpty)
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

  Widget _buildGradeDistribution(List<EggCollectionResponseModel> collections) {
    // Calculate totals for each grade
    final totalLargePlus = collections.fold(
        0, (sum, collection) => sum + collection.totalLargePlusEggs);
    final totalLarge = collections.fold(
        0, (sum, collection) => sum + collection.totalLargeEggs);
    final totalMedium = collections.fold(
        0, (sum, collection) => sum + collection.totalMediumEggs);
    final totalSmall = collections.fold(
        0, (sum, collection) => sum + collection.totalSmallEggs);

    final totalGoodEggs =
        totalLargePlus + totalLarge + totalMedium + totalSmall;

    // Calculate percentages
    final largePlusPercentage = (totalLargePlus / totalGoodEggs) * 100;
    final largePercentage = (totalLarge / totalGoodEggs) * 100;
    final mediumPercentage = (totalMedium / totalGoodEggs) * 100;
    final smallPercentage = (totalSmall / totalGoodEggs) * 100;

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
            'Grade Distribution',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildGradeItem('Large Plus (ठूलो प्लस)', largePlusPercentage,
              formatEggCount(totalLargePlus)),
          SizedBox(height: 12),
          _buildGradeItem(
              'Large (ठूलो)', largePercentage, formatEggCount(totalLarge)),
          SizedBox(height: 12),
          _buildGradeItem(
              'Medium (मध्यम)', mediumPercentage, formatEggCount(totalMedium)),
          SizedBox(height: 12),
          _buildGradeItem(
              'Small (सानो)', smallPercentage, formatEggCount(totalSmall)),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String grade, double percentage, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              grade,
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

  Widget _buildQualityMetrics(List<EggCollectionResponseModel> collections) {
    // Calculate totals
    final totalEggs = collections.fold(
        0, (sum, collection) => sum + collection.getTotalEggs());
    final totalCrack = collections.fold(
        0, (sum, collection) => sum + collection.totalCrackEggs);
    final totalWaste = collections.fold(
        0, (sum, collection) => sum + collection.totalWasteEggs);

    // Calculate percentages
    final crackPercentage = (totalCrack / totalEggs) * 100;
    final wastePercentage = (totalWaste / totalEggs) * 100;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            'Quality Metrics',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildQualityItem('Crack Eggs (चुकेको)', crackPercentage,
              formatEggCount(totalCrack)),
          SizedBox(height: 12),
          _buildQualityItem('Waste Eggs (खेर गएको)', wastePercentage,
              formatEggCount(totalWaste)),
        ],
      ),
    );
  }

  Widget _buildQualityItem(String type, double percentage, String amount) {
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
            color: Colors.red[400],
          ),
        ),
      ],
    );
  }

  // Widget _buildProductionEfficiency() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: const Color.fromARGB(255, 154, 154, 154)),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Production Efficiency',
  //           style: TextStyle(
  //             fontSize: 18.sp,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         _buildEfficiencyItem('Laying Rate', '93%'),
  //         const SizedBox(height: 12),
  //         _buildEfficiencyItem('Peak Production', '150 Crates'),
  //         const SizedBox(height: 12),
  //         _buildEfficiencyItem('Average Weight', '58 gm/egg'),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildEfficiencyItem(String label, String value) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 16.sp,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           fontSize: 16.sp,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
