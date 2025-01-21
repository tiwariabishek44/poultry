import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_summary/batch_summary.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchManagementPage extends StatelessWidget {
  const BatchManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Batch Management',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Batch Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Batch #A123',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Age: 45 days',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Management Options
            _buildManagementTile(
              title: 'Batch Summary',
              nepaliTitle: 'ब्याच सारांश',
              onTap: () => Get.to(() => BatchSummaryPage()),
            ),

            _buildManagementTile(
                title: 'Egg Collection Record',
                nepaliTitle: 'अण्डा संकलन रेकर्ड',
                onTap: () {}),

            _buildManagementTile(
                title: 'Feed Consumption Record',
                nepaliTitle: 'दाना खपत रेकर्ड',
                onTap: () {}),

            _buildManagementTile(
                title: 'भूस Record ', nepaliTitle: ' भूस रेकर्ड', onTap: () {}),

            _buildManagementTile(
                title: 'Vaccination Record',
                nepaliTitle: 'खोप रेकर्ड',
                onTap: () {}),

            _buildManagementTile(
                title: 'Mortality Record',
                nepaliTitle: 'मृत्यु दर',
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile({
    required String title,
    required String nepaliTitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromARGB(255, 151, 149, 149)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      nepaliTitle,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: const Color.fromARGB(255, 62, 61, 61),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
