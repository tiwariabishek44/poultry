import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/modules/add_batch/add_batch.dart';
import 'package:poultry/app/modules/add_daily_weight_gain/daily_weight_gain.dart';
import 'package:poultry/app/modules/feed_consumption/feed_consumption.dart';
import 'package:poultry/app/modules/flock_death/flock_death.dart';
import 'package:poultry/app/modules/flock_medication/medicine_list.dart';
import 'package:poultry/app/modules/stock_item/stock_item_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActivityBottomSheet extends StatelessWidget {
  const ActivityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // row for the heading ( activity) and close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activity Panel",
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildActionCard(
                    'Add New Batch',
                    'नयाँ ब्याच थप्नुहोस्',
                    Icons.assessment,
                    () {
                      Get.to(() => AddBatchPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Daily Feed Consumption',
                    'दैनिक आहार खपत',
                    Icons.assessment,
                    () {
                      Get.to(() => FeedConsumptionPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Mortality Record',
                    'मृत्यु रेकर्ड',
                    Icons.assessment,
                    () {
                      Get.to(() => FlockDeathPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Daily weight gain ',
                    'भुस रेकर्ड',
                    Icons.assessment,
                    () {
                      Get.to(() => AddDailyWeightPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Medicine ',
                    'औषधि',
                    Icons.assessment,
                    () {
                      Get.to(() => MedicinePage());
                    },
                  ),

                  SizedBox(height: 1.h),
                  // button for stock itme
                  _buildActionCard(
                    'Stock Item',
                    'स्टक आइटम',
                    Icons.assessment,
                    () {
                      Get.to(() => StockItemsListPage());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionStat(
      String title, String value, IconData icon, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 12 : 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: Colors.white, size: isSmallScreen ? 16 : 20),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue.shade700),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.blue.shade700),
          ],
        ),
      ),
    );
  }
}
