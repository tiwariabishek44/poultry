// vaccine_schedule_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/vaccination_schedule_model.dart';
import 'package:poultry/app/modules/my_vaccine/my_vaccine.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VaccineSchedulePage extends StatelessWidget {
  VaccineSchedulePage({super.key});

  final vaccinationSchedule = VaccinationSchedule();

  @override
  Widget build(BuildContext context) {
    final sortedSchedule = _getSortedSchedule();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(LucideIcons.calendar, size: 18.sp),
            SizedBox(width: 2.w),
            Text(
              'खोप तालिका',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Top Summary Section
          _buildSummarySection(sortedSchedule.length),

          // Timeline View
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(5.w),
              itemCount: sortedSchedule.length,
              itemBuilder: (context, index) {
                final vaccine = sortedSchedule[index];
                return _buildVaccineTimelineItem(vaccine, index, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getSortedSchedule() {
    final sortedSchedule = [...vaccinationSchedule.schedule];
    sortedSchedule.sort((a, b) {
      String aAge = a.age.split("-")[0];
      String bAge = b.age.split("-")[0];
      try {
        int aDays =
            a.ageUnit == "हप्ता" ? int.parse(aAge) * 7 : int.parse(aAge);
        int bDays =
            b.ageUnit == "हप्ता" ? int.parse(bAge) * 7 : int.parse(bAge);
        return aDays.compareTo(bDays);
      } catch (e) {
        print("Error parsing age: ${a.age} or ${b.age}");
        return 0;
      }
    });
    return sortedSchedule;
  }

  Widget _buildSummarySection(int total) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'तपाईंको खोप तालिका सारांश  Total($total) Vaccines',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 1.h),
          Text(
            title,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 12.sp,
              color: color,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineTimelineItem(
      dynamic vaccine, int index, BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => MyVaccinePage(), arguments: {
        'vaccine': vaccine.vaccine,
        'disease': vaccine.disease,
        'method': vaccine.method,
        'age': vaccine.age,
        'ageUnit': vaccine.ageUnit,
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (index < vaccinationSchedule.schedule.length - 1)
                  Container(
                    width: 0.5.w,
                    height: 15.h,
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
              ],
            ),
            SizedBox(width: 4.w),
            // Vaccine card
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
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
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'सिफारिस गरिएको उमेर: ${vaccine.age} ${vaccine.ageUnit}',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (vaccine.required)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.alertTriangle,
                                  size: 16.sp,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'अनिवार्य',
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      vaccine.vaccine,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildInfoRow(
                      icon: LucideIcons.bug,
                      label: 'रोग:',
                      value: vaccine.disease,
                    ),
                    SizedBox(height: 1.h),
                    _buildInfoRow(
                      icon: LucideIcons.syringe,
                      label: 'विधि:',
                      value: vaccine.method,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
