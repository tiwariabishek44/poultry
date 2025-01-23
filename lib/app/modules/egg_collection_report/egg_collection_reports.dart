import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/egg_collection_report/egg_collection_pdf.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EggCollectionReportPage extends StatelessWidget {
  final DateTime selectedMonth;

  const EggCollectionReportPage({
    Key? key,
    required this.selectedMonth,
  }) : super(key: key);

  // Generate daily records data
  List<Map<String, dynamic>> get dailyRecords {
    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    return List.generate(
      daysInMonth,
      (index) => {
        'date': DateTime(selectedMonth.year, selectedMonth.month, index + 1),
        'total': 150 + (index % 10),
        'largePlus': 60 + (index % 5),
        'large': 45 + (index % 5),
        'medium': 30 + (index % 5),
        'small': 15 + (index % 5),
        'cracked': 3 + (index % 2),
        'waste': 2 + (index % 2),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Egg Collection Report',
          style: GoogleFonts.notoSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              final summaryData = {
                'totalCollection': 4500,
                'dailyAverage': 150,
                'peakProduction': 165,
                'layingRate': 93,
                'avgWeight': 58,
                'wastageRate': 5,
              };

              try {
                final file = await EggCollectionPdfService.generateReport(
                  selectedMonth,
                  summaryData,
                  dailyRecords,
                );

                if (value == 'share') {
                  await EggCollectionPdfService.sharePdf(file);
                } else {
                  // For download, you might want to copy the file to a more permanent location
                  final downloadDir = await getExternalStorageDirectory();
                  if (downloadDir != null) {
                    final downloadFile = File(
                        '${downloadDir.path}/${file.path.split('/').last}');
                    await file.copy(downloadFile.path);
                    Get.snackbar(
                      'Success',
                      'Report downloaded successfully',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to generate report',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Download PDF'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Share PDF'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Header
              Center(
                child: Column(
                  children: [
                    Text(
                      'Monthly Egg Collection Report',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat('MMMM yyyy').format(selectedMonth),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Summary Section
              _buildSummarySection(),
              SizedBox(height: 24),

              // Daily Records Table
              Text(
                'Daily Collection Records',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              _buildDailyRecordsTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Summary',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem('Total Collection', '4,500 Crates'),
                    _buildSummaryItem('Daily Average', '150 Crates'),
                    _buildSummaryItem('Peak Production', '165 Crates'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem('Laying Rate', '93%'),
                    _buildSummaryItem('Average Weight', '58 gm/egg'),
                    _buildSummaryItem('Wastage Rate', '5%'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Grade Distribution',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem('Large Plus', '1,800 Crates (40%)'),
                    _buildSummaryItem('Large', '1,350 Crates (30%)'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem('Medium', '900 Crates (20%)'),
                    _buildSummaryItem('Small', '450 Crates (10%)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRecordsTable() {
    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final List<Map<String, dynamic>> dailyRecords = List.generate(
      daysInMonth,
      (index) => {
        'date': DateTime(selectedMonth.year, selectedMonth.month, index + 1),
        'total': 150 + (index % 10),
        'largePlus': 60 + (index % 5),
        'large': 45 + (index % 5),
        'medium': 30 + (index % 5),
        'small': 15 + (index % 5),
        'cracked': 3 + (index % 2),
        'waste': 2 + (index % 2),
      },
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
          columns: [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Large+')),
            DataColumn(label: Text('Large')),
            DataColumn(label: Text('Medium')),
            DataColumn(label: Text('Small')),
            DataColumn(label: Text('Cracked')),
            DataColumn(label: Text('Waste')),
          ],
          rows: dailyRecords.map((record) {
            return DataRow(
              cells: [
                DataCell(Text(DateFormat('MMM d').format(record['date']))),
                DataCell(Text('${record['total']}')),
                DataCell(Text('${record['largePlus']}')),
                DataCell(Text('${record['large']}')),
                DataCell(Text('${record['medium']}')),
                DataCell(Text('${record['small']}')),
                DataCell(Text('${record['cracked']}')),
                DataCell(Text('${record['waste']}')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initializationSettings);
    _isInitialized = true;
  }

  static Future<void> showDownloadNotification({
    required String title,
    required String body,
    bool isComplete = false,
  }) async {
    await initialize();

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Show download progress',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: !isComplete,
      maxProgress: 100,
      progress: isComplete ? 100 : 0,
      playSound: isComplete,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      0,
      title,
      body,
      details,
    );
  }
}
