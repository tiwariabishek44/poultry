import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_stage_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class EggClassificationsWidget extends StatelessWidget {
  final String eggType;
  final String batchId;
  final String currentMonth;
  final bool monthFilter;
  final String colleciton;
  final LayingStageController feedAnalyticsController =
      Get.put(LayingStageController());

  EggClassificationsWidget({
    Key? key,
    required this.batchId,
    required this.eggType,
    required this.currentMonth,
    required this.monthFilter,
    required this.colleciton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, CountData>>(
      stream: feedAnalyticsController.getEggCountStream(colleciton, batchId,
          monthYear: '', eggtype: eggType, monthFilter: monthFilter),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SizedBox.shrink();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }

        final counts = snapshot.data ?? {};
        return Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentMonth == ''
                    ? eggType == ''
                        ? '${colleciton.toUpperCase()} (Total) - Crates'
                        : ' ${eggType.toUpperCase()} Egg (Total) - Crates'
                    : eggType == ''
                        ? '${colleciton.toUpperCase()} ($currentMonth) -Crates'
                        : '${eggType.toUpperCase()} Egg ($currentMonth) - Crates',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 57, 56, 56),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEggStatCard('S', counts['small'], Colors.blue),
                  SizedBox(width: 2.w),
                  _buildEggStatCard('M', counts['medium'], Colors.green),
                  SizedBox(width: 2.w),
                  _buildEggStatCard('L', counts['large'], Colors.orange),
                  SizedBox(width: 2.w),
                  _buildEggStatCard('L+', counts['extra large'], Colors.purple),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 180,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 30,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEggStatCard(String grade, CountData? data, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                grade,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data != null
                    ? NumberFormat("#,##,###.0")
                        .format(double.parse(data.displayCrates))
                    : '0.0',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
