import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GrowthCard extends StatelessWidget {
  const GrowthCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActiveBatchStreamController>();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Map<String, dynamic>>(
          stream: controller.weightGainStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: SizedBox.shrink());
            }

            final data = snapshot.data!;
            final totalWeightGain =
                data['totalWeightGain']?.toStringAsFixed(2) ?? '0.00';
            final dailyAverageGain =
                data['dailyAverageGain']?.toStringAsFixed(2) ?? '0.00';
            final thisWeekWeight =
                data['thisWeekWeight'] as List<Map<String, dynamic>>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GrowthMetricTile(
                        nepaliLabel: 'कुल तौल वृद्धि',
                        englishLabel: 'Total Weight Gain',
                        value: totalWeightGain,
                        unit: 'kg',
                        trend: '+0.5%', // Placeholder for trend calculation
                        isPositive: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GrowthMetricTile(
                        nepaliLabel: 'दैनिक औसत वृद्धि',
                        englishLabel: 'Daily Average Gain',
                        value: dailyAverageGain,
                        unit: 'kg',
                        trend: 'Normal', // Placeholder for trend calculation
                        isPositive: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildWeeklyChart(thisWeekWeight),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.monitor_weight_outlined,
                color: Color(0xFF38A169),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'वृद्धि स्थिति',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Growth Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_horiz,
            color: Color(0xFF718096),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'history', child: Text('View History')),
            const PopupMenuItem(value: 'export', child: Text('Export Data')),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(List<Map<String, dynamic>> weekData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 243, 243),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Weekly Growth Trend',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                7,
                (index) => _buildDynamicBar(index, weekData),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicBar(int index, List<Map<String, dynamic>> weekData) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    // Find the weight for the current index
    final dayData = weekData[index];
    final weight = dayData['weight'] as double;

    // Normalize weight for bar height (assuming max height is 80)
    final maxWeight = weekData
        .map((e) => e['weight'] as double)
        .reduce((a, b) => a > b ? a : b);
    final normalizedHeight = maxWeight > 0 ? (weight / maxWeight) * 80 : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 4.w,
          height: normalizedHeight,
          decoration: BoxDecoration(
            color: weight > 0
                ? const Color(0xFF38A169).withOpacity(0.7)
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          // DateTime.parse(dayData['date']).day.toString().padLeft(2, '0'),
          days[index],
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

class GrowthMetricTile extends StatelessWidget {
  final String nepaliLabel;
  final String englishLabel;
  final String value;
  final String unit;
  final String trend;
  final bool isPositive;

  const GrowthMetricTile({
    Key? key,
    required this.nepaliLabel,
    required this.englishLabel,
    required this.value,
    required this.unit,
    required this.trend,
    required this.isPositive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nepaliLabel,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 63, 63, 63),
            ),
          ),
          Text(
            englishLabel,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 56, 56, 56),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? const Color(0xFFF0FFF4)
                  : const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: isPositive
                      ? const Color(0xFF38A169)
                      : const Color(0xFFE53E3E),
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isPositive
                        ? const Color(0xFF38A169)
                        : const Color(0xFFE53E3E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
