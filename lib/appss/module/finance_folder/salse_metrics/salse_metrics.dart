import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/module/finance_folder/salse_metrics/expense_metrics_controller.dart';
import 'package:poultry/appss/module/finance_folder/salse_metrics/purchases_metrics_controller.dart';
import 'package:poultry/appss/module/finance_folder/salse_metrics/salse_metrics_controllder.dart';
import 'package:poultry/appss/module/finance_folder/salse_metrics/utils/salse_metrics_widget.dart';

class SalseMetrics extends StatelessWidget {
  final String yearMonth;

  SalseMetrics({required this.yearMonth});
  final nepaliMonths = [
    'बैशाख',
    'जेठ',
    'असार',
    'श्रावण',
    'भाद्र',
    'आश्विन',
    'कार्तिक',
    'मंसिर',
    'पौष',
    'माघ',
    'फाल्गुण',
    'चैत्र'
  ];

  String getCurrentNepaliMonth() {
    final now = NepaliDateTime.now();
    return nepaliMonths[now.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    log('YearMonth: $yearMonth');
    final currentMonth = getCurrentNepaliMonth();

    final SalesController salesController = Get.put(SalesController());
    final purchasemetricsController = Get.put(TotalPurchaseController());
    final expenseController = Get.put(TotalExpenseController());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Sales Metric
          MetricWidget(
            title: "बिक्री (${currentMonth})",
            icon: LucideIcons.barChart2,
            color: Colors.green,
            stream: salesController.getTotalMonthlySales(yearMonth),
          ),

          MetricWidget(
            title: "प्राप्त गर्न बाँकी",
            icon: LucideIcons.download,
            color: Colors.orange,
            stream: salesController.getReceivableBalance(),
          ),
        ],
      ),
    );
  }
}
