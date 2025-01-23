import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report.dart';
import 'package:poultry/app/modules/my_calender/my_calender.dart';
import 'package:poultry/app/utils/batch_card/active_batch_seciton.dart';
import 'package:poultry/app/utils/dashboard_header/dashboard_header.dart';
import 'package:poultry/app/utils/farmer_status_card.dart';
import 'package:poultry/app/widget/bottom_sheet.dart';
import 'package:poultry/app/widget/up_comming_task.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PoultryDashboard extends StatelessWidget {
  const PoultryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, // Set status bar color to dark
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 35, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Farm Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  onTap: () => Get.back(),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('My Calendar'),
                  onTap: () => Get.to(() => MyCalendarView()),
                ),
                ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text('Monthly Report'),
                  onTap: () => Get.to(() => MonthlyReportPage()),
                ),
              ],
            ),
          ),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => FractionallySizedBox(
                  heightFactor: 0.85, // This makes it take 80% of screen height
                  child: const ActivityBottomSheet(),
                ),
              );
            },
          ),
          // // floating action button circular eget

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
