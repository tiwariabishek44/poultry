import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class BatchesDropDown extends StatelessWidget {
  final controller = Get.put(BatchesDropDownController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getBatchesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: GoogleFonts.notoSansDevanagari(color: Colors.red),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 2.h),
              Text(
                'No Active Batches (अक्टिभ ब्याच छैन)',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Add a batch to record (रेकर्ड गर्न ब्याच थप्नुहोस्)',
                style: GoogleFonts.notoSansDevanagari(
                  color: Colors.grey[600],
                ),
              ),
            ],
          );
        }

        final batches = docs
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                })
            .toList();

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedBatchId.value.isEmpty
                    ? null
                    : controller.selectedBatchId.value,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(
                            255, 3, 3, 3)!), // Set border color to grey-black
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(
                            255, 3, 3, 3)!), // Set border color to grey-black
                  ),
                  hintText: 'Select Batch',
                  hintStyle: GoogleFonts.notoSansDevanagari(
                    color: Color.fromARGB(255, 6, 6, 6),
                  ),
                ),
                items: batches
                    .map((batch) => DropdownMenuItem<String>(
                          value: batch['id'],
                          child: Text(
                            '${batch['batchName']}',
                            style: GoogleFonts.notoSansDevanagari(),
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
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 4.w),
              width: 4.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BatchesDropDownController extends GetxController {
  final _loginController = Get.find<LoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // All fields from BatchResponseModel as observables
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

  Stream<QuerySnapshot> getBatchesStream() {
    final adminId = _loginController.adminUid;
    if (adminId == null) return Stream.empty();

    return _firestore
        .collection('batches')
        .where('adminId', isEqualTo: adminId)
        .where('isActive', isEqualTo: true)
        .snapshots();
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
