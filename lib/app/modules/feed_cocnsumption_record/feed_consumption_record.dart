import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/feed_cocnsumption_record/feed_daily_record.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_report_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

import 'feed_consumption_summary.dart';

class FeedConsumptionRecordPage extends StatefulWidget {
  const FeedConsumptionRecordPage({super.key});

  @override
  State<FeedConsumptionRecordPage> createState() =>
      _FeedConsumptionRecordPageState();
}

class _FeedConsumptionRecordPageState extends State<FeedConsumptionRecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final controller = Get.put(BatchReportController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  void _fetchData() {
    controller.fetchFeedConsumptions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDateSelected(String date) {
    setState(() {
      // Update the selected date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feed Consumption Record',
              style: GoogleFonts.notoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Text(
                    'Summary',
                    style: GoogleFonts.notoSans(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Daily Records',
                    style: GoogleFonts.notoSans(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Replace your existing filter FloatingActionButton with this:
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Summary Tab
          FeedConsumptionSummary(),
          // Daily Records Tab
          FeedConsumptionDailyRecords(),
        ],
      ),
    );
  }
}
