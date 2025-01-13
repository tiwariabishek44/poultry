import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_deail_page.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/overal_Performance.dart';
import 'package:poultry/appss/module/setting/batch_vaccine_record/batch_vaccine_report.dart';
import 'package:poultry/appss/module/setting/brooding_stage_report/brooding_stage_report.dart';
import 'package:poultry/appss/module/setting/grow_stage_report/growth_stage_report.dart';
import 'package:poultry/appss/module/setting/laying_stage_report/laying_stage_report.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchActonPage extends StatelessWidget {
  final Map<String, dynamic> batch;

  BatchActonPage({
    required this.batch,
  });

  final List<Map<String, dynamic>> options = [
    {
      'title': 'Vaccination Record',
      'icon': LucideIcons.syringe,
      'subtitle': 'View vaccination records',
    },
    {
      'title': 'Laying Stage Report',
      'icon': LucideIcons.egg,
      'subtitle': 'Track egg production data',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          batch['batchName'],
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: options.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            title: Text(
              option['title'],
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(
                      option['icon'],
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      option['subtitle'],
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () => _navigateToPage(option['title']),
          );
        },
      ),
    );
  }

  void _navigateToPage(String option) {
    // BroodingStateReport
    Widget page;
    switch (option) {
      case 'Batch Overview':
      case 'Feed Consumption Report':
      case 'Medication Reports':
        page = GrowthStageReport(
          batch: batch,
        );
        break;
      case 'Brooding Stage Report':
        page = BroodingStateReport(
          batch: batch,
        );
        break;
      case 'Laying Stage Report':
        page = OveralPerformance(batch: batch);
        break;

      case 'Grower Stage Report':
        page = OveralPerformance(
          batch: batch,
        );
        break;

      case 'Vaccination Record':
        page = VaccineReportPage(
          batchId: batch['batchId'],
          batchName: batch['batchName'],
        );
        break;

      default:
        page = GrowthStageReport(
          batch: batch,
        );
    }
    Get.to(() => page);
  }
}
