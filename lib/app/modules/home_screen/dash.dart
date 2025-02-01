import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_daily_weight_gain/daily_weight_gain.dart';
import 'package:poultry/app/modules/feed_consumption/feed_consumption.dart';
import 'package:poultry/app/modules/flock_death/flock_death.dart';
import 'package:poultry/app/modules/flock_medication/medicine_list.dart';
import 'package:poultry/app/utils/batch_card/active_batch_seciton.dart';
import 'package:poultry/app/utils/bird_status_card.dart';
import 'package:poultry/app/utils/feed_card.dart';
import 'package:poultry/app/utils/finance_card.dart';
import 'package:poultry/app/utils/growth_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FarmDashboard extends StatelessWidget {
  const FarmDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      appBar: _buildEnhancedAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(left: 2.w, right: 2.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 1.h),
                    ActiveBatchesSection(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'dashboard_fab',
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          _showMenu(context);
        },
      ),
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      title: const Text(
        'Poultry Dashboard',
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF2D3748),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFF2D3748),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
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

            ListTile(
              leading: Icon(Icons.add),
              title: Text('Daily Feed Record (दैनिक दाना रेकर्ड)'),
              onTap: () {
                // Handle add new batch action
                Navigator.pop(context);
                Get.to(() => FeedConsumptionPage());
              },
            ),
            // for daily feed
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Daily weight gain (दैनिक वजन वृद्धि)'),
              onTap: () {
                // Handle daily feed record action
                Navigator.pop(context);
                Get.to(() => AddDailyWeightPage());
              },
            ),

            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Mortality Record(मृत्यु रेकर्ड)'),
              onTap: () {
                // Handle mortality record action
                Navigator.pop(context);
                Get.to(() => FlockDeathPage());
              },
            ),
            // Medicine
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Medicine Record(औषधि रेकर्ड)'),
              onTap: () {
                // Handle medicine record action
                Navigator.pop(context);
                Get.to(() => MedicinePage());
              },
            ),

            SizedBox(height: 15.h),
          ],
        );
      },
    );
  }
}
