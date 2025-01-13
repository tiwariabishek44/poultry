import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:shimmer/shimmer.dart';

class VaccineReportController extends GetxController {
  final String batchId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList vaccines = [].obs;
  final RxBool isLoading = true.obs;

  VaccineReportController({required this.batchId});

  final numberFormat = NumberFormat('#,##0');

  @override
  void onInit() {
    super.onInit();
    fetchVaccineRecords();
  }

  Future<void> fetchVaccineRecords() async {
    try {
      isLoading.value = true;
      final QuerySnapshot vaccineSnapshot = await _firestore
          .collection('myVaccines')
          .where('batchId', isEqualTo: batchId)
          .get();

      vaccines.value = vaccineSnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              })
          .toList();
    } catch (e) {
      print('Error fetching vaccine records: $e');
      Get.snackbar(
        'Error',
        'Failed to load vaccine records',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class VaccineReportPage extends StatelessWidget {
  final String batchId;
  final String batchName;

  VaccineReportPage({
    Key? key,
    required this.batchId,
    required this.batchName,
  }) : super(key: key);

  late final controller = Get.put(
    VaccineReportController(batchId: batchId),
    tag: batchId,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          'Vaccine Report',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Wave decoration
          Container(
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          // Batch Info Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.layers,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Batch Information',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Batch Name: $batchName',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Vaccine Records List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerLoading();
              }

              if (controller.vaccines.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.syringe,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No vaccine records found',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: controller.vaccines.length,
                itemBuilder: (context, index) {
                  final vaccine = controller.vaccines[index];
                  return _buildVaccineCard(vaccine);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              height: 15.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVaccineCard(Map<String, dynamic> vaccine) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.syringe,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  vaccine['vaccineName'] ?? 'Unknown Vaccine',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
            icon: LucideIcons.calendar,
            label: 'Date:',
            value: vaccine['vaccinationDate'] ?? 'N/A',
          ),
          SizedBox(height: 1.h),
          _buildInfoRow(
            icon: LucideIcons.clock,
            label: 'Age:',
            value: '${vaccine['age'] ?? 'N/A'} days',
          ),
          SizedBox(height: 1.h),
          _buildInfoRow(
            icon: LucideIcons.users,
            label: 'Flock Count:',
            value: controller.numberFormat.format(vaccine['flockCount'] ?? 0),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          value,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
