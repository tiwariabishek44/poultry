import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NepaliDateController extends GetxController {
  final selectedYear = NepaliDateTime.now().year.obs;
  final selectedMonth = NepaliDateTime.now().month.obs;
  final selectedMonthName = ''.obs;
  final yearMonthString = ''.obs;

  // List of years and months
  final nepaliMonths = [
    'Baishakh',
    'Jestha',
    'Ashadh',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra'
  ];

  late final List<int> nepaliYears;

  NepaliDateController() {
    // Generate 5 years (2 past, current, 2 future)
    final currentYear = NepaliDateTime.now().year;
    nepaliYears = List.generate(5, (index) => currentYear - 2 + index);

    // Initialize with current date
    updateSelection(NepaliDateTime.now().year, NepaliDateTime.now().month);
  }

  void updateSelection(int year, int month) {
    selectedYear.value = year;
    selectedMonth.value = month;
    selectedMonthName.value = nepaliMonths[month - 1];
    yearMonthString.value = '$year-${month.toString().padLeft(2, '0')}';
  }

  String getFormattedDate() {
    return '${selectedYear.value}-${nepaliMonths[selectedMonth.value - 1]}';
  }
}

// widgets/nepali_month_year_picker.dart
class NepaliMonthYearPickers extends StatelessWidget {
  final Function(String) onDateSelected;
  final NepaliDateTime? initialDate;

  NepaliMonthYearPickers({
    Key? key,
    required this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  final controller = Get.put(NepaliDateController());

  void _showMonthYearBottomSheet() {
    int tempMonth = controller.selectedMonth.value;
    int tempYear = controller.selectedYear.value;

    Get.bottomSheet(
      Container(
        height: 90.h,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Month and Year',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.x, color: AppColors.textSecondary),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Month Selection
            Text(
              'Choose Month',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: List.generate(controller.nepaliMonths.length, (index) {
                return ChoiceChip(
                  label: Text(controller.nepaliMonths[index]),
                  selected: tempMonth == index + 1,
                  onSelected: (bool selected) {
                    if (selected) tempMonth = index + 1;
                  },
                  selectedColor: AppColors.primaryColor,
                  backgroundColor: AppColors.surfaceColor,
                  labelStyle: GoogleFonts.notoSansDevanagari(
                    color: tempMonth == index + 1
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                );
              }),
            ),

            SizedBox(height: 3.h),

            // Year Selection
            Text(
              'Choose Year',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: controller.nepaliYears.map((year) {
                return ChoiceChip(
                  label: Text(year.toString()),
                  selected: tempYear == year,
                  onSelected: (bool selected) {
                    if (selected) tempYear = year;
                  },
                  selectedColor: AppColors.primaryColor,
                  backgroundColor: AppColors.surfaceColor,
                  labelStyle: GoogleFonts.notoSansDevanagari(
                    color:
                        tempYear == year ? Colors.white : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),

            Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateSelection(tempYear, tempMonth);
                  onDateSelected(controller.yearMonthString.value);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: _showMonthYearBottomSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.calendar,
                  color: AppColors.primaryColor,
                  size: 18.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  controller.getFormattedDate(),
                  style: GoogleFonts.notoSansDevanagari(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
