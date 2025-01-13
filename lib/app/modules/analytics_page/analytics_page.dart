import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/analytics_page/analytics_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnalyticsPage extends StatelessWidget {
  AnalyticsPage({super.key});

  final controller = Get.put(AnalyticsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'बैच विवरण',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          TextButton.icon(
            onPressed: () => controller.refreshBatches(),
            icon: Icon(Icons.refresh, color: Colors.white),
            label: Text(
              'रिफ्रेस',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.batches.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    itemCount: controller.batches.length,
                    itemBuilder: (context, index) {
                      final batch = controller.batches[index];
                      return _buildBatchCard(batch);
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_batch.png', // Add a simple illustration
            height: 20.h,
          ),
          SizedBox(height: 2.h),
          Text(
            'कुनै बैच फेला परेन',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'नयाँ बैच थप्नुहोस्',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(dynamic batch) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Batch Header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.egg_outlined, color: AppColors.primaryColor),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    batch.batchName,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStageColor(batch.stage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStageInNepali(batch.stage),
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14.sp,
                      color: _getStageColor(batch.stage),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Batch Details
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'सुरु मिति',
                  value: batch.startingDate,
                ),
                Divider(height: 3.h),
                _buildDetailRow(
                  icon: Icons.groups,
                  label: 'हालको चल्ला',
                  value: '${batch.currentFlockCount} वटा',
                  valueColor: Colors.green,
                ),
                if (batch.totalDeath > 0) ...[
                  Divider(height: 3.h),
                  _buildDetailRow(
                    icon: Icons.remove_circle_outline,
                    label: 'जम्मा मृत्यु',
                    value: '${batch.totalDeath} वटा',
                    valueColor: Colors.red,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey[600]),
        SizedBox(width: 3.w),
        Text(
          label,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Color _getStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'starter':
        return Colors.blue;
      case 'grower':
        return Colors.orange;
      case 'layer':
        return Colors.green;
      default:
        return AppColors.primaryColor;
    }
  }

  String _getStageInNepali(String stage) {
    switch (stage.toLowerCase()) {
      case 'starter':
        return 'स्टार्टर';
      case 'grower':
        return 'ग्रोवर';
      case 'layer':
        return 'लेयर';
      default:
        return stage;
    }
  }
}
