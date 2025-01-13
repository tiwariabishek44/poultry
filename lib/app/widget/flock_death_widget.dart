import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/modules/laying_stage/laying_stage_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class FlockDeathListviewWidget extends StatelessWidget {
  final String monthYear;
  final String batchId;
  final LayingStageAnalysisController flockDeathController =
      Get.put(LayingStageAnalysisController());

  FlockDeathListviewWidget({
    Key? key,
    required this.monthYear,
    required this.batchId,
  }) : super(key: key);
  final numberFormat = NumberFormat("#,##,###.0");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: flockDeathController.getTotalFlockDeathStream(
        monthYear: monthYear,
        batchId: batchId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect(); // Show shimmer effect while loading
        }

        final totalFlockDeath = snapshot.data ?? 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent),
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
                              totalFlockDeath.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                            ),
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
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
