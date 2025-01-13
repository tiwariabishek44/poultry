// death_cause_dropdown_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeathCauseDropdownController extends GetxController {
  static DeathCauseDropdownController get instance => Get.find();

  final selectedCause = ''.obs;

  // Predefined list of death causes
  final List<Map<String, String>> deathCauses = [
    {'value': 'disease', 'label': 'Disease (रोग)'},
    {'value': 'natural', 'label': 'Natural Death (प्राकृतिक मृत्यु)'},
    {'value': 'injury', 'label': 'Injury (चोटपटक)'},
    {'value': 'other', 'label': 'Other (अन्य)'},
  ];

  void setSelectedCause(String cause) {
    selectedCause.value = cause;
  }

  String? getSelectedCauseLabel() {
    final cause = deathCauses.firstWhereOrNull(
      (element) => element['value'] == selectedCause.value,
    );
    return cause?['label'];
  }

  void reset() {
    selectedCause.value = '';
  }
}

class DeathCauseDropdown extends StatelessWidget {
  final deathCauseController = Get.put(DeathCauseDropdownController());

  DeathCauseDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cause of Death (मृत्युको कारण)',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 17.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: deathCauseController.selectedCause.value.isEmpty
                      ? null
                      : deathCauseController.selectedCause.value,
                  hint: Text(
                    'Select cause of death',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 0,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                  items: deathCauseController.deathCauses
                      .map<DropdownMenuItem<String>>(
                          (Map<String, String> cause) {
                    return DropdownMenuItem<String>(
                      value: cause['value'],
                      child: Text(cause['label']!),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      deathCauseController.setSelectedCause(value);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
