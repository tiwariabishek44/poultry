// monthly_report_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/egg_report_view.dart';
import 'package:poultry/app/widget/monthly_report/empty_report_widget.dart';
import 'package:poultry/app/widget/monthly_report/feeds_report_view.dart';
import 'package:poultry/app/widget/monthly_report/mortality_report_view.dart';
import 'package:poultry/app/widget/monthly_report/rice_husk_report_view.dart';
import 'package:poultry/app/widget/monthly_report/vaccine_report_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MonthlyReportPage extends StatefulWidget {
  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  final reportController = Get.put(MonthlyReportController());

  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    // Set initial date to current date in 'yy-mm' format
    _selectedDate = NepaliDateTime.now().toIso8601String().substring(0, 7);
  }

  // Method to format the Nepali Date to 'yy-mm'
  String _getFormattedDate(NepaliDateTime date) {
    return '${date.year.toString().substring(2)}-${(date.month).toString().padLeft(2, '0')}';
  }

  // Callback when a date is selected from the picker
  void _onDateSelected(String date) {
    setState(() {
      // Update the selected date
      _selectedDate = date;

      // Fetch data for the selected date
      reportController.fetchEggCollections();
      reportController.fetchFeedConsumptions();
      reportController.fetchMortalities();
      reportController.fetchRiceHusks();
      reportController.fetchVaccines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Report'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: reportController.items
                        .map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                backgroundColor:
                                    Color.fromARGB(255, 223, 222, 222),
                                label: Text(item),
                                selected:
                                    reportController.selectedItem.value == item,
                                onSelected: (selected) {
                                  if (selected)
                                    reportController.selectedItem.value = item;
                                },
                              ),
                            ))
                        .toList(),
                  )),
            ),
          ),
          Expanded(
            child:
                Obx(() => _buildContent(reportController.selectedItem.value)),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Replace your existing filter FloatingActionButton with this:
          FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(
                FilterBottomSheet(
                  onDateSelected: _onDateSelected,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: Icon(LucideIcons.filter),
            heroTag: null,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String selectedItem) {
    switch (selectedItem) {
      case 'Egg Collection':
        return EggReportView();
      case 'Feeds Consumption':
        return FeedsReportView();
      case 'Mortality':
        return MortalityReportView();
      case 'Vaccination':
        return VaccineReportView();
      case 'भुस Record':
        return RiceHuskReportView();
      default:
        return Center(
            child: EmptyStateWidget(
          icon: Icons.medication_outlined,
          title: 'No report found',
          message: '',
        ));
    }
  }
}
