import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/utils/dashboard_header/dashboard_header_controller.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final controller = Get.put(DashboardHeaderController());
  Timer? _timer;
  final greeting = ''.obs;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    // Update greeting every minute
    _timer =
        Timer.periodic(const Duration(minutes: 1), (_) => _updateGreeting());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      greeting.value = 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      greeting.value = 'Good Evening';
    } else {
      greeting.value = 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer();
        }
        return _buildContent();
      }),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black87),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    greeting.value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  )),
              const SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      controller.farmerName.value,
                      style: GoogleFonts.poppins(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // make the contianer and put the logout icons
        // GestureDetector(
        //   onTap: () {
        //     CustomDialog.showConfirmation(
        //         title: 'Logout',
        //         message: 'Are you sure you want to logout?',
        //         confirmText: 'Logout',
        //         onConfirm: () {
        //           Get.find<LoginController>().logout();
        //         });
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       color: Colors.blue.shade50,
        //       shape: BoxShape.circle,
        //     ),
        //     child: const Icon(
        //       Icons.logout,
        //       color: Colors.blue,
        //       size: 24,
        //     ),
        //   ),
        // ),
        // _buildWeatherWidget(),
      ],
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wb_sunny_rounded,
            color: Colors.yellow.shade300,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            controller.temperature.value,
            style: GoogleFonts.poppins(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
