import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/feed_consumption/feed_consumption_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:poultry/app/widget/feed_selection.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedConsumptionPage extends StatefulWidget {
  const FeedConsumptionPage({super.key});

  @override
  State<FeedConsumptionPage> createState() => _FeedConsumptionPageState();
}

class _FeedConsumptionPageState extends State<FeedConsumptionPage> {
  final feedConsumptionController = Get.put(FeedConsumptionController());
  final formKey = GlobalKey<FormState>();

  final quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Record Feed Consumption',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BatchesDropDown(),
                SizedBox(height: 3.h),

                FeedSelectionGrid(),
                SizedBox(height: 3.h),

                // Quantity Input
                CustomInputField(
                  label: 'Quantity in KG (दाना मात्रा)',
                  hint: 'Enter quantity in KG',
                  controller: quantityController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                DateSelectorWidget(
                  label: 'Date (मिति)',
                  showCard: false,
                  hint: 'Choose a date',
                ),
                SizedBox(height: 3.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      // Small delay to ensure keyboard is dismissed
                      await Future.delayed(Duration(milliseconds: 100));
                      if (formKey.currentState!.validate()) {
                        feedConsumptionController.createFeedConsumption(
                          quantityKg: quantityController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Feed Consumption',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
