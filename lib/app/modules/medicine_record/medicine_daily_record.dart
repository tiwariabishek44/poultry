// import material

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_report_controller.dart';
import 'package:poultry/app/repository/medicine_repository.dart';
import 'package:poultry/app/widget/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// medication_daily_records.dart
class MedicationDailyRecords extends StatefulWidget {
  @override
  State<MedicationDailyRecords> createState() => _MedicationDailyRecordsState();
}

class _MedicationDailyRecordsState extends State<MedicationDailyRecords> {
  final controller = Get.find<BatchReportController>();

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

      if (controller.medications.isEmpty) {
        return EmptyStateWidget(
          title: 'No records found',
          message: 'No medication records available',
          icon: Icons.medical_services_outlined,
        );
      }

      final sortedMedications = controller.medications.toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: sortedMedications.length,
        itemBuilder: (context, index) {
          final medication = sortedMedications[index];
          return _buildMedicationRow(medication);
        },
      );
    });
  }

  Widget _buildMedicationRow(FlockMedicationResponseModel medication) {
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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date
            Text(
              NepaliDateFormat('dd MMM yyyy')
                  .format(NepaliDateTime.parse(medication.date)),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            // Medicine Name
            Text(
              medication.medicineName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
