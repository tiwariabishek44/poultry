import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report.dart';
import 'package:poultry/app/modules/my_calender/my_calender.dart';
import 'package:poultry/app/utils/dashboard_header/dashboard_header.dart';
import 'package:poultry/app/utils/farmer_status_card.dart';
import 'package:poultry/app/widget/up_comming_task.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PoultryDashboard extends StatelessWidget {
  const PoultryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, // Set status bar color to dark
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // Main Content
                RefreshIndicator(
                  onRefresh: () async {
                    // Refresh dashboard data
                  },
                  child: CustomScrollView(
                    slivers: [
                      // Custom App Bar
                      SliverToBoxAdapter(
                        child: DashboardHeader(),
                      ),

                      // Main Content
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            // Morning Status Card with Weather
                            FarmStatusCard(),

                            SizedBox(height: 1.h), // Space for FAB

                            // Quick Action Section
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quick Actions',
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        children: [
                                          _buildActionButton(
                                            'Monthly Report',
                                            Icons.bar_chart,
                                            Colors.blue,
                                            () {
                                              Get.to(() => MonthlyReportPage());
                                              // Navigate to monthly report
                                            },
                                          ),
                                          _buildActionButton(
                                            'My Calendar',
                                            Icons.calendar_today,
                                            Colors.purple,
                                            () {
                                              Get.to(() => MyCalendarView());
                                            },
                                          ),
                                          _buildActionButton(
                                            'Daily Feed',
                                            Icons.shopping_bag_outlined,
                                            Colors.green,
                                            () {
                                              // Get.back();
                                              // Navigate to feed recording
                                            },
                                          ),
                                          _buildActionButton(
                                            'Egg Collection',
                                            Icons.favorite_outline,
                                            Colors.red,
                                            () {
                                              // Get.back();
                                              // Navigate to health recording
                                            },
                                          ),
                                          _buildActionButton(
                                            'Monthly Report',
                                            Icons.bar_chart,
                                            Colors.blue,
                                            () {
                                              Get.to(() => MonthlyReportPage());
                                              // Navigate to monthly report
                                            },
                                          ),
                                          _buildActionButton(
                                            'My Calendar',
                                            Icons.calendar_today,
                                            Colors.purple,
                                            () {
                                              Get.to(() => MyCalendarView());
                                            },
                                          ),
                                          _buildActionButton(
                                            'Daily Feed',
                                            Icons.shopping_bag_outlined,
                                            Colors.green,
                                            () {
                                              // Get.back();
                                              // Navigate to feed recording
                                            },
                                          ),
                                          _buildActionButton(
                                            'Egg Collection',
                                            Icons.favorite_outline,
                                            Colors.red,
                                            () {
                                              // Get.back();
                                              // Navigate to health recording
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 1.h,
                            ),

                            UpcomingTasksCard(),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Farm Name and Location
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Green Valley Farm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Chitwan, Nepal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Profile and Notifications
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.cloud, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text(
                  '25°C',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildQuickActionFAB() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       _showQuickActionSheet();
  //     },
  //     backgroundColor: AppColors.primaryColor,
  //     child: const Icon(Icons.add),
  //   );
  // }

  // void _showQuickActionSheet() {
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Sheet Header
  //           Row(
  //             children: [
  //               const Text(
  //                 'Quick Actions',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const Spacer(),
  //               IconButton(
  //                 icon: const Icon(Icons.close),
  //                 onPressed: () => Get.back(),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 24),

  //           // Action Buttons
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               _buildQuickActionButton(
  //                 'Record Eggs',
  //                 Icons.egg_outlined,
  //                 Colors.orange,
  //                 () {
  //                   Get.back();
  //                   // Navigate to egg collection
  //                 },
  //               ),
  //               _buildQuickActionButton(
  //                 'Add Feed',
  //                 Icons.shopping_bag_outlined,
  //                 Colors.green,
  //                 () {
  //                   Get.back();
  //                   // Navigate to feed recording
  //                 },
  //               ),
  //               _buildQuickActionButton(
  //                 'Health Log',
  //                 Icons.favorite_outline,
  //                 Colors.red,
  //                 () {
  //                   Get.back();
  //                   // Navigate to health recording
  //                 },
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 18.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
