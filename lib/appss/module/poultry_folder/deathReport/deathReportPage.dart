import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/module/poultry_folder/deathReport/deathReportController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/nepai_year_month_picker.dart';

class DeathRecord extends StatefulWidget {
  final String stage;
  final String batchId;
  DeathRecord({Key? key, required this.batchId, required this.stage})
      : super(key: key);

  @override
  State<DeathRecord> createState() => _DeathRecordState();
}

class _DeathRecordState extends State<DeathRecord> {
  final controller = Get.put(DeathRecordController());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Motality Reports'),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.all(4),
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
                stream: controller.getDeathRecordsStream(
                    _selectedDate, widget.batchId, widget.stage),
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
                          Icon(Icons.warning_amber_rounded,
                              size: 48, color: AppTheme.textMedium),
                          SizedBox(height: 2.h),
                          Text('कुनै मृत्यु रेकर्ड भेटिएन',
                              style: AppTheme.titleMedium),
                        ],
                      ),
                    );
                  }

                  controller.calculateTotalDeaths(snapshot.data!);

// Sort the documents by date in descending order
                  final sortedDocs = docs.toList()
                    ..sort((a, b) {
                      final dateA = a['recordedAt'] as String;
                      final dateB = b['recordedAt'] as String;
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
                      final record =
                          sortedDocs[index].data() as Map<String, dynamic>;
                      return _buildDeathRecordCard(record);
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildDeathRecordCard(Map<String, dynamic> record) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      record['recordedAt'] ?? '',
                      style: AppTheme.bodyMedium
                          .copyWith(color: AppTheme.textLight),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${record['deathCount']} मृत्यु',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
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
                  'ब्याच: ${record['batchName']}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textMedium,
                  ),
                ),
              ],
            ),
            if (record['remarks']?.isNotEmpty ?? false) ...[
              SizedBox(height: 1.h),
              Text(
                'टिप्पणी: ${record['remarks']}',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              width: 40.w,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 1.h),
            Container(
              width: 60.w,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
