import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class BatchesDropDown extends StatelessWidget {
  final controller = Get.put(BatchesDropDownController());
  final bool isDropDown;

  BatchesDropDown({
    Key? key,
    this.isDropDown = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getBatchesStream(isDropDown),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorView(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildNoBatchesView();
        }

        final batches = docs
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                })
            .toList();

        // If isDropDown is false and there's data, show only the first batch
        if (!isDropDown) {
          final batch = batches.first;
          controller.updateBatchData(batch['id'], batch);
          return _buildSingleBatchView(batch);
        }

        // If isDropDown is true, show the dropdown with all batches
        return _buildBatchDropdown(batches);
      },
    );
  }

  Widget _buildErrorView(String error) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertTriangle,
            size: 48,
            color: Colors.red.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'Error Loading Batches',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            error,
            style: GoogleFonts.notoSansDevanagari(
              color: Colors.red.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoBatchesView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Active Batches',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add a batch to record',
            style: GoogleFonts.notoSansDevanagari(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleBatchView(Map<String, dynamic> batch) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 120, 120, 120)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Batch',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                LucideIcons.layers,
                size: 20.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  batch['batchName'] ?? 'No Batch Name',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatchDropdown(List<Map<String, dynamic>> batches) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Batch', // Changed from 'Select Active Batch' since we now show all batches
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedBatchId.value.isEmpty
                    ? null
                    : controller.selectedBatchId.value,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  hintText: 'Choose a batch',
                  hintStyle: GoogleFonts.notoSansDevanagari(
                    color: Colors.grey.shade600,
                  ),
                ),
                items: batches
                    .map((batch) => DropdownMenuItem<String>(
                          value: batch['id'],
                          child: Row(
                            children: [
                              Text(
                                batch['batchName'] ?? 'No Batch Name',
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 17.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 8),
                              // Show active/inactive status
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: (batch['isActive'] ?? false)
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (batch['isActive'] ?? false)
                                      ? 'Active'
                                      : 'Inactive',
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 16.sp,
                                    color: (batch['isActive'] ?? false)
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedBatch =
                        batches.firstWhere((batch) => batch['id'] == value);
                    controller.updateBatchData(value, selectedBatch);
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class BatchesDropDownController extends GetxController {
  final _loginController = Get.find<LoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final selectedBatchId = ''.obs;
  final selectedBatchName = ''.obs;
  final initialFlockCount = 0.obs;
  final currentFlockCount = 0.obs;
  final totalDeath = 0.obs;
  final startingDate = ''.obs;
  final retireDate = ''.obs;
  final stage = ''.obs;
  final adminId = ''.obs;
  final isActive = true.obs;

  Stream<QuerySnapshot> getBatchesStream(bool isDropDown) {
    final adminId = _loginController.adminUid;
    if (adminId == null) return Stream.empty();

    // Base query
    var query = _firestore
        .collection(FirebasePath.batches)
        .where('adminId', isEqualTo: adminId);

    // Add isActive filter only if not in dropdown mode
    if (!isDropDown) {
      query = query.where('isActive', isEqualTo: true);
    }

    return query.snapshots();
  }

  void updateBatchData(String batchId, Map<String, dynamic> batchData) {
    selectedBatchId.value = batchId;
    selectedBatchName.value = batchData['batchName'] ?? '';
    initialFlockCount.value = batchData['initialFlockCount'] ?? 0;
    currentFlockCount.value = batchData['currentFlockCount'] ?? 0;
    totalDeath.value = batchData['totalDeath'] ?? 0;
    startingDate.value = batchData['startingDate'] ?? '';
    retireDate.value = batchData['retireDate'] ?? '';
    stage.value = batchData['stage'] ?? '';
    adminId.value = batchData['adminId'] ?? '';
    isActive.value = batchData['isActive'] ?? true;
  }
}
