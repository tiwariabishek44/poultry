import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_batch/add_batch.dart';
import 'package:poultry/app/modules/analytics_page/analytics_page.dart';
import 'package:poultry/app/modules/batchOperations/batch_operations.dart';
import 'package:poultry/app/modules/egg_collection_add/egg_colleciton.dart';
import 'package:poultry/app/modules/feed_consumption/feed_consumption.dart';
import 'package:poultry/app/modules/flock_death/flock_death.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/my_vaccine/vaccine_schedule.dart';
import 'package:poultry/app/modules/add_party/add_parties.dart';
import 'package:poultry/app/modules/parties_detail/party_list.dart';
import 'package:poultry/app/modules/report_generator/report_generator.dart';
import 'package:poultry/app/modules/rice_husk_spray/rice_husk_spray.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextStyle sectionStyle = GoogleFonts.notoSansDevanagari(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  final TextStyle buttonStyle = GoogleFonts.notoSansDevanagari(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: Text(
          'Activity Panel',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          TextButton(
            onPressed: () => _showLogoutDialog(),
            child: Text(
              'लग आउट',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        children: [
          _buildSection(
            'Daily Activity',
            [
              _buildGridButtons([
                ButtonData('Egg Collection', 'assets/egg.jpeg',
                    () => Get.to(() => EggCollectionPage())),
                ButtonData('Daily Feed', 'assets/layers.jpeg',
                    () => Get.to(() => FeedConsumptionPage())),
                ButtonData('Motality Record', 'assets/egg.jpeg',
                    () => Get.to(() => FlockDeathPage())),
                ButtonData('भुस Record', 'assets/layers.jpeg',
                    () => Get.to(() => RiceHuskPage())),
              ]),
            ],
          ),
          _buildDivider(),
          _buildSection(
            'Batch Management',
            [
              _buildGridButtons([
                ButtonData('Add New Batch', 'assets/egg.jpeg',
                    () => Get.to(() => AddBatchPage())),
                ButtonData(
                    'Batch Upgrade',
                    'assets/layers.jpeg',
                    () => Get.to(
                        () => BatchUpgradePage(batchId: '', currentStage: ''))),
                ButtonData(
                    'Batch Retire',
                    'assets/egg.jpeg',
                    () => Get.to(
                        () => BatchUpgradePage(batchId: '', currentStage: ''))),
              ]),
            ],
          ),
          _buildDivider(),
          _buildSection(
            'Healty & Medication',
            [
              _buildGridButtons([
                ButtonData('Vaccination', 'assets/layers.jpeg',
                    () => Get.to(() => VaccineSchedulePage())),

                // buttons for the report generator
                ButtonData('Add Party', 'assets/egg.jpeg',
                    () => Get.to(() => PartyListPage())),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text(
            title,
            style: sectionStyle,
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildGridButtons(List<ButtonData> buttons) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 1.h,
      crossAxisSpacing: 2.w,
      childAspectRatio: 2.4,
      children: buttons
          .map((button) =>
              _buildButton(button.text, button.imagePath, button.onTap))
          .toList(),
    );
  }

  Widget _buildButton(String text, String imagePath, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 24.sp,
            height: 24.sp,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: buttonStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Divider(height: 1, color: Colors.grey[300]),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Log out',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'के तपाईं लग आउट गर्न चाहनुहुन्छ?',
          style: GoogleFonts.notoSansDevanagari(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            child: Text(
              'रद्द गर्नुहोस्',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text(
              'लग आउट गर्नुहोस्',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                color: AppColors.primaryColor,
              ),
            ),
            onPressed: () {
              Get.find<LoginController>().logout();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

// Helper class to store button data
class ButtonData {
  final String text;
  final String imagePath;
  final VoidCallback onTap;

  ButtonData(this.text, this.imagePath, this.onTap);
}
