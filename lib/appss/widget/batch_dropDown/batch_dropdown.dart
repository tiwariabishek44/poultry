import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropDown_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class BatchDropDown extends StatelessWidget {
  final controller = Get.put(BatchDropDownController());

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
                'No Active Batches',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Add a batch to record',
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
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Select Batch',
                  hintStyle: GoogleFonts.notoSansDevanagari(
                    color: Colors.grey[600],
                  ),
                ),
                items: batches
                    .map((batch) => DropdownMenuItem<String>(
                          value: batch['batchId'],
                          child: Text(
                            '${batch['batchName']}',
                            style: GoogleFonts.notoSansDevanagari(),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedBatchId.value = value;
                    controller.currentFeed.value = batches.firstWhere(
                        (batch) => batch['batchId'] == value)['currentFeed'];
                    controller.selectedBatchName.value = batches.firstWhere(
                        (batch) => batch['batchId'] == value)['batchName'];
                    controller.currentCount.value = batches.firstWhere(
                        (batch) =>
                            batch['batchId'] == value)['currentQuantity'];
                    controller.totaldeath.value = batches.firstWhere(
                        (batch) => batch['batchId'] == value)['totalDeath'];

                    controller.flockStage.value = batches.firstWhere(
                        (batch) => batch['batchId'] == value)['stage'];

                    // Log the current feed value
                    log('Selected Batch Current Feed: ${controller.currentFeed.value}');
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
