import 'dart:developer';

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
import 'package:poultry/appss/widget/nepai_year_month_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OveralPerformance extends StatefulWidget {
  final Map<String, dynamic> batch;

  OveralPerformance({Key? key, required this.batch}) : super(key: key);

  @override
  State<OveralPerformance> createState() => _OveralPerformanceState();
}

class _OveralPerformanceState extends State<OveralPerformance> {
  final feedAnalyticsController = Get.put(LayingStageController());

  final numberFormat = NumberFormat("#,##,###.0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Overal Performance',
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
            SizedBox(height: 4.h),
            _buildMonthlyMetrics(
                widget.batch['batchId'], widget.batch['quantity']),
            SizedBox(
              height: 4.h,
            )
          ],
        ),
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
                widget.batch['batchName'],
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

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatItem(
          color: Colors.blue,
          label: 'Initial',
          value: numberFormat.format(widget.batch['quantity'] ?? 0),
          icon: LucideIcons.bird,
        ),
        _buildStatItem(
          color: Colors.green,
          label: 'Current',
          value: numberFormat.format(widget.batch['currentQuantity'] ?? 0),
          icon: LucideIcons.bird,
        ),
        _buildMortalityMetricCard(),
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

  Widget _buildMortalityMetricCard() {
    return StreamBuilder<int>(
      stream: feedAnalyticsController.getMortalityStream(
          yearmonth: '',
          widget.batch['batchId'],
          widget.batch['stage'],
          monthFilter: false),
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

  Widget _buildMonthlyMetrics(String batachId, int initialCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overal  Performance',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EggCollectionListview(
            monthYear: '',
            batchId: batachId,
            monthFilter: false,
            eggType: 'normal',
            collection: 'eggCollections',
          ),
          EggCollectionListview(
            monthYear: '',
            batchId: batachId,
            monthFilter: false,
            eggType: 'crack',
            collection: 'eggCollections',
          ),
          EggCollectionListview(
            monthYear: '',
            eggType: '',
            collection: 'eggWaste',
            batchId: batachId,
            monthFilter: false,
          ),
          const SizedBox(height: 16),
          FeedConsumptionWidget(
            monthFilter: false,
            yearmonth: '',
            batchId: batachId,
          ),
          const SizedBox(height: 16),
          MortalityWidget(
            monthFilter: false,
            yearmonth: '',
            batchId: batachId,
            initialCount: initialCount,
          ),
        ],
      ),
    );
  }
}
