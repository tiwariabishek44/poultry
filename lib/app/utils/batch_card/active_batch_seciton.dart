import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/add_batch/add_batch.dart';
import 'package:poultry/app/modules/dashboard/dashboard.dart';
import 'package:poultry/app/modules/laying_stage/laying_stage_analysis.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActiveBatchesSection extends StatelessWidget {
  ActiveBatchesSection({Key? key}) : super(key: key);
  final controller = Get.put(ActiveBatchCardController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(isSmallScreen),
        const SizedBox(height: 16),
        SizedBox(
          height: 32.5.h,
          child: Obx(() {
            // Show loading indicator while either batches or stats are loading
            if (controller.isLoading.value || controller.isStatsLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = _calculateCardWidth(constraints.maxWidth);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.batches.length + 1,
                  padding:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 8),
                  itemBuilder: (context, index) {
                    if (index == controller.batches.length) {
                      return _buildAddBatchCard(cardWidth, isSmallScreen);
                    }

                    final batch = controller.batches[index];
                    final stats = controller.batchStats[batch.batchId] ?? {};

                    return SizedBox(
                      width: cardWidth,
                      child: _buildBatchCard(batch, stats, isSmallScreen),
                    );
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBatchCard(BatchResponseModel batch, Map<String, dynamic> stats,
      bool isSmallScreen) {
    // Calculate age in weeks
    final startDate = batch.startingDate != null
        ? NepaliDateTime.parse(batch.startingDate!)
        : NepaliDateTime.now();
    final currentDate = NepaliDateTime.now();
    final ageInWeeks = currentDate.difference(startDate).inDays ~/ 7;

    final bool hasAlerts = (stats['totalDeaths'] ?? 0) > 0;

    return Container(
      margin: EdgeInsets.only(right: isSmallScreen ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasAlerts ? Colors.red.shade100 : Colors.green.shade100,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEnhancedHeader(
            name: batch.batchName ?? 'Unnamed Batch',
            age: '$ageInWeeks weeks',
            hasAlerts: hasAlerts,
            isSmallScreen: isSmallScreen,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Summary (${_getCurrentNepaliMonth()})',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 15.sp : 16.sp,
                      color: const Color.fromARGB(255, 24, 24, 24),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  _buildInfoRow(
                    'Flocks ',
                    '${batch.currentFlockCount ?? 0}',
                    Icons.pets,
                    Colors.green,
                    isSmallScreen,
                  ),
                  _buildInfoRow(
                    'Production',
                    '${controller.numberFormat.format(stats['totalEggs'] ?? 0)} eggs',
                    Icons.egg_outlined,
                    Colors.orange,
                    isSmallScreen,
                  ),
                  _buildInfoRow(
                    'Deaths',
                    '${controller.numberFormat.format(stats['totalDeaths'] ?? 0)}',
                    Icons.warning_outlined,
                    Colors.red,
                    isSmallScreen,
                  ),
                  _buildInfoRow(
                    'Feed',
                    '${controller.numberFormat.format(stats['totalFeed'] ?? 0)}kg',
                    Icons.food_bank,
                    Colors.purple,
                    isSmallScreen,
                  ),
                ],
              ),
            ),
          ),
          _buildBatchFooter(isSmallScreen, batch),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isSmallScreen) {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Batches',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${controller.batches.length} - active Batch',
                style: TextStyle(
                  color: const Color.fromARGB(255, 81, 81, 81),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildEnhancedHeader({
    required String name,
    required String age,
    required bool hasAlerts,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: hasAlerts ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: isSmallScreen ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: isSmallScreen ? 14 : 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      age,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isSmallScreen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: isSmallScreen ? 16 : 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildBatchFooter(bool isSmallScreen, BatchResponseModel batch) {
    return GestureDetector(
      onTap: () {
        // Add navigation logic here if needed
        Get.to(() => LayingAnalysisPage(
              batch: batch,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'View Details',
              style: TextStyle(
                color: Colors.indigo.shade700,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.indigo.shade700,
              size: isSmallScreen ? 16 : 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBatchCard(double width, bool isSmallScreen) {
    return Container(
      width: width * 0.8,
      margin: EdgeInsets.only(right: isSmallScreen ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => AddBatchPage());
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.indigo.shade400,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add New Batch',
              style: TextStyle(
                color: Colors.indigo.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start tracking a new flock',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentNepaliMonth() {
    final months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];
    final currentMonth = NepaliDateTime.now().month;
    return months[currentMonth - 1];
  }

  double _calculateCardWidth(double availableWidth) {
    if (availableWidth < 300) return availableWidth * 0.8;
    if (availableWidth < 400) return availableWidth * 0.8;
    if (availableWidth < 600) return 300;
    return 320;
  }
}
