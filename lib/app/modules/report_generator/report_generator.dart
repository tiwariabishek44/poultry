import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportData {
  final String farmName;
  final String reportTitle;
  final DateTime reportDateTime;
  final List<String> headers;
  final List<List<String>> rows;
  final Map<String, String> summary;

  ReportData({
    required this.farmName,
    required this.reportTitle,
    required this.reportDateTime,
    required this.headers,
    required this.rows,
    required this.summary,
  });
}

class DynamicReportPage extends StatefulWidget {
  final ReportData reportData;
  DynamicReportPage({required this.reportData});

  @override
  _DynamicReportPageState createState() => _DynamicReportPageState();
}

class _DynamicReportPageState extends State<DynamicReportPage> {
  bool _isGenerating = false;

  Future<File> _generatePDF() async {
    final pdf = pw.Document();

    // Set table column widths
    final List<double> columnWidths = List.filled(
      widget.reportData.headers.length,
      1 / widget.reportData.headers.length,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            widget.reportData.farmName,
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            widget.reportData.reportTitle,
            style: pw.TextStyle(fontSize: 20),
          ),
          pw.Text(
            'Date: ${widget.reportData.reportDateTime.toLocal().toString().split('.')[0]}',
            style: pw.TextStyle(fontSize: 14),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            cellHeight: 30,
            columnWidths: Map.fromIterables(
              List.generate(columnWidths.length, (index) => index),
              columnWidths.map((width) => pw.FlexColumnWidth(width)),
            ),
            headers: widget.reportData.headers,
            data: widget.reportData.rows,
          ),
          pw.SizedBox(height: 20),
          pw.Header(
            level: 1,
            child: pw.Text('Summary'),
          ),
          ...widget.reportData.summary.entries.map(
            (entry) => pw.Text('${entry.key}: ${entry.value}'),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
      '${output.path}/${widget.reportData.reportTitle.toLowerCase().replaceAll(' ', '_')}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _generateAndSharePDF() async {
    setState(() => _isGenerating = true);
    try {
      final file = await _generatePDF();
      await Share.shareFiles(
        [file.path],
        text: widget.reportData.reportTitle,
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

// Update _generateAndDownloadPDF():

  Future<void> _generateAndDownloadPDF() async {
    setState(() => _isGenerating = true);
    try {
      final file = await _generatePDF();
      final downloadsDir = await getExternalStorageDirectory();

      if (downloadsDir != null) {
        final taskId = await FlutterDownloader.enqueue(
          url: 'file://${file.path}',
          savedDir: downloadsDir.path,
          fileName:
              '${widget.reportData.reportTitle.toLowerCase().replaceAll(' ', '_')}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download started')),
        );
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportData.reportTitle),
        actions: [
          if (_isGenerating)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Generating Report...'),
              ),
            )
          else ...[
            IconButton(
              icon: Icon(Icons.download),
              onPressed: _generateAndDownloadPDF,
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: _generateAndSharePDF,
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reportData.farmName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Date: ${widget.reportData.reportDateTime.toLocal().toString().split('.')[0]}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),
                _buildDataTable(),
                SizedBox(height: 24),
                _buildSummaryCard(),
              ],
            ),
          ),
          if (_isGenerating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: widget.reportData.headers
            .map((header) => DataColumn(label: Text(header)))
            .toList(),
        rows: widget.reportData.rows
            .map((row) => DataRow(
                  cells: row.map((cell) => DataCell(Text(cell))).toList(),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...widget.reportData.summary.entries.map((entry) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('${entry.key}: ${entry.value}'),
                )),
          ],
        ),
      ),
    );
  }
}
