import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductionCurveWidget extends StatelessWidget {
  ProductionCurveWidget({Key? key}) : super(key: key);

  // Dummy data for production curve
  final List<Map<String, dynamic>> productionData = [
    {"week": 18, "actual": 0, "standard": 0},
    {"week": 19, "actual": 12, "standard": 10},
    {"week": 20, "actual": 45, "standard": 42},
    {"week": 21, "actual": 65, "standard": 68},
    {"week": 22, "actual": 85, "standard": 88},
    {"week": 23, "actual": 92, "standard": 93},
    {"week": 24, "actual": 94, "standard": 95},
    {"week": 25, "actual": 95, "standard": 95},
    {"week": 26, "actual": 94, "standard": 94},
    {"week": 27, "actual": 93, "standard": 93},
    {"week": 28, "actual": 92, "standard": 92},
    {"week": 29, "actual": 91, "standard": 91},
    {"week": 30, "actual": 90, "standard": 90},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildMetricsSummary(),
          const SizedBox(height: 24),
          Container(
            height: 300,
            padding: const EdgeInsets.only(right: 16),
            child: _buildProductionChart(),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Production Curve',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Week 18-30',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 16,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 4),
              Text(
                'Peak Production',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsSummary() {
    return Row(
      children: [
        _buildMetricCard(
          label: 'Current Production',
          value: '90%',
          trend: '-1%',
          isPositive: false,
        ),
        const SizedBox(width: 16),
        _buildMetricCard(
          label: 'Peak Production',
          value: '95%',
          trend: '+2%',
          isPositive: true,
        ),
        const SizedBox(width: 16),
        _buildMetricCard(
          label: 'Vs Standard',
          value: '-0.5%',
          trend: 'Week 30',
          isPositive: false,
          showTrendColor: false,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String trend,
    required bool isPositive,
    bool showTrendColor = true,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: showTrendColor
                        ? (isPositive ? Colors.green[50] : Colors.red[50])
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trend,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: showTrendColor
                          ? (isPositive ? Colors.green[700] : Colors.red[700])
                          : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductionChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  'W${value.toInt()}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 18,
        maxX: 30,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          // Actual Production Line
          LineChartBarData(
            spots: productionData
                .map((data) => FlSpot(
                      data['week'].toDouble(),
                      data['actual'].toDouble(),
                    ))
                .toList(),
            isCurved: true,
            color: Colors.blue[600],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue[100]?.withOpacity(0.2),
            ),
          ),
          // Standard Production Line
          LineChartBarData(
            spots: productionData
                .map((data) => FlSpot(
                      data['week'].toDouble(),
                      data['standard'].toDouble(),
                    ))
                .toList(),
            isCurved: true,
            color: Colors.grey[400],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            dashArray: [5, 5],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: Colors.blue[600]!,
          label: 'Actual Production',
          isDashed: false,
        ),
        const SizedBox(width: 24),
        _buildLegendItem(
          color: Colors.grey[400]!,
          label: 'Breed Standard',
          isDashed: true,
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required bool isDashed,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomPaint(
                      painter: DashedLinePainter(color: color),
                      size: Size(constraints.maxWidth, 3),
                    );
                  },
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Custom painter for dashed lines
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 4, dashSpace = 4, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
