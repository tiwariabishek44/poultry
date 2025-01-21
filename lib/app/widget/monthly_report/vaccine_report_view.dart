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

class VaccineReportView extends StatefulWidget {
  @override
  State<VaccineReportView> createState() => _VaccineReportViewState();
}

class _VaccineReportViewState extends State<VaccineReportView> {
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
    controller.fetchVaccines();
  }

  int _getTotalVaccines() {
    return controller.vaccines.length;
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

      if (controller.vaccines.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message:
              'Batch: $selectedBatchName\nDate: $selectedMonth-$selectedYear',
          icon: LucideIcons.syringe,
        );
      }

      final totalVaccines = _getTotalVaccines();

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
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
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
                Text(
                  'Total Vaccinations: $totalVaccines',
                  style: GoogleFonts.notoSansDevanagari(
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
              itemCount: controller.vaccines.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final vaccine = controller.vaccines[index];
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
                                  LucideIcons.syringe,
                                  color: AppColors.primaryColor,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                vaccine.vaccineName,
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Text(
                        vaccine.vaccineDate,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16.sp,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                      if (vaccine.notes != null &&
                          vaccine.notes!.isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        Text(
                          vaccine.notes!,
                          style: GoogleFonts.notoSansDevanagari(
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
