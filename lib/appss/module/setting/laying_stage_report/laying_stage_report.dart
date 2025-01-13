import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_stage_controller.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/egg_collection_listview.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/egg_collection_metrics.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/feed_consumption.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/mortality_widget.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/production_curve.dart';
import 'package:poultry/appss/widget/age_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LayingStageReport extends StatelessWidget {
  final Map<String, dynamic> batch;

  LayingStageReport({Key? key, required this.batch}) : super(key: key);
  final feedAnalyticsController = Get.put(LayingStageController());

  final numberFormat = NumberFormat("#,##,###.0");

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Laying Stage Analysis',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(currentMonth),
            // ProductionCurveWidget(),
            SizedBox(height: 4.h),

            SizedBox(
              height: 4.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String currentMonth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 228, 236, 246),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              _buildQuickStats(currentMonth),
              SizedBox(height: 1.h),
              _buildKeyMetrics(),
              SizedBox(height: 1.h),
              EggClassificationsWidget(
                colleciton: 'eggCollections',
                eggType: 'normal',
                currentMonth: '',
                batchId: batch['batchId'],
                monthFilter: false,
              ),
              EggClassificationsWidget(
                colleciton: 'eggCollections',
                eggType: 'crack',
                currentMonth: '',
                batchId: batch['batchId'],
                monthFilter: false,
              ),
              EggClassificationsWidget(
                colleciton: 'eggWaste',
                eggType: '',
                currentMonth: '',
                batchId: batch['batchId'],
                monthFilter: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF2563EB).withOpacity(0.05),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.layers,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                batch['batchName'],
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          Text("Overal Performace ",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              )),
        ],
      ),
    );
  }

  Widget _buildQuickStats(String currentMonth) {
    return Row(
      children: [
        _buildStatItem(
          color: Colors.blue,
          label: 'Initial',
          value: numberFormat.format(batch['quantity'] ?? 0),
          icon: LucideIcons.bird,
        ),
        _buildStatItem(
          color: Colors.green,
          label: 'Current',
          value: numberFormat.format(batch['currentQuantity'] ?? 0),
          icon: LucideIcons.bird,
        ),
        _buildMortalityMetricCard(currentMonth),
      ],
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

  Widget _buildKeyMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildFeedMetricCard(),
        ),
        SizedBox(width: 12),
        // Expanded(
        //   child: _buildMetricCard(
        //     label: 'Un Productive',
        //     value: '500 Birds',
        //     trend: '',
        //     isPositive: true,
        //   ),
        // ),
      ],
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

        return _buildStatItem(
          color: Colors.red,
          label: 'Mortality',
          value: '${value.toStringAsFixed(0)}',
          icon: LucideIcons.bird,
        );
      },
    );
  }

  Widget _buildFeedMetricCard() {
    return StreamBuilder<double>(
      stream: feedAnalyticsController.getFeedConsumptionStream(
          yearmonth: NepaliDateTime.now().toIso8601String().substring(0, 7),
          batch['batchId'],
          batch['stage'],
          monthFilter: false),
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
          label: 'Feed (Total kg)',
          value: value,
          trend: '',
          isPositive: false,
        );
      },
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

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedValue,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isPositive ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
