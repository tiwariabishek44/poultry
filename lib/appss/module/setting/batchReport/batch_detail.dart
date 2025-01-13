import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchDetailsPage extends StatelessWidget {
  BatchDetailsPage({Key? key}) : super(key: key);

  // Will be replaced with actual data from batch records
  final batchData = {
    'batchId': 'B001',
    'batchName': 'Batch 2024-A',
    'startDate': '2024-01-15',
    'status': 'Active',
    'initialQuantity': 1000,
    'currentQuantity': 985,
    'age': '45',
    'totalRooms': 2,
    'mortality': 1.5,
    'totalFeed': 2250,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              batchData['batchName']!.toString(),
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Started: ${batchData['startDate']}',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.moreVertical),
            onPressed: () {
              _showBatchOptions(context);
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3, // Number of tabs
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppTheme.primaryColor,
                labelStyle: GoogleFonts.notoSansDevanagari(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.notoSansDevanagari(
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Rooms'),
                  Tab(text: 'Feed'),
                ],
              ),
            ),

            // Tab Bar Views
            Expanded(
              child: TabBarView(
                children: [
                  // Overview Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        children: [
                          BatchOverviewTab(batchData: batchData),
                        ],
                      ),
                    ),
                  ),

                  // Rooms Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: BatchRoomsTab(),
                    ),
                  ),

                  // Feed Tab
                  SingleChildScrollView(child: BatchFeedTab()),

                  // Health Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        children: [
                          Text('Health Records Coming Soon'),
                          // Will add HealthAnalysisComponent here
                        ],
                      ),
                    ),
                  ),

                  // Finance Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        children: [
                          Text('Financial Analysis Coming Soon'),
                          // Will add FinanceAnalysisComponent here
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBatchOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(LucideIcons.edit),
              title: Text('Edit Batch Details'),
              onTap: () {
                Get.back();
                // Navigate to edit batch page
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.fileText),
              title: Text('Export Records'),
              onTap: () {
                Get.back();
                // Show export options
              },
            ),
            if (batchData['status'] == 'Active')
              ListTile(
                leading: Icon(LucideIcons.archive, color: Colors.orange),
                title: Text(
                  'Complete Batch',
                  style: TextStyle(color: Colors.orange),
                ),
                onTap: () {
                  Get.back();
                  // Show complete batch confirmation
                },
              ),
            ListTile(
              leading: Icon(LucideIcons.trash2, color: Colors.red),
              title: Text(
                'Delete Batch',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                // Show delete confirmation
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BatchOverviewTab extends StatelessWidget {
  final Map<String, dynamic> batchData;

  BatchOverviewTab({
    Key? key,
    required this.batchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Basic Info Card
          _buildBasicInfoCard(),

          SizedBox(height: 2.h),

          // Egg Production Metrics
          _buildEggProductionCard(),

          SizedBox(height: 2.h),

          // Feed & Health Card
          _buildFeedAndHealthCard(),

          SizedBox(height: 2.h),

          // Recent Activities
          _buildRecentActivitiesCard(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layer Batch Info',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Week 45 of Production',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: GoogleFonts.notoSansDevanagari(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              _buildMetricTile(
                icon: LucideIcons.calendar,
                label: 'Age',
                value: '65 weeks',
                subLabel: 'Started: Jan 15, 2024',
              ),
              _buildMetricTile(
                icon: LucideIcons.users,
                label: 'Total Birds',
                value: '985',
                subLabel: 'Initial: 1000',
              ),
              _buildMetricTile(
                icon: LucideIcons.home,
                label: 'Rooms',
                value: '2',
                subLabel: 'All occupied',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEggProductionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Egg Production',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildMetricTile(
                icon: LucideIcons.egg,
                label: "Today's Eggs",
                value: '875',
                subLabel: '88.8% rate',
              ),
              _buildMetricTile(
                icon: LucideIcons.package,
                label: 'Weekly Avg',
                value: '865',
                subLabel: '87.8% rate',
              ),
              _buildMetricTile(
                icon: LucideIcons.barChart2,
                label: 'Peak Prod.',
                value: '96.5%',
                subLabel: 'Week 28',
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildProductionIndicator(
            label: 'Current Production Rate',
            value: 88.8,
            target: 85.0,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedAndHealthCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feed & Health',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildMetricTile(
                icon: LucideIcons.wheat,
                label: 'Daily Feed',
                value: '115 kg',
                subLabel: '117g/bird',
              ),
              _buildMetricTile(
                icon: LucideIcons.egg,
                label: 'Feed/Egg',
                value: '132g',
                subLabel: 'Last: 135g',
              ),
              _buildMetricTile(
                icon: LucideIcons.skull,
                label: 'Mortality',
                value: '1.5%',
                subLabel: '15 birds',
                valueColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesCard() {
    final activities = [
      {
        'type': 'Egg Collection',
        'details': '875 eggs collected',
        'time': '2 hours ago',
        'icon': LucideIcons.egg,
      },
      {
        'type': 'Feed Added',
        'details': '50kg Layer Feed Added',
        'time': '5 hours ago',
        'icon': LucideIcons.wheat,
      },
      {
        'type': 'Health Check',
        'details': 'Routine inspection completed',
        'time': 'Yesterday',
        'icon': LucideIcons.stethoscope,
      },
      {
        'type': 'Mortality',
        'details': '1 bird deceased',
        'time': 'Yesterday',
        'icon': LucideIcons.skull,
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activities',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to activity log
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.notoSansDevanagari(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ...activities
              .map((activity) => _buildActivityTile(activity))
              .toList(),
        ],
      ),
    );
  }

  // Helper widgets remain the same but I'll show _buildProductionIndicator as it's new
  Widget _buildProductionIndicator({
    required String label,
    required double value,
    required double target,
  }) {
    final percentage = value;
    final isGood = value >= target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            Row(
              children: [
                Text(
                  '${value.toString()}%',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isGood ? Colors.green : Colors.orange,
                  ),
                ),
                Text(
                  ' / ${target.toString()}%',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          color: isGood ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPerformanceIndicator(
            label: 'Feed Conversion Ratio',
            value: 1.85,
            target: 1.80,
            isGoodWhenLow: true,
          ),
          SizedBox(height: 2.h),
          _buildPerformanceIndicator(
            label: 'Livability Rate',
            value: 98.5,
            target: 98.0,
            isGoodWhenLow: false,
          ),
          SizedBox(height: 2.h),
          _buildPerformanceIndicator(
            label: 'Daily Weight Gain',
            value: 85,
            target: 80,
            isGoodWhenLow: false,
            unit: 'g/day',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required String subLabel,
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            SizedBox(height: 1.h),
            Text(
              value,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subLabel,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 10,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator({
    required String label,
    required double value,
    required double target,
    required bool isGoodWhenLow,
    String? unit,
  }) {
    final percentage = ((value - target) / target * 100).abs();
    final isGood = isGoodWhenLow ? value <= target : value >= target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            Row(
              children: [
                Text(
                  '${value.toString()}${unit ?? ''}',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isGood ? Colors.green : Colors.orange,
                  ),
                ),
                Text(
                  ' / ${target.toString()}${unit ?? ''}',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: value / (target * 1.5),
          backgroundColor: Colors.grey[200],
          color: isGood ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> activity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['type'] as String,
                  style: GoogleFonts.notoSansDevanagari(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity['details'] as String,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'] as String,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class BatchRoomsTab extends StatelessWidget {
  final dummyRooms = [
    {
      'roomId': 'R001',
      'roomNumber': '101',
      'currentCount': 485,
      'initialCount': 500,
      'currentEggProduction': 430,
      'productionRate': 88.6,
      'transfers': [
        {
          'date': '2024-01-15',
          'type': 'Initial',
          'count': 500,
          'notes': 'Initial placement',
        },
        {
          'date': '2024-02-01',
          'type': 'Transfer Out',
          'count': 15,
          'toRoom': '102',
          'notes': 'Adjustment for space',
        },
      ],
    },
    {
      'roomId': 'R002',
      'roomNumber': '102',
      'currentCount': 500,
      'initialCount': 485,
      'currentEggProduction': 445,
      'productionRate': 89.0,
      'transfers': [
        {
          'date': '2024-01-15',
          'type': 'Initial',
          'count': 485,
          'notes': 'Initial placement',
        },
        {
          'date': '2024-02-01',
          'type': 'Transfer In',
          'count': 15,
          'fromRoom': '101',
          'notes': 'Received from Room 101',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header stats
          _buildHeaderStats(),

          // Room List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dummyRooms.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) =>
                _buildRoomListItem(dummyRooms[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    int totalBirds =
        dummyRooms.fold(0, (sum, room) => sum + (room['currentCount'] as int));
    int totalEggs = dummyRooms.fold(
        0, (sum, room) => sum + (room['currentEggProduction'] as int));
    double avgProductionRate = dummyRooms.fold(
            0.0, (sum, room) => sum + (room['productionRate'] as double)) /
        dummyRooms.length;

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatBox(
            'Total Birds',
            totalBirds.toString(),
            LucideIcons.users,
          ),
          _buildStatBox(
            "Today's Eggs",
            totalEggs.toString(),
            LucideIcons.egg,
          ),
          _buildStatBox(
            'Avg. Production',
            '${avgProductionRate.toStringAsFixed(1)}%',
            LucideIcons.percent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomListItem(Map<String, dynamic> room) {
    return InkWell(
      onTap: () {
        _showRoomDetails(room);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Room ${room['roomNumber']}',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      LucideIcons.users,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${room['currentCount']} birds',
                      style: GoogleFonts.notoSansDevanagari(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.egg,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${room['currentEggProduction']} eggs',
                      style: GoogleFonts.notoSansDevanagari(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${room['productionRate']}% rate',
                  style: GoogleFonts.notoSansDevanagari(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRoomDetails(Map<String, dynamic> room) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room ${room['roomNumber']} History',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Transfer History',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 1.h),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (room['transfers'] as List).length,
              itemBuilder: (context, index) {
                final transfer = room['transfers'][index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _getTransferIcon(transfer['type']),
                    color: _getTransferColor(transfer['type']),
                  ),
                  title: Text(
                    '${transfer['type']} - ${transfer['count']} birds',
                    style: GoogleFonts.notoSansDevanagari(
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transfer['date']),
                      if (transfer['notes'] != null) Text(transfer['notes']),
                      if (transfer['toRoom'] != null)
                        Text('Transferred to Room ${transfer['toRoom']}'),
                      if (transfer['fromRoom'] != null)
                        Text('Received from Room ${transfer['fromRoom']}'),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to transfer form
                      Get.back();
                      Get.toNamed('/transfer-birds', arguments: room);
                    },
                    icon: Icon(LucideIcons.moveRight),
                    label: Text('Transfer Birds'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransferIcon(String type) {
    switch (type) {
      case 'Initial':
        return LucideIcons.plus;
      case 'Transfer In':
        return LucideIcons.arrowRight;
      case 'Transfer Out':
        return LucideIcons.arrowLeft;
      default:
        return LucideIcons.move;
    }
  }

  Color _getTransferColor(String type) {
    switch (type) {
      case 'Initial':
        return Colors.green;
      case 'Transfer In':
        return Colors.blue;
      case 'Transfer Out':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class BatchFeedTab extends StatelessWidget {
  BatchFeedTab({Key? key}) : super(key: key);

  final dummyFeedData = {
    'totalBirds': 985,
    'averageFeedPerBird': 117.5, // grams
    'weeklyFeedConsumption': 875.5, // kg
    'feedHistory': [
      {
        'date': '2024-02-15',
        'feedType': 'Layer Mash',
        'quantity': 50.0,
        'roomNumber': '101',
        'consumption': 48.5,
        'remainingStock': 150.0,
      },
      {
        'date': '2024-02-14',
        'feedType': 'Layer Pellet',
        'quantity': 75.0,
        'roomNumber': '102',
        'consumption': 72.5,
        'remainingStock': 200.0,
      },
      {
        'date': '2024-02-13',
        'feedType': 'Layer Mash',
        'quantity': 50.0,
        'roomNumber': '101',
        'consumption': 49.0,
        'remainingStock': 175.0,
      },
      // Add more feed history entries
    ],
    'feedTypes': [
      {
        'type': 'Layer Mash',
        'totalUsed': 2500.0,
        'currentStock': 150.0,
        'cost': 45.0, // per kg
      },
      {
        'type': 'Layer Pellet',
        'totalUsed': 1800.0,
        'currentStock': 200.0,
        'cost': 48.0, // per kg
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Stats
          _buildHeaderStats(),

          // Current Feed Type Status
          _buildFeedTypeStatus(),

          Divider(height: 1, color: Colors.grey[200]),

          // Recent Feed History
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              'Feed History',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (dummyFeedData['feedHistory'] as List?)?.length ??
                0, // Add null check
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) => _buildFeedHistoryItem(
              (dummyFeedData['feedHistory'] as List)[index], // Cast to List
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatBox(
            'Daily Feed/Bird',
            '${dummyFeedData['averageFeedPerBird']}g',
            LucideIcons.wheat,
          ),
          _buildStatBox(
            'Weekly Usage',
            '${dummyFeedData['weeklyFeedConsumption']}kg',
            LucideIcons.package,
          ),
          _buildStatBox(
            'Total Birds',
            dummyFeedData['totalBirds'].toString(),
            LucideIcons.users,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTypeStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
          child: Text(
            'Feed Stock Status',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (dummyFeedData['feedTypes'] as List?)?.length ??
              0, // Add null check
          itemBuilder: (context, index) => _buildFeedTypeItem(
            (dummyFeedData['feedTypes'] as List)[index], // Cast to List
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTypeItem(Map<String, dynamic> feedType) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                feedType['type'],
                style: GoogleFonts.notoSansDevanagari(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${feedType['cost']}/kg',
                style: GoogleFonts.notoSansDevanagari(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock: ${feedType['currentStock']}kg',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 13,
                  color: feedType['currentStock'] < 200
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
              Text(
                'Total Used: ${feedType['totalUsed']}kg',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value:
                feedType['currentStock'] / 500, // Assuming 500kg is max stock
            backgroundColor: Colors.grey[200],
            color:
                feedType['currentStock'] < 200 ? Colors.orange : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedHistoryItem(Map<String, dynamic> history) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            history['feedType'],
            style: GoogleFonts.notoSansDevanagari(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${history['quantity']}kg',
            style: GoogleFonts.notoSansDevanagari(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.home,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Room ${history['roomNumber']}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                history['date'],
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consumed: ${history['consumption']}kg',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Stock: ${history['remainingStock']}kg',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 13,
                  color: history['remainingStock'] < 200
                      ? Colors.orange
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
