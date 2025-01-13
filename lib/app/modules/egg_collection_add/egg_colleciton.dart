import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/egg_collection_add/egg_collection_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/egg_category_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EggCollectionPage extends StatefulWidget {
  const EggCollectionPage({super.key});

  @override
  State<EggCollectionPage> createState() => _EggCollectionPageState();
}

class _EggCollectionPageState extends State<EggCollectionPage> {
  final eggCollectionController = Get.put(EggsCollectionController());
  final formKey = GlobalKey<FormState>();

  final cratesController = TextEditingController();
  final remainingController = TextEditingController();

  String? selectedCategory;
  String? selectedSize;

  @override
  void dispose() {
    cratesController.dispose();
    remainingController.dispose();
    super.dispose();
  }

  bool hasAtLeastOneValue() {
    return (cratesController.text.isNotEmpty &&
            int.tryParse(cratesController.text) != null) ||
        (remainingController.text.isNotEmpty &&
            int.tryParse(remainingController.text) != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Record Egg Collection',
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
                Text(
                  'Select Batch (बैच चयन गर्नुहोस्)',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                BatchesDropDown(),
                SizedBox(height: 3.h),
                EggDropdowns(isCategory: true),
                SizedBox(height: 3.h),
                CustomInputField(
                  label: 'Total Crates',
                  hint: 'Enter number of crates',
                  controller: cratesController,
                  keyboardType: TextInputType.number,
                  isNumber: true,
                  validator: (value) {
                    if (!hasAtLeastOneValue()) {
                      return 'Please enter either crates or remaining eggs';
                    }
                    if (value != null && value.isNotEmpty) {
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                CustomInputField(
                  label: 'Remaining Eggs (बाँकी अण्डा)',
                  hint: 'Enter remaining eggs',
                  controller: remainingController,
                  keyboardType: TextInputType.number,
                  isNumber: true,
                  validator: (value) {
                    if (!hasAtLeastOneValue()) {
                      return 'Please enter either crates or remaining eggs';
                    }
                    if (value != null && value.isNotEmpty) {
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (int.parse(value) >= 30) {
                        return 'Remaining eggs should be less than 30';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        eggCollectionController.createEggCollection(
                          crates: cratesController.text.isEmpty
                              ? "0"
                              : cratesController.text,
                          remaining: remainingController.text.isEmpty
                              ? "0"
                              : remainingController.text,
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
                      'Record Collection',
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
