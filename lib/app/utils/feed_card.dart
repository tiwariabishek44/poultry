import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedCard extends StatelessWidget {
  FeedCard({Key? key}) : super(key: key);
  final controller = Get.find<ActiveBatchStreamController>();
  final numberFormat =
      NumberFormat('###,##0.##'); // Adjusted format for better readability

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildFeedMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFFE53E3E),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'दाना व्यवस्थापन',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Feed Management',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_horiz,
            color: Color(0xFF718096),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'inventory',
              child: Text('View Inventory'),
            ),
            const PopupMenuItem(
              value: 'history',
              child: Text('Feed History'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedMetrics() {
    return StreamBuilder<Map<String, double>>(
      stream: controller.feedConsumptionByTypeStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data ?? {'B-0': 0.0, 'B-1': 0.0, 'B-2': 0.0};
        final b0Weight = data['B-0']!;
        final b1Weight = data['B-1']!;
        final b2Weight = data['B-2']!;

        return Column(
          children: [
            feedTypeMetric('B-0 खपत', numberFormat.format(b0Weight)),
            SizedBox(height: 1.h), // Responsive spacing
            feedTypeMetric('B-1 खपत', numberFormat.format(b1Weight)),
            SizedBox(height: 1.h), // Responsive spacing
            feedTypeMetric('B-2 खपत', numberFormat.format(b2Weight)),
          ],
        );
      },
    );
  }

  Widget feedTypeMetric(String title, String value) {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromARGB(255, 220, 220, 220)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3748),
            ),
          ),
          Text(
            '$value Kg', // Displaying the formatted value with unit
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
