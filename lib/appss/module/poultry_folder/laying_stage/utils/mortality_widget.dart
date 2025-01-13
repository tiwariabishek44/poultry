import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/module/poultry_folder/deathReport/deathReportPage.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_stage_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MortalityWidget extends StatelessWidget {
  final String yearmonth;
  final String batchId;
  final int initialCount;
  final bool monthFilter;
  final LayingStageController mortalityController =
      Get.put(LayingStageController());
  final numberFormat = NumberFormat("#,##,###.0");

  MortalityWidget({
    Key? key,
    required this.batchId,
    required this.yearmonth,
    this.monthFilter = true,
    required this.initialCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<int>(
        stream: mortalityController.getMortalityStream(batchId, 'Laying Stage',
            yearmonth: yearmonth, monthFilter: monthFilter),
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          }

          log('MortalityWidget: $initialCount');

          final totalDeaths = snapshot.data ?? 0;
          final numberFormat = NumberFormat("#,##,###.0");

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.skull,
                          size: 18,
                          color: Color(0xFFDC2626),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mortality ',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(() => DeathRecord(
                    //           batchId: batchId,
                    //           stage: 'Laying Stage',
                    //         ));
                    //   },
                    //   child: Container(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFF2563EB),
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: Text(
                    //       'Details',
                    //       style: GoogleFonts.inter(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Deaths',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                totalDeaths.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          if (monthFilter)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'This Month',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Text(
                                //   'Last Death: Today',
                                //   style: GoogleFonts.inter(
                                //     fontSize: 12,
                                //     color: Colors.grey[600],
                                //   ),
                                // ),
                              ],
                            ),
                        ],
                      ),
                      // SizedBox(height: 12),
                      // Divider(
                      //   color: Colors.grey.withOpacity(0.2),
                      // ),
                      // SizedBox(height: 12),
                      // _buildDeathCauseRow('Disease', 12, 0.4),
                      // SizedBox(height: 8),
                      // _buildDeathCauseRow('Accident', 5, 0.2),
                      // SizedBox(height: 8),
                      // _buildDeathCauseRow('Unknown', 3, 0.1),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeathCauseRow(String cause, int count, double percentage) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDC2626).withOpacity(0.6),
                ),
              ),
              SizedBox(width: 8),
              Text(
                cause,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFDC2626).withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 40,
                alignment: Alignment.centerRight,
                child: Text(
                  count.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat({
    required String label,
    required String value,
    required IconData icon,
    bool isAlert = false,
  }) {
    Color getAlertColor() {
      if (!isAlert) return Colors.grey;
      switch (value.toLowerCase()) {
        case 'normal':
          return Colors.green;
        case 'warning':
          return Colors.orange;
        case 'critical':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: isAlert ? getAlertColor() : Colors.grey[600],
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isAlert ? getAlertColor() : Colors.grey[900],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
