// poultry_dashboard_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/module/poultry_folder/home_screen_tabs/utils/shrimmer.dart';
import 'package:poultry/appss/module/poultry_folder/laying_stage/laying_stage.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PoultryDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginController = Get.find<PoultryLoginController>();

  Stream<List<Map<String, dynamic>>> getBatchesStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value([]);

    return _firestore
        .collection('batches')
        .where('adminUid', isEqualTo: adminUid)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }
}

class PoultryDashboardScreen extends StatelessWidget {
  final controller = Get.put(PoultryDashboardController());
  final numberFormat = NumberFormat("#,##,###");

  PoultryDashboardScreen({Key? key}) : super(key: key);
  String formatNepaliDate(NepaliDateTime date) {
    final nepaliMonths = [
      'Baishak',
      'Jestha',
      'Ashar',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangshir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];

    return '${date.day}-${nepaliMonths[date.month - 1]}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Analytics  ',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ' ${formatNepaliDate(NepaliDateTime.now())}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        toolbarHeight: 12.h,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getBatchesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return BroodingStageShimmer();
              },
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading batches: ${snapshot.error}',
                style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16, color: Colors.red),
              ),
            );
          }

          final batches = snapshot.data ?? [];

          if (batches.isEmpty) {
            return Center(
              child: Text(
                'No batches available',
                style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16, color: Colors.grey[700]),
              ),
            );
          }

          return ListView.builder(
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              final stage = batch['stage'] ?? 'Unknown Stage';

              switch (stage) {
                case 'Laying Stage':
                  return LayingStageWidget(batch: batch);
                default:
                  return ListTile(
                    title: Text(
                      'Unknown Stage',
                      style: GoogleFonts.notoSansDevanagari(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
