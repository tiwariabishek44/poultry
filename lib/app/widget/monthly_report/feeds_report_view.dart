import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/modules/monthly_report/monthly_report_controller.dart';

class FeedsReportView extends StatelessWidget {
  final controller = Get.put(MonthlyReportController());

  @override
  Widget build(BuildContext context) {
    controller.fetchFeedConsumptions();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.error.value != null) {
        return Center(child: Text(controller.error.value!));
      }

      if (controller.collections.isEmpty) {
        return Center(child: Text('No egg collections found'));
      }

      return ListView.builder(
        itemCount: controller.feedConsumptions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text("${index}"),
          );
        },
      );
    });
  }
}
