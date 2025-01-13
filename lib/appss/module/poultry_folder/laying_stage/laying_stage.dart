import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/module/activity_folder/feed_consumption/feed_consumption_controller.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_deail_page.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_stage_controller.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/egg_collection_metrics.dart';
import 'package:poultry/appss/widget/age_widget.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LayingStageWidget extends StatelessWidget {
  final Map<String, dynamic> batch;

  LayingStageWidget({
    Key? key,
    required this.batch,
  }) : super(key: key);
  final feedAnalyticsController = Get.put(LayingStageController());
  final numberFormat = NumberFormat("#,##,###.0"); // Add this line
  final nepaliMonths = [
    'Baishak',
    'Jestha',
    'Asar',
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

  String getCurrentNepaliMonth() {
    final now = NepaliDateTime.now();
    return nepaliMonths[now.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = getCurrentNepaliMonth();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildQuickStats(currentMonth),
            _buildProductionMetrics(currentMonth),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 121, 167),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                batch['batchName'] ?? 'Batch Name',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEAB308),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAB308).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.egg,
                      size: 12,
                      color: Color(0xFFEAB308),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Laying Stage',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFEAB308),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AgeDisplayWidget(
            initialDate: (batch['initialDate'] as Timestamp?)?.toDate() ??
                DateTime.now(),
            currentDate: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(String currentMonth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _buildStatItem(
            icon: LucideIcons.bird,
            label: 'Initial',
            value: '${batch['quantity'] ?? '0,000'}',
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(width: 8),
          _buildStatItem(
            icon: LucideIcons.bird,
            label: 'Current',
            value: '${batch['currentQuantity'] ?? '00'}',
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 8),
          _buildProductionMetricCard(),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          // color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 26, 25, 25),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductionMetrics(String currentMonth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildFeedMetricCard(currentMonth),
              const SizedBox(width: 8),
              _buildMortalityMetricCard(currentMonth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    // Format the value
    String formattedValue = value;
    if (value != '...') {
      // Don't format loading indicator
      try {
        if (value.contains('kg')) {
          // Handle kg values
          final double numValue =
              double.parse(value.replaceAll('kg', '').trim());
          formattedValue = '${numberFormat.format(numValue)} kg';
        } else {
          // Handle regular numbers
          final double numValue = double.parse(value.replaceAll(',', ''));
          formattedValue = numberFormat.format(numValue);
        }
      } catch (e) {
        // Keep original value if parsing fails
        formattedValue = value;
      }
    }

    // Format the trend
    String formattedTrend = trend;
    if (trend.isNotEmpty && trend != '...') {
      try {
        if (trend.contains('%')) {
          final double numValue = double.parse(trend.replaceAll('%', ''));
          formattedTrend = '${numberFormat.format(numValue)}%';
        } else {
          final double numValue = double.parse(trend.replaceAll(',', ''));
          formattedTrend = numberFormat.format(numValue);
        }
      } catch (e) {
        // Keep original trend if parsing fails
        formattedTrend = trend;
      }
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: const Color.fromARGB(255, 110, 109, 109).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: Color.fromARGB(255, 26, 25, 25),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  formattedValue,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                Text(
                  formattedTrend,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isPositive ? Colors.green[600] : Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedMetricCard(String currentMonth) {
    return StreamBuilder<double>(
      stream: feedAnalyticsController.getFeedConsumptionStream(
          yearmonth: NepaliDateTime.now().toIso8601String().substring(0, 7),
          batch['batchId'],
          batch['stage'],
          monthFilter: true),
      builder: (context, snapshot) {
        String value;
        if (snapshot.hasError) {
          value = 'Error';
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          value = '...';
        } else {
          final feedAmount = snapshot.data ?? 0.0;
          value = '${feedAmount.toStringAsFixed(1)} kg';
        }

        return _buildMetricCard(
          label: 'Feed($currentMonth)',
          value: value,
          trend: '',
          isPositive: false,
        );
      },
    );
  }

  Widget _buildMortalityMetricCard(
    String currentMonth,
  ) {
    return StreamBuilder<int>(
      stream: feedAnalyticsController.getMortalityStream(
          yearmonth: NepaliDateTime.now().toIso8601String().substring(0, 7),
          batch['batchId'],
          batch['stage'],
          monthFilter: true),
      builder: (context, snapshot) {
        int value;

        if (snapshot.hasError) {
          value = 0;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          value = 0;
        } else {
          final mortalityCount = snapshot.data ?? 0;
          value = mortalityCount; // You might want to format this number
        }
        final currentCount = batch['currentQuantity'] ?? 0;
        final mortalityRate = (value / (value + currentCount)) * 100;
        return _buildMetricCard(
          label: 'Motality ($currentMonth)',
          value: "$value",
          trend: '${mortalityRate.toStringAsFixed(2)}%',
          isPositive: false,
        );
      },
    );
  }

  Widget _buildProductionMetricCard() {
    return StreamBuilder<double>(
      stream: feedAnalyticsController.getProductionPercentageStream(
          batch['batchId'], batch['currentQuantity'] ?? 0),
      builder: (context, snapshot) {
        double value = 0.0;
        if (!snapshot.hasError && snapshot.hasData) {
          value = snapshot.data ?? 0.0;
        }

        return _buildStatItem(
          icon: LucideIcons.egg,
          label: 'Production',
          value: "${value.toStringAsFixed(1)}%",
          color: Color(0xFF10B981),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(
          //   child: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.grey[50],
          //       borderRadius: BorderRadius.circular(8),
          //       border: Border.all(color: Colors.grey.withOpacity(0.2)),
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Un Productive ',
          //           style: GoogleFonts.inter(
          //             fontSize: 16.sp,
          //             color: Color.fromARGB(255, 24, 23, 23),
          //           ),
          //         ),
          //         const SizedBox(height: 4),
          //         Row(
          //           children: [
          //             Text(
          //               '30 Flocks',
          //               style: GoogleFonts.inter(
          //                 fontSize: 16.sp,
          //                 fontWeight: FontWeight.w600,
          //                 color: Color.fromARGB(255, 125, 14, 14),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Add navigation logic
                Get.to(() => LayingDetailPage(
                      batch: batch,
                    ));
              },
              icon: const Icon(LucideIcons.barChart2, size: 14),
              label:
                  Text('Detailed Analysis', style: TextStyle(fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
