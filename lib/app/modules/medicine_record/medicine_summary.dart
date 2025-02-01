// mataerial import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_report_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// medication_summary.dart
class MedicationSummary extends StatelessWidget {
  MedicationSummary({Key? key}) : super(key: key);

  final controller = Get.find<BatchReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.error.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(
                'Error: ${controller.error.value}',
                style: TextStyle(fontSize: 16.sp, color: Colors.red[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      if (controller.medications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medical_services_outlined,
                  size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No medication records found',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchMedications(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildTotalMedicationsCard(),
              _buildMedicineDistribution(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTotalMedicationsCard() {
    final totalMedications = controller.medications.length;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services_outlined,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'कुल औषधि प्रयोग',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Total Medications Used',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              totalMedications.toString(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineDistribution() {
    final medicineTypeMap = <String, int>{};

    for (var medication in controller.medications) {
      medicineTypeMap[medication.medicineName] =
          (medicineTypeMap[medication.medicineName] ?? 0) + 1;
    }

    final sortedEntries = medicineTypeMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.pie_chart_outline,
                    color: Colors.green[700],
                    size: 20.sp,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'औषधि वितरण',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Medicine Distribution',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...sortedEntries.map((entry) {
              final percentage =
                  (entry.value / controller.medications.length) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMedicineTypeBar(
                  entry.key,
                  percentage,
                  entry.value,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineTypeBar(String type, double percentage, int count) {
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
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                minHeight: 12,
                color: AppColors.primaryColor,
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: percentage > 50 ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
