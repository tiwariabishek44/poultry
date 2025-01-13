import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/activity_folder/batch_retire/batch_retire.dart';
import 'package:poultry/appss/module/activity_folder/activity_folder_mainScreen/batchListController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchList extends StatelessWidget {
  final bool isBatchUpgrade;
  BatchList({Key? key, required this.isBatchUpgrade}) : super(key: key);

  final BatchListController _batchController = Get.put(BatchListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Batch Records',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _batchController.getBatchesStream(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _batchController.errorMessage.value.isNotEmpty
                        ? _batchController.errorMessage.value
                        : 'Error loading batches',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _batchController.fetchBatches(),
                    icon: Icon(LucideIcons.refreshCcw),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.notoSansDevanagari(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          // Handle empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.packageOpen,
                    color: Colors.grey,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No Batches Found',
                    style: GoogleFonts.notoSansDevanagari(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          // Build list of batches
          final batches = snapshot.data!.docs;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: batches.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    final batch = batches[index].data() as Map<String, dynamic>;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      title: Text(
                        batch['batchName'] ?? 'Unnamed Batch',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Started: ${batch['createdAt']}',
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 1.w),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.bird,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Birds: ${batch['currentQuantity']}/${batch['quantity']}',
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: batch['status'] == 'active'
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          batch['status']?.toString().toUpperCase() ??
                              'UNKNOWN',
                          style: GoogleFonts.notoSansDevanagari(
                            color: batch['status'] == 'active'
                                ? Colors.green
                                : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(() => BatchRetirePage(),
                            arguments: {'batchId': batch['batchId']});

                        // Get.to(() => BatchStageUpdatePage());
                        // Get.to(() => BatchActonPage(
                        //       batchId: batch['batchId'],
                        //       batchName: batch['batchName'],
                        //     ));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
