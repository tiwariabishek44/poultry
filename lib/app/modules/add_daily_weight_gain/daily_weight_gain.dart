import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_daily_weight_gain/daily_weight_gain_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddDailyWeightPage extends StatelessWidget {
  final controller = Get.put(DailyWeightGainController());
  final weightController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Daily Weight',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BatchesDropDown(),

            SizedBox(height: 2.h),
            DateSelectorWidget(
              label: 'Select  Date',
              showCard: false,
              hint: 'Choose a date',
            ),

            SizedBox(height: 2.h),

            SizedBox(height: 2.h),
            // Weight Input
            CustomInputField(
              label: 'Daily Weight Gain (वजन ग्राममा राख्नुहोस्)',
              hint: 'Enter average weight',
              controller: weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 4.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();

                  // Small delay to ensure keyboard is dismissed
                  await Future.delayed(Duration(milliseconds: 100));

                  final weight = double.tryParse(weightController.text) ?? 0.0;

                  controller.createDailyWeightGain(
                    weight: weight,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
