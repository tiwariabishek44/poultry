import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/egg_collection_repository.dart';
import 'package:poultry/app/repository/feed_consumption_repository.dart';
import 'package:poultry/app/utils/batch_card/active_batch_seciton.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:get/get.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class FarmStatusController extends GetxController {
  final EggCollectionRepository _eggRepository = EggCollectionRepository();
  final FeedConsumptionRepository _feedRepository = FeedConsumptionRepository();
  final _loginController = Get.find<LoginController>();

  // Observable values for the dashboard
  final RxInt totalEggCrates = 0.obs;
  final RxDouble totalFeedConsumption = 0.0.obs;

  // Subscriptions for cleanup
  StreamSubscription? _eggSubscription;
  StreamSubscription? _feedSubscription;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  @override
  void onClose() {
    _eggSubscription?.cancel();
    _feedSubscription?.cancel();
    super.onClose();
  }

  void _startListening() {
    final currentYearMonth = _getCurrentYearMonth();
    _listenToEggCollections(currentYearMonth);
    _listenToFeedConsumption(currentYearMonth);
  }

  String _getCurrentYearMonth() {
    final now = NepaliDateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  void _listenToEggCollections(String yearMonth) {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }
    _eggSubscription?.cancel();
    _eggSubscription = _eggRepository
        .streamEggCollectionsByYearMonth(adminId, yearMonth)
        .listen((collections) {
      int totalEggs = 0;
      for (var collection in collections) {
        totalEggs += collection.getTotalEggs();
      }
      totalEggCrates.value = (totalEggs / 30).toInt(); // Converting to crates
    });
  }

  void _listenToFeedConsumption(String yearMonth) {
    final adminId = _loginController.adminUid;
    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }
    _feedSubscription?.cancel();
    _feedSubscription = _feedRepository
        .streamFeedConsumptionByYearMonth(adminId, yearMonth)
        .listen((consumptions) {
      double total = 0;
      for (var consumption in consumptions) {
        total += consumption.quantityKg;
      }
      totalFeedConsumption.value = total;
    });
  }

  // Method to refresh data
  void refreshData() {
    _startListening();
  }
}

class FarmStatusCard extends StatelessWidget {
  FarmStatusCard({Key? key}) : super(key: key);
  final FarmStatusController controller = Get.put(FarmStatusController());

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

  final numberFormat = NumberFormat("##,##,###.##");
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildModernHeader(isSmallScreen),
          const SizedBox(height: 24),
          ActiveBatchesSection(),
        ],
      ),
    );
  }

  Widget _buildModernHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row with Title and Month
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Poultry  ",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.yellow.shade300,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getCurrentNepaliMonth(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Farm Overview Stats
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildOverviewStat(
                      'Egg Production',
                      '${numberFormat.format(controller.totalEggCrates.value)}',
                      'Crate',
                      Icons.egg_outlined,
                      isSmallScreen,
                    )),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: Obx(() => _buildOverviewStat(
                      'Feed Consumption',
                      '${numberFormat.format(controller.totalFeedConsumption.value)}',
                      'Kg',
                      LucideIcons.wheat,
                      isSmallScreen,
                    )),
              ),
            ],
          ),
          // .
        ],
      ),
    );
  }

  Widget _buildOverviewStat(
    String label,
    String value,
    String subtitle,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: isSmallScreen ? 16.sp : 16.sp,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 18 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
