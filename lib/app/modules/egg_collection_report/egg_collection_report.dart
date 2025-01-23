import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/egg_collection_report/daily_record.dart';
import 'package:poultry/app/modules/egg_collection_report/egg_collection_reports.dart';
import 'package:poultry/app/modules/egg_collection_report/summary.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class EggCollectionRecordPage extends StatefulWidget {
  const EggCollectionRecordPage({super.key});

  @override
  State<EggCollectionRecordPage> createState() =>
      _EggCollectionRecordPageState();
}

class _EggCollectionRecordPageState extends State<EggCollectionRecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedMonth = DateTime.now();
  final controller = Get.put(MonthlyReportController());
  final filterController = Get.put(FilterController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
    ever(filterController.finalDate, (_) => _fetchData());
    ever(filterController.selectedBatchId, (_) => _fetchData());
  }

  void _fetchData() {
    controller.fetchEggCollections();
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Egg Collection Record',
          style: GoogleFonts.notoSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: () {
              Get.to(
                  () => EggCollectionReportPage(selectedMonth: selectedMonth));
            },
          ),
        ],
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
              indicatorSize:
                  TabBarIndicatorSize.tab, // Changed from 'label' to 'tab'
              indicatorWeight:
                  3.0, // Added to make the indicator bar more prominent
              labelStyle: GoogleFonts.notoSans(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: GoogleFonts.notoSans(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
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
                    'Daily ',
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
          FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(
                FilterBottomSheet(
                  onDateSelected: _onDateSelected,
                  showBatch: false,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: Icon(LucideIcons.filter),
            heroTag: null,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Summary Tab
          SummaryTab(),
          // Daily Records Tab
          EggCollectionDailyRecords(),
        ],
      ),
    );
  }
}
