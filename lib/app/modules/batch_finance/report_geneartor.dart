import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:poultry/app/modules/batch_finance/batch_finance_controller.dart';
import 'package:poultry/app/widget/loading_State.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchFinancePdfPage extends StatelessWidget {
  final String batchName;

  final controller = Get.find<BatchFinanceController>();
  final numberFormat = NumberFormat("#,##,###");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  BatchFinancePdfPage({required this.batchName}) {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _openDownloadedPdf(details.payload ?? '');
      },
    );
  }

  Future<void> _downloadPdf() async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to download the report',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingState(text: 'Report Downloading ...'),
        ),
        barrierDismissible: false,
      );

      // Wait for 2 seconds to show the loading dialog
      await Future.delayed(const Duration(seconds: 2));

      // Generate PDF
      final pdf = await _generatePdf(PdfPageFormat.a4);

      // Get the downloads directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      // Create file name with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'batch_finance_report_$timestamp.pdf';
      final file = File('${downloadsDir.path}/$fileName');

      // Save PDF
      await file.writeAsBytes(pdf);

      // Close progress dialog
      Get.back();

      // Show success notification
      await _showDownloadNotification(fileName, file.path);
    } catch (e) {
      // Close progress dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to download report: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<void> _showDownloadNotification(
      String fileName, String filePath) async {
    const androidDetails = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Download notifications',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'Tap to open $fileName',
      details,
      payload: filePath,
    );
  }

  Future<void> _openDownloadedPdf(String filePath) async {
    try {
      if (filePath.isEmpty) return;

      final file = File(filePath);
      if (await file.exists()) {
        // Open the file using system default or let user choose app
        final result = await OpenFile.open(
          filePath,
          type: 'application/pdf', // Specify MIME type for PDF
        );

        // Handle the result
        switch (result.type) {
          case ResultType.done:
            // File opened successfully
            break;
          case ResultType.fileNotFound:
            Get.snackbar(
              'Error',
              'File not found',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            break;
          case ResultType.noAppToOpen:
            Get.snackbar(
              'Error',
              'No app found to open PDF',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            break;
          case ResultType.permissionDenied:
            Get.snackbar(
              'Error',
              'Permission denied to open file',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            break;
          case ResultType.error:
            Get.snackbar(
              'Error',
              'Failed to open file: ${result.message}',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            break;
        }
      } else {
        Get.snackbar(
          'Error',
          'File not found at specified location',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open file: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leadingWidth: 64,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(LucideIcons.chevronLeft,
                  color: Colors.black87, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          'Batch Finance Report',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(LucideIcons.share2, color: Colors.black54),
          //   onPressed: () {
          //     // Share functionality
          //   },
          // ),
          IconButton(
            icon: Icon(LucideIcons.download, color: Colors.black54),
            onPressed: () => _downloadPdf(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    // Load custom font for Nepali text
    final font = await PdfGoogleFonts.notoSansDevanagariRegular();
    final fontBold = await PdfGoogleFonts.notoSansDevanagariSemiBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) => [
          _buildHeader(font, fontBold),
          _buildSummarySection(font, fontBold),
          _buildFinancialBreakdown(font, fontBold),
          _buildDetailedAnalysis(font, fontBold),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(pw.Font font, pw.Font fontBold) {
    final date = DateFormat('MMMM d, y').format(DateTime.now());

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          controller.currentAdmin?.farmName ?? 'Farm Name ',
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 24.sp,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Batch Finance Report',
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 18.sp,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Generated on: $date',
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Batch Details',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildDetailRow('Batch Name', batchName, font),
              _buildDetailRow('Duration', controller.batchDuration, font),
              _buildDetailRow('Status', 'Active', font),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildSummarySection(pw.Font font, pw.Font fontBold) {
    final isProfit = controller.profit.value >= 0;

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Financial Summary',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 16,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Net ${isProfit ? 'Profit' : 'Loss'}',
                style: pw.TextStyle(font: font),
              ),
              pw.Text(
                'Rs. ${numberFormat.format(controller.profit.value.abs())}',
                style: pw.TextStyle(
                  font: fontBold,
                  color: isProfit ? PdfColors.green700 : PdfColors.red700,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
        ],
      ),
    );
  }

  pw.Widget _buildFinancialBreakdown(pw.Font font, pw.Font fontBold) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Financial Breakdown',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 16,
            ),
          ),
          pw.SizedBox(height: 12),
          _buildBreakdownItem(
            'Total Sales',
            controller.totalSales.value,
            font,
            fontBold,
          ),
          _buildBreakdownItem(
            'Total Purchases',
            controller.totalPurchases.value,
            font,
            fontBold,
          ),
          _buildBreakdownItem(
            'Total Expenses',
            controller.totalExpenses.value,
            font,
            fontBold,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDetailedAnalysis(pw.Font font, pw.Font fontBold) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Detailed Analysis',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 16,
            ),
          ),
          pw.SizedBox(height: 12),
          _buildAnalysisSection(
            'Sales Categories',
            controller.topSellingCategories,
            controller.totalSales.value,
            controller.getSalesPercentage,
            font,
            fontBold,
          ),
          pw.SizedBox(height: 12),
          _buildAnalysisSection(
            'Purchase Categories',
            controller.topPurchasedItems,
            controller.totalPurchases.value,
            controller.getPurchasePercentage,
            font,
            fontBold,
          ),
          pw.SizedBox(height: 12),
          _buildAnalysisSection(
            'Expense Categories',
            controller.topExpenseCategories,
            controller.totalExpenses.value,
            controller.getExpensePercentage,
            font,
            fontBold,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildAnalysisSection(
    String title,
    List<MapEntry<String, double>> items,
    double total,
    double Function(String) getPercentage,
    pw.Font font,
    pw.Font fontBold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey300),
            ),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 14,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        ...items.map((item) {
          final percentage = getPercentage(item.key);
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        item.key,
                        style: pw.TextStyle(font: font),
                      ),
                    ),
                    pw.Text(
                      'Rs. ${numberFormat.format(item.value)}',
                      style: pw.TextStyle(font: fontBold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        height: 4,
                        color: PdfColors.grey300,
                        child: pw.Container(
                          width: percentage,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildDetailRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                font: font,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Text(
            ': ',
            style: pw.TextStyle(font: font),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: font),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildBreakdownItem(
    String title,
    double amount,
    pw.Font font,
    pw.Font fontBold,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(font: font),
          ),
          pw.Text(
            'Rs. ${numberFormat.format(amount)}',
            style: pw.TextStyle(font: fontBold),
          ),
        ],
      ),
    );
  }
}
