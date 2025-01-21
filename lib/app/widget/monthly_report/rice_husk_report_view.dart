import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RiceHuskReportView extends StatefulWidget {
  @override
  State<RiceHuskReportView> createState() => _RiceHuskReportViewState();
}

class _RiceHuskReportViewState extends State<RiceHuskReportView> {
  final controller = Get.put(MonthlyReportController());
  final filterController = Get.put(FilterController());
  final numberFormat = NumberFormat('#,##,##0');

  @override
  void initState() {
    super.initState();
    _fetchData();
    ever(filterController.finalDate, (_) => _fetchData());
    ever(filterController.selectedBatchId, (_) => _fetchData());
  }

  void _fetchData() {
    controller.fetchRiceHusks();
  }

  int _getTotalBags() {
    return controller.riceHusks.fold(0, (sum, husk) => sum + husk.totalBags);
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

      if (controller.riceHusks.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.sprout,
        );
      }

      final totalBags = _getTotalBags();

      return ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          // Summary Card
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
                  'Total: ${numberFormat.format(totalBags)} bags',
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

          // Records List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.riceHusks.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final husk = controller.riceHusks[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  LucideIcons.sprout,
                                  color: AppColors.primaryColor,
                                  size: 20.sp,
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
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
