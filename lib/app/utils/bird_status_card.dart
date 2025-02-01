import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_managemnt.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BirdStatusCard extends StatelessWidget {
  final BatchResponseModel batchData;
  const BirdStatusCard({Key? key, required this.batchData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnhancedTitle(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMainMetric(
                    'जीवित कुखुरा',
                    'Live Birds',
                    batchData.currentFlockCount.toString(),
                    '/${batchData.initialFlockCount}',
                    true,
                    const Color(0xFF3182CE),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMainMetric(
                    'मृत्यु',
                    'Mortality',
                    batchData.totalDeath.toString(),
                    '/ ${(batchData.totalDeath / batchData.initialFlockCount * 100)} %',
                    false,
                    const Color(0xFFE53E3E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF8FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.pets_outlined,
                color: Color(0xFF3182CE),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Batch:- ${batchData.batchName}",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  "Start : ${batchData.startingDate}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => BatchManagementPage(batch: batchData));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Details',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainMetric(
    String nepaliLabel,
    String englishLabel,
    String value,
    String suffix,
    bool showProgress,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: showProgress ? const Color(0xFFEBF8FF) : const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nepaliLabel,
            style: const TextStyle(
              fontFamily: 'NotoSansDevanagari',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3748),
            ),
          ),
          Text(
            englishLabel,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              Text(
                suffix,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
