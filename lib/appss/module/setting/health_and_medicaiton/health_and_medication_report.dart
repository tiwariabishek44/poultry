// health_records_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class HealthRecordsScreen extends StatefulWidget {
  @override
  _HealthRecordsScreenState createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen>
    with SingleTickerProviderStateMixin {
  final loginController = Get.find<PoultryLoginController>();
  late TabController _tabController;
  final searchController = TextEditingController();
  final isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                MedicationRecordsList(loginController: loginController),
                VaccinationRecordsList(loginController: loginController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.primaryColor,
      title: Text(
        'Health Records',
        style: GoogleFonts.notoSansDevanagari(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.white,
        labelStyle: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.w500),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.pill),
                SizedBox(width: 8),
                Text('Medication'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.syringe),
                SizedBox(width: 8),
                Text('Vaccination'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search records...',
          hintStyle: GoogleFonts.notoSansDevanagari(color: Colors.grey[400]),
          prefixIcon: Icon(LucideIcons.search, color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class MedicationRecordsList extends StatelessWidget {
  final PoultryLoginController loginController;

  MedicationRecordsList({required this.loginController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medication_records')
          .where('adminUid', isEqualTo: loginController.adminData.value?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState('Error loading records');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final records = snapshot.data?.docs ?? [];

        if (records.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index].data() as Map<String, dynamic>;
            return _buildRecordCard(record);
          },
        );
      },
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  LucideIcons.pill,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['medicineName'] ?? 'Unknown Medicine',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Batch: ${record['batchName']}',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailItem(
                    'Date',
                    record['nepaliDate'] ?? 'N/A',
                    LucideIcons.calendar,
                  ),
                  if (record['dosage']?.isNotEmpty ?? false)
                    _buildDetailItem(
                      'Dosage',
                      record['dosage'],
                      LucideIcons.gauge,
                    ),
                  if (record['duration']?.isNotEmpty ?? false)
                    _buildDetailItem(
                      'Duration',
                      record['duration'],
                      LucideIcons.clock,
                    ),
                  if (record['notes']?.isNotEmpty ?? false)
                    _buildDetailItem(
                      'Notes',
                      record['notes'],
                      LucideIcons.clipboardList,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.fileText,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'No Records Found',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some records to see them here',
            style: GoogleFonts.notoSansDevanagari(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            error,
            style: GoogleFonts.notoSansDevanagari(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class VaccinationRecordsList extends StatelessWidget {
  final PoultryLoginController loginController;

  VaccinationRecordsList({required this.loginController});

  @override
  Widget build(BuildContext context) {
    // Similar implementation to MedicationRecordsList but for vaccination records
    // Customize UI elements with vaccination-specific icons and fields
    return Container(); // Implement the vaccination records list
  }
}
