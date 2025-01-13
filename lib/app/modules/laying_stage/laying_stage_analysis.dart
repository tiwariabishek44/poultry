import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/laying_stage/laying_stage_controller.dart';
import 'package:poultry/app/widget/egg_collestion_list_widget.dart';
import 'package:poultry/app/widget/feed_consumption_widget.dart';
import 'package:poultry/app/widget/flock_death_widget.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/egg_collection_listview.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/feed_consumption.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/mortality_widget.dart';
import 'package:poultry/appss/widget/nepai_year_month_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LayingAnalysisPage extends StatefulWidget {
  final BatchResponseModel batch;

  LayingAnalysisPage({Key? key, required this.batch}) : super(key: key);

  @override
  State<LayingAnalysisPage> createState() => _LayingAnalysisPageState();
}

class _LayingAnalysisPageState extends State<LayingAnalysisPage> {
  final feedAnalyticsController = Get.put(LayingStageAnalysisController());

// Initial date in the format 'yy-mm'

  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    // Set initial date to current date in 'yy-mm' format
    _selectedDate = NepaliDateTime.now().toIso8601String().substring(0, 7);
  }

  // Method to format the Nepali Date to 'yy-mm'
  String _getFormattedDate(NepaliDateTime date) {
    return '${date.year.toString().substring(2)}-${(date.month).toString().padLeft(2, '0')}';
  }

  // Callback when a date is selected from the picker
  void _onDateSelected(String date) {
    setState(() {
      _selectedDate = date;
    });
    log('Select year month : $date');
  }

  final numberFormat = NumberFormat("#,##,###.0");

  @override
  Widget build(BuildContext context) {
    log(" this is the batch id ${widget.batch.stage}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          ' Analysis',
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
            _buildSummaryCard(),
            // ProductionCurveWidget(),
            SizedBox(height: 4.h),
            _buildMonthlyMetrics(
                widget.batch.batchId!, widget.batch.initialFlockCount ?? 0),

            SizedBox(
              height: 4.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
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
              _buildQuickStats(),
              SizedBox(height: 1.h),
              // container button in the right alighnemt of the text ( Overal Performace )
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
                widget.batch.batchName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
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
          value: numberFormat.format(widget.batch.initialFlockCount ?? 0),
          icon: LucideIcons.bird,
        ),
        _buildStatItem(
          color: Colors.green,
          label: 'Current',
          value: numberFormat.format(widget.batch.currentFlockCount ?? 0),
          icon: LucideIcons.bird,
        ),
        // _bui/ldMortalityMetricCard(),
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
                'Monthly Performance',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NepaliMonthYearPicker(
                  onDateSelected: _onDateSelected,
                  initialDate: NepaliDateTime.now(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EggCollectionListviewWidget(
            monthYear: _selectedDate,
            batchId: batachId,
          ),
          const SizedBox(height: 16),
          FeedConsumptionListviewWidget(
            monthYear: _selectedDate,
            batchId: batachId,
          ),
          const SizedBox(height: 16),
          FlockDeathListviewWidget(
            monthYear: _selectedDate,
            batchId: batachId,
          ),
        ],
      ),
    );
  }
}
