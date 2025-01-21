// lib/app/widgets/finance_metrics_header.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FinanceMetricsHeader extends StatelessWidget {
  FinanceMetricsHeader({Key? key}) : super(key: key);

  final controller = Get.put(FinanceMetricsController());

  String _getCurrentNepaliMonth() {
    final months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];
    final currentMonth = NepaliDateTime.now().month;
    return months[currentMonth - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.h,
      color: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Total Sales Card
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.barChart2,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sales (${_getCurrentNepaliMonth()}) ',
                            style: GoogleFonts.notoSans(
                              fontSize: 16.sp,
                              color: const Color.fromARGB(255, 5, 5, 5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<double>(
                      stream: controller.monthlySalesStream,
                      builder: (context, snapshot) {
                        return Text(
                          'Rs. ${NumberFormat("#,##,###").format(snapshot.data ?? 0)}',
                          style: GoogleFonts.notoSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Amount Receivable Card
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.wallet,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Amount Receivable',
                            style: GoogleFonts.notoSans(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<double>(
                      stream: controller.receivablesStream,
                      builder: (context, snapshot) {
                        return Text(
                          'Rs. ${NumberFormat("#,##,###").format(snapshot.data ?? 0)}',
                          style: GoogleFonts.notoSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceMetricsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _loginController = Get.find<LoginController>();

  Stream<double> get monthlySalesStream {
    final now = NepaliDateTime.now();
    final yearMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    return _firestore
        .collection(FirebasePath.sales)
        .where('yearMonth', isEqualTo: yearMonth)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .snapshots()
        .map((snapshot) {
      double totalSales = 0;
      for (var doc in snapshot.docs) {
        totalSales += (doc.data()['totalAmount'] ?? 0.0).toDouble();
      }
      return totalSales;
    });
  }

  Stream<double> get receivablesStream {
    return _firestore
        .collection(FirebasePath.parties)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .where('isCredited', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      double totalReceivables = 0;
      for (var doc in snapshot.docs) {
        totalReceivables += (doc.data()['creditAmount'] ?? 0.0).toDouble();
      }
      return totalReceivables;
    });
  }
}
