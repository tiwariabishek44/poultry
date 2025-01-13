import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/finance_main_screen/utility/partySection.dart';
import 'package:poultry/appss/module/finance_folder/salse_metrics/salse_metrics.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FinanceTab extends StatelessWidget {
  FinanceTab({Key? key}) : super(key: key);

  final int activeParties = 45;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: PartySection(),
        ),
      ],
    );
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            SalseMetrics(
                yearMonth:
                    NepaliDateTime.now().toIso8601String().substring(0, 7)),
          ],
        ),
      ),
    );
  }
}
