import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/module/poultry_folder/feet_consumption_report/feed_consumption_report_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/nepai_year_month_picker.dart';

class FeedConsumptionReport extends StatefulWidget {
  final String batchId;
  FeedConsumptionReport({Key? key, required this.batchId}) : super(key: key);

  @override
  State<FeedConsumptionReport> createState() => _FeedConsumptionReportState();
}

class _FeedConsumptionReportState extends State<FeedConsumptionReport> {
  final controller = Get.put(FeedConsumptionReportController());
  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    _selectedDate = NepaliDateTime.now().toIso8601String().substring(0, 7);
  }

  void _onDateSelected(String date) {
    setState(() {
      _selectedDate = date;
    });
  }

  final numberFormat = NumberFormat("#,##,###.0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Feed Reports'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NepaliMonthYearPicker(
              onDateSelected: _onDateSelected,
              initialDate: NepaliDateTime.now(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.getConsumptionsStream(
                  _selectedDate, widget.batchId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.separated(
                    padding: EdgeInsets.all(4.w),
                    itemCount: 3,
                    separatorBuilder: (_, __) => SizedBox(height: 2.h),
                    itemBuilder: (_, __) => _buildShimmerCard(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_food_outlined,
                            size: 48, color: AppTheme.textMedium),
                        SizedBox(height: 2.h),
                        Text('कुनै चारा खपत भेटिएन',
                            style: AppTheme.titleMedium),
                      ],
                    ),
                  );
                }

                controller.calculateTotalFeed(snapshot.data!);

// Sort the documents by date in descending order
                final sortedDocs = docs.toList()
                  ..sort((a, b) {
                    final dateA = a['consumedAt'] as String;
                    final dateB = b['consumedAt'] as String;
                    // Compare dates in format "YYYY-MM-DD"
                    return dateB.compareTo(
                        dateA); // Reverse comparison for descending order
                  });

                return ListView.separated(
                  padding: EdgeInsets.all(4.w),
                  itemCount: sortedDocs.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 4.h,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  itemBuilder: (context, index) {
                    final consumption =
                        sortedDocs[index].data() as Map<String, dynamic>;
                    return _buildConsumptionCard(consumption);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionCard(Map<String, dynamic> consumption) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: AppTheme.textLight),
                    SizedBox(width: 1.w),
                    Text(
                      consumption['consumedAt'] ?? '',
                      style: AppTheme.bodyMedium
                          .copyWith(color: AppTheme.textLight),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    consumption['feedCategory'] ?? '',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${consumption['batchName']}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textMedium,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.scale_outlined,
                        size: 16, color: AppTheme.textLight),
                    SizedBox(width: 1.w),
                    Text(
                      '${numberFormat.format(double.parse(consumption['totalFeed'].toStringAsFixed(2)))} के.जी.',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Color.fromARGB(255, 28, 30, 31),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 30.w,
                  height: 20,
                  color: Colors.white,
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40.w,
                  height: 20,
                  color: Colors.white,
                ),
                Container(
                  width: 20.w,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
