import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class EggCollectionPdfService {
  static Future<File> generateReport(
      DateTime selectedMonth,
      Map<String, dynamic> summaryData,
      List<Map<String, dynamic>> dailyRecords) async {
    final pdf = pw.Document();

    // Create PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(selectedMonth),
          pw.SizedBox(height: 20),
          _buildSummarySection(summaryData),
          pw.SizedBox(height: 20),
          _buildDailyRecordsTable(dailyRecords),
        ],
      ),
    );

    // Save the PDF
    final output = await getTemporaryDirectory();
    final String fileName =
        'egg_collection_report_${DateFormat('MMM_yyyy').format(selectedMonth)}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildHeader(DateTime selectedMonth) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'Monthly Egg Collection Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          DateFormat('MMMM yyyy').format(selectedMonth),
          style: pw.TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  static pw.Widget _buildSummarySection(Map<String, dynamic> data) {
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Monthly Summary',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem('Total Collection',
                        '${data['totalCollection']} Crates'),
                    _buildSummaryItem(
                        'Daily Average', '${data['dailyAverage']} Crates'),
                    _buildSummaryItem(
                        'Peak Production', '${data['peakProduction']} Crates'),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem('Laying Rate', '${data['layingRate']}%'),
                    _buildSummaryItem(
                        'Average Weight', '${data['avgWeight']} gm/egg'),
                    _buildSummaryItem(
                        'Wastage Rate', '${data['wastageRate']}%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('$label: '),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDailyRecordsTable(List<Map<String, dynamic>> records) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: pw.FlexColumnWidth(1.2),
        1: pw.FlexColumnWidth(1.0),
        2: pw.FlexColumnWidth(1.0),
        3: pw.FlexColumnWidth(1.0),
        4: pw.FlexColumnWidth(1.0),
        5: pw.FlexColumnWidth(1.0),
        6: pw.FlexColumnWidth(1.0),
        7: pw.FlexColumnWidth(1.0),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            'Date',
            'Total',
            'Large+',
            'Large',
            'Medium',
            'Small',
            'Cracked',
            'Waste',
          ]
              .map((text) => pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(
                      text,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ))
              .toList(),
        ),
        // Data rows
        ...records.map((record) => pw.TableRow(
              children: [
                DateFormat('MMM d').format(record['date']),
                '${record['total']}',
                '${record['largePlus']}',
                '${record['large']}',
                '${record['medium']}',
                '${record['small']}',
                '${record['cracked']}',
                '${record['waste']}',
              ]
                  .map((text) => pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(text),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  // Method to share the PDF
  static Future<void> sharePdf(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Egg Collection Report',
    );
  }
}
