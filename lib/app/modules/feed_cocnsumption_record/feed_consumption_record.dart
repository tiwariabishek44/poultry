import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/feed_cocnsumption_record/feed_consumption_record_controller.dart';
import 'package:poultry/app/widget/feed_shimmer.dart';
import 'package:poultry/appss/widget/nepai_year_month_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// feed_consumption_list_page.dart
class FeedConsumptionListPage extends StatelessWidget {
  FeedConsumptionListPage({Key? key}) : super(key: key);

  final controller = Get.put(FeedConsumptionListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feed Consumption History',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Month Year Picker
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            color: AppColors.surfaceColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Month:',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                NepaliMonthYearPicker(
                  onDateSelected: (yearMonth) {
                    controller.fetchFeedConsumptions(yearMonth);
                  },
                ),
              ],
            ),
          ),

          // Feed Consumption List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return FeedShimmer();
              }

              if (controller.feedConsumptions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.packageX,
                        size: 40.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No feed consumption records found',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(3.w),
                itemCount: controller.feedConsumptions.length,
                itemBuilder: (context, index) {
                  final consumption = controller.feedConsumptions[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 2.h),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  consumption.feedType,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                '${consumption.quantityKg} KG',
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 16.sp,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                consumption.consumptionDate,
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.tag,
                                size: 16.sp,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Batch: ${consumption.batchId}',
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
