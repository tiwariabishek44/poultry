import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/modules/laying_stage/laying_stage_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class FeedConsumptionListviewWidget extends StatelessWidget {
  final String monthYear;
  final String batchId;
  final LayingStageAnalysisController feedConsumptionController =
      Get.put(LayingStageAnalysisController());

  FeedConsumptionListviewWidget({
    Key? key,
    required this.monthYear,
    required this.batchId,
  }) : super(key: key);
  final numberFormat = NumberFormat("#,##,###.0");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: feedConsumptionController.getTotalFeedConsumptionStream(
        monthYear: monthYear,
        batchId: batchId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }

        final totalFeedConsumption = snapshot.data ?? 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF059669)),
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
                        LucideIcons.wheat,
                        size: 18,
                        color: Color(0xFF059669),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Total Feed (दाना खपत)',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(() => FeedConsumptionReport(
                  //           batchId: batchId,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${numberFormat.format(totalFeedConsumption)}',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                            ),
                            Text(
                              '  kg',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Color.fromARGB(255, 27, 26, 26),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Container(
                        //   padding:
                        //       EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue[50],
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Icon(
                        //         LucideIcons.bird,
                        //         size: 14,
                        //         color: Colors.blue[700],
                        //       ),
                        //       SizedBox(width: 4),
                        //       Text(
                        //         'Layer Feed',
                        //         style: GoogleFonts.inter(
                        //           fontSize: 12,
                        //           color: Colors.blue[700],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 4),
                        Text(
                          'This Month',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            color: const Color.fromARGB(255, 64, 64, 64),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget for handling error states
  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Text(
        "Error: $error",
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // Widget to display the feed consumption card
  Widget _buildFeedConsumptionCard(double totalFeedConsumption) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              SizedBox(height: 12),
              _buildTotalConsumptionText(totalFeedConsumption),
            ],
          ),
        ),
      ),
    );
  }

  // Title of the widget
  Widget _buildTitle() {
    return Text(
      'Total Feed Consumption for $monthYear',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Display total feed consumption with some style
  Widget _buildTotalConsumptionText(double totalFeedConsumption) {
    return Row(
      children: [
        Text(
          '${totalFeedConsumption.toStringAsFixed(2)} kg',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 8),
        Icon(
          Icons.grain,
          color: Colors.green,
          size: 20,
        ),
      ],
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
