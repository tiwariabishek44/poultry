import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/poultry_folder/eggCollectionReport/eggCollectionReportController.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poultry/appss/widget/nepai_year_month_picker.dart';

class EggCollectionReport extends StatefulWidget {
  final String batchId;
  EggCollectionReport({Key? key, required this.batchId}) : super(key: key);

  @override
  State<EggCollectionReport> createState() => _EggCollectionReportState();
}

class _EggCollectionReportState extends State<EggCollectionReport> {
  final controller = Get.put(EggCollectionReportController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Collection Report',
              style: AppTheme.titleLarge.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              )),
          centerTitle: true,
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
                stream: controller.getCollectionsStream(
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

                  // Inside your StreamBuilder, where you handle the docs:
                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.egg_outlined,
                              size: 48, color: AppTheme.textMedium),
                          SizedBox(height: 2.h),
                          Text('कुनै अण्डा संकलन भेटिएन',
                              style: AppTheme.titleMedium),
                        ],
                      ),
                    );
                  }

// Sort the documents by date in descending order
                  final sortedDocs = docs.toList()
                    ..sort((a, b) {
                      final dateA = a['collectedAt'] as String;
                      final dateB = b['collectedAt'] as String;
                      // Compare dates in format "YYYY-MM-DD"
                      return dateB.compareTo(
                          dateA); // Reverse comparison for descending order
                    });

                  return ListView.separated(
                    padding: EdgeInsets.all(4.w),
                    itemCount: sortedDocs.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 4.h,
                      color: const Color.fromARGB(255, 138, 137, 137)
                          .withOpacity(0.2),
                    ),
                    itemBuilder: (context, index) {
                      final collection =
                          sortedDocs[index].data() as Map<String, dynamic>;
                      return _buildCollectionCard(collection);
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildCollectionCard(Map<String, dynamic> collection) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          // Top Row: Date and Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 14, color: AppTheme.textLight),
                  SizedBox(width: 1.w),
                  Text(
                    collection['collectedAt'] ?? '',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.black),
                  ),
                ],
              ),
              // Egg Type Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  collection['eggCategory']?.toString().toUpperCase() ?? '',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                collection['eggType'] ?? '',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.accentPurple,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Icon(Icons.egg_outlined, size: 16, color: AppTheme.textLight),
              SizedBox(width: 1.w),
              Text(
                '${collection['crates']} क्रेट + ${collection['remainingEggs']} खुद्रा ',
                style: AppTheme.bodyMedium
                    .copyWith(color: Color.fromARGB(255, 28, 30, 31)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 1.w),
            Text(value,
                style: AppTheme.bodyLarge
                    .copyWith(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(label,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMedium)),
      ],
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  3,
                  (_) => Column(
                        children: [
                          Container(
                            width: 60,
                            height: 20,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 16,
                            color: Colors.white,
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
