import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/laying_stage/laying_stage_controller.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EggCollectionListviewWidget extends StatelessWidget {
  final monthYear;
  final String batchId;
  final LayingStageAnalysisController feedAnalyticsController =
      Get.put(LayingStageAnalysisController());
  final numberFormat = NumberFormat("#,##,###.0");

  EggCollectionListviewWidget({
    Key? key,
    required this.monthYear,
    required this.batchId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<Map<String, CountData>>(
          stream: feedAnalyticsController.getEggCountStream(
            monthYear: monthYear,
            batchId: batchId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SizedBox.shrink();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            }

            final counts = snapshot.data ?? {};

            final salesData = [
              BarData(
                name: "Normal ",
                value: 1200,
                gradientColors: [Colors.blueAccent, Colors.blue],
              ),
              BarData(
                name: "Crack",
                value: 1600,
                gradientColors: [Colors.greenAccent, Colors.green],
              ),
              BarData(
                name: "Waste ",
                value: 1400,
                gradientColors: [
                  const Color.fromARGB(255, 255, 96, 64),
                  const Color.fromARGB(255, 255, 30, 0)
                ],
              ),
            ];

            // Only show the total count for normal, crack, and waste eggs
            return Column(
              children: [
                BeautifulBarChart(
                  data: salesData,
                  maxY: 2000,
                  interval: 400,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Egg Collection',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildCategoryCountRow(
                        'Normal',
                        counts['normal']?.getFormattedEggCount() ??
                            '0 crates + 0 eggs',
                        color: AppColors.primaryColor,
                      ),
                      _buildCategoryCountRow(
                        'Crack',
                        counts['crack']?.getFormattedEggCount() ??
                            '0 crates + 0 Piece',
                        color: Color(0xFF2563EB), // Orange color for crack
                      ),
                      _buildCategoryCountRow(
                        'Waste',
                        counts['waste']?.getFormattedEggCount() ??
                            '0 crates + 0 Piece',
                        color: Color(0xFFDC2626), // Red color for waste
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
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
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCountRow(String category, String formattedCount,
      {required Color color}) {
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
                category,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          Text(
            formattedCount,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for bar items
class BarData {
  final String name;
  final double value;
  final List<Color> gradientColors;

  BarData({
    required this.name,
    required this.value,
    required this.gradientColors,
  });
}

class BeautifulBarChart extends StatelessWidget {
  final List<BarData> data;
  final double maxY;
  final double interval;

  const BeautifulBarChart({
    Key? key,
    required this.data,
    required this.maxY,
    this.interval = 500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${data[groupIndex].name}\nValue: ${rod.toY.round()}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data[value.toInt()].name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: interval,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: item.value,
                      gradient: LinearGradient(
                        colors: item.gradientColors,
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 16.w,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
