// date_selector_controller.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
// date_selector_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DateSelectorController extends GetxController {
  final dateController = TextEditingController();
  final selectedDate = Rx<NepaliDateTime>(NepaliDateTime.now());
  final selectedMonthYear = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _updateDateDisplay();
  }

  void _updateDateDisplay() {
    // Update the date display in yyyy-mm-dd format
    dateController.text = '${selectedDate.value.year}-'
        '${selectedDate.value.month.toString().padLeft(2, '0')}-'
        '${selectedDate.value.day.toString().padLeft(2, '0')}';

    // Update month-year in yyyy-mm format
    selectedMonthYear.value = '${selectedDate.value.year}-'
        '${selectedDate.value.month.toString().padLeft(2, '0')}';
  }

  Future<void> pickDate() async {
    final NepaliDateTime? picked = await showMaterialDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: NepaliDateTime(2070),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      _updateDateDisplay();
    }
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select date';
    }
    return null;
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}

class DateSelectorWidget extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool showBorder;
  final bool showCard;

  DateSelectorWidget({
    Key? key,
    this.label,
    this.hint,
    this.showBorder = true,
    this.showCard = true,
  }) : super(key: key);
  final DateSelectorController controller = Get.put(DateSelectorController());
  @override
  Widget build(BuildContext context) {
    Widget dateField = CustomInputField(
      hint: hint ?? 'मिति छान्नुहोस्',
      controller: controller.dateController,
      validator: controller.validateDate,
      prefix: Icon(LucideIcons.calendar, color: AppColors.primaryColor),
      onTap: () => controller.pickDate(),
      readOnly: true,
      label: label ?? 'Select Date',
    );

    if (!showCard) return dateField;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: showBorder ? Border.all(color: AppColors.dividerColor) : null,
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateField,
        ],
      ),
    );
  }
}
