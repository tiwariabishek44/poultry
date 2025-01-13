// monthly_report_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/modules/analytics_page/analytics_controller.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';
import 'package:poultry/app/modules/report_generator/report_generator.dart';
import 'package:poultry/app/repository/batch_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';
import 'package:poultry/app/widget/monthly_report/egg_report_view.dart';
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
    setState(() {});
    log('Select year month : $date');
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
          FloatingActionButton(
            onPressed: () {
              // Add your report action here
              // Get.to(()=>DynamicReportPage(reportData: reportData))
            },
            child: Icon(LucideIcons.file),
            heroTag: null,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              // Add your filter action here
              showDialog(
                context: context,
                builder: (context) => FilterDialog(
                  onDateSelected: _onDateSelected,
                ),
              );
            },
            child: Icon(Icons.filter_list),
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
        return Center(child: Text('Select a category'));
    }
  }
}
