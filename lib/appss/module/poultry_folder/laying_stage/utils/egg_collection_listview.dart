import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/poultry_folder/eggCollectionReport/eggCollectionReportPage.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_stage_controller.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/utils/egg_collection_metrics.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class EggCollectionListview extends StatelessWidget {
  final monthYear;
  final String eggType;
  final String collection;
  final String batchId;
  final bool monthFilter;
  final LayingStageController feedAnalyticsController =
      Get.put(LayingStageController());
  final numberFormat = NumberFormat("#,##,###.0");

  EggCollectionListview({
    Key? key,
    required this.monthYear,
    required this.batchId,
    required this.eggType,
    required this.collection,
    required this.monthFilter,
  }) : super(key: key);

  // Get theme colors based on egg type
  Color _getThemeColor() {
    switch (eggType.toLowerCase()) {
      case 'normal':
        return AppTheme.primaryColor; // Blue theme for normal eggs
      case 'crack':
        return Color(0xFF2563EB); // Orange theme for cracked eggs
      default:
        return Color(0xFFDC2626); // Red theme for waste/null
    }
  }

  // Get grade colors based on egg type
  Map<String, Color> _getGradeColors() {
    switch (eggType.toLowerCase()) {
      case 'normal':
        return {
          'small': Colors.blue,
          'medium': Colors.green,
          'large': Colors.orange,
          'extra large': Colors.purple,
        };
      case 'crack':
        return {
          'small': Color(0xFFF59E0B),
          'medium': Color(0xFFD97706),
          'large': Color(0xFFB45309),
          'extra large': Color(0xFF92400E),
        };
      default:
        return {
          'small': Color(0xFFEF4444),
          'medium': Color(0xFFDC2626),
          'large': Color(0xFFB91C1C),
          'extra large': Color(0xFF991B1B),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();
    final gradeColors = _getGradeColors();

    return Column(
      children: [
        StreamBuilder<Map<String, CountData>>(
          stream: feedAnalyticsController.getEggCountStream(
              monthYear: monthYear,
              eggtype: eggType,
              collection,
              batchId,
              monthFilter: monthFilter),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SizedBox.shrink();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            }

            final counts = snapshot.data ?? {};
            int totalPieces = _calculateTotalPieces(counts);
            int totalFullCrates = totalPieces ~/ 30;
            int totalRemaining = totalPieces % 30;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: themeColor.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getHeaderText(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(() => EggCollectionReport(batchId: batchId));
                      //   },
                      //   child: Container(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      //     decoration: BoxDecoration(
                      //       color: themeColor,
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
                  _buildEggGradeRow(
                    'Small',
                    counts['small'],
                    color: gradeColors['small']!,
                  ),
                  _buildEggGradeRow(
                    'Medium',
                    counts['medium'],
                    color: gradeColors['medium']!,
                  ),
                  _buildEggGradeRow(
                    'Large',
                    counts['large'],
                    color: gradeColors['large']!,
                  ),
                  _buildEggGradeRow(
                    'Extra Large',
                    counts['extra large'],
                    color: gradeColors['extra large']!,
                  ),
                  Divider(height: 24),
                  _buildEggGradeRow(
                    'Total',
                    CountData()
                      ..fullCrates = totalFullCrates
                      ..remainingEggs = totalRemaining
                      ..totalPieces = totalPieces,
                    isTotal: true,
                    color: themeColor,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getHeaderText() {
    String baseText = '';
    if (eggType.isEmpty) {
      baseText = '${collection.toUpperCase()}';
    } else {
      baseText = '${eggType.toUpperCase()} Egg';
    }

    return '$baseText  - Crates';
  }
}

Widget _buildShimmerEffect() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.withOpacity(0.2)),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

int _calculateTotalPieces(Map<String, CountData> counts) {
  return counts.values
      .map((data) => data.totalPieces)
      .fold(0, (sum, count) => sum + count);
}

Widget _buildEggGradeRow(
  String grade,
  CountData? data, {
  bool isTotal = false,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 8),
            Text(
              grade,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              data != null
                  ? "${NumberFormat("#,##,###").format(double.parse('${data.fullCrates}'))}" +
                      ' + ${data.remainingEggs} pice'
                  : '0.0',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
