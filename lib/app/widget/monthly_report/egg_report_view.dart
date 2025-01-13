// egg_report_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';

class EggReportView extends StatelessWidget {
  final controller = Get.put(MonthlyReportController());

  @override
  Widget build(BuildContext context) {
    controller.fetchEggCollections();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.error.value != null) {
        return Center(child: Text(controller.error.value!));
      }

      if (controller.collections.isEmpty) {
        return Center(child: Text('No egg collections found'));
      }

      return ListView.builder(
        itemCount: controller.collections.length,
        itemBuilder: (context, index) {
          final data = controller.collections[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    data.collectionDate,
                    style: GoogleFonts.notoSansDevanagari(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${data.getTotalEggs()} eggs',
                    style: GoogleFonts.notoSansDevanagari(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTag(data.eggCategory, Colors.green),
                      SizedBox(width: 8),
                      _buildTag(data.eggSize, Colors.orange),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Crates: ${data.totalCrates}, Loose: ${data.remainingEggs}',
                    style: GoogleFonts.notoSansDevanagari(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}
