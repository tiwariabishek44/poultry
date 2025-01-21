// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:poultry/app/constant/app_color.dart';
// import 'package:poultry/app/modules/egg_collection_add/egg_collection_controller.dart';
// import 'package:poultry/app/widget/batch_drop_down.dart';
// import 'package:poultry/app/widget/custom_input_field.dart';
// import 'package:poultry/app/widget/egg_category_dropdown.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class EggCollectionPage extends StatefulWidget {
//   const EggCollectionPage({super.key});

//   @override
//   State<EggCollectionPage> createState() => _EggCollectionPageState();
// }

// class _EggCollectionPageState extends State<EggCollectionPage> {
//   final eggCollectionController = Get.put(EggsCollectionController());
//   final formKey = GlobalKey<FormState>();

//   // final cratesController = TextEditingController();
//   final remainingController = TextEditingController();

//   String? selectedCategory;
//   String? selectedSize;

//   @override
//   void dispose() {
//     cratesController.dispose();
//     remainingController.dispose();
//     super.dispose();
//   }

//   bool hasAtLeastOneValue() {
//     return (cratesController.text.isNotEmpty &&
//             int.tryParse(cratesController.text) != null) ||
//         (remainingController.text.isNotEmpty &&
//             int.tryParse(remainingController.text) != null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Record Egg Collection',
//           style: GoogleFonts.notoSansDevanagari(
//             color: Colors.white,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: AppColors.primaryColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(5.w),
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Select Batch (बैच चयन गर्नुहोस्)',
//                   style: GoogleFonts.notoSansDevanagari(
//                     fontSize: 15.sp,
//                     color: AppColors.textPrimary,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 BatchesDropDown(),
//                 SizedBox(height: 3.h),
//                 EggDropdowns(isCategory: true),
//                 SizedBox(height: 3.h),
//                 CustomInputField(
//                   label: 'Total Crates',
//                   hint: 'Enter number of crates',
//                   controller: cratesController,
//                   keyboardType: TextInputType.number,
//                   isNumber: true,
//                   validator: (value) {
//                     if (!hasAtLeastOneValue()) {
//                       return 'Please enter either crates or remaining eggs';
//                     }
//                     if (value != null && value.isNotEmpty) {
//                       if (int.tryParse(value) == null) {
//                         return 'Please enter a valid number';
//                       }
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 2.h),
//                 CustomInputField(
//                   label: 'Remaining Eggs (बाँकी अण्डा)',
//                   hint: 'Enter remaining eggs',
//                   controller: remainingController,
//                   keyboardType: TextInputType.number,
//                   isNumber: true,
//                   validator: (value) {
//                     if (!hasAtLeastOneValue()) {
//                       return 'Please enter either crates or remaining eggs';
//                     }
//                     if (value != null && value.isNotEmpty) {
//                       if (int.tryParse(value) == null) {
//                         return 'Please enter a valid number';
//                       }
//                       if (int.parse(value) >= 30) {
//                         return 'Remaining eggs should be less than 30';
//                       }
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 4.h),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 6.h,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       // focous restriction
//                       FocusManager.instance.primaryFocus?.unfocus();
//                       await Future.delayed(Duration(milliseconds: 100));

//                       if (formKey.currentState!.validate()) {
//                         eggCollectionController.createEggCollection(
//                           crates: cratesController.text.isEmpty
//                               ? "0"
//                               : cratesController.text,
//                           remaining: remainingController.text.isEmpty
//                               ? "0"
//                               : remainingController.text,
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'Save',
//                       style: GoogleFonts.notoSansDevanagari(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/egg_collection_add/egg_collection_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EggCollectionPage extends StatefulWidget {
  const EggCollectionPage({super.key});

  @override
  State<EggCollectionPage> createState() => _EggCollectionPageState();
}

class _EggCollectionPageState extends State<EggCollectionPage> {
  final eggCollectionController = Get.put(EggsCollectionController());
  final formKey = GlobalKey<FormState>();

  Widget _buildCategoryRow(
      String category,
      String nepaliText,
      TextEditingController cratesController,
      TextEditingController remainingController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color.fromARGB(255, 17, 17, 17).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$category ($nepaliText)',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      label: 'Crates',
                      hint: 'Enter crates',
                      controller: cratesController,
                      keyboardType: TextInputType.number,
                      isNumber: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: CustomInputField(
                      label: 'Remaining  (बाँकी अण्डा)',
                      hint: 'Enter remaining',
                      controller: remainingController,
                      keyboardType: TextInputType.number,
                      isNumber: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (int.parse(value) >= 30) {
                            return 'Should be less than 30';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
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

                // Category input rows
                _buildCategoryRow(
                  'Large Plus',
                  'ठूलो प्लस',
                  eggCollectionController.largePlusCratesController,
                  eggCollectionController.largePlusRemainingController,
                ),

                _buildCategoryRow(
                  'Large',
                  'ठूलो',
                  eggCollectionController.largeCratesController,
                  eggCollectionController.largeRemainingController,
                ),

                _buildCategoryRow(
                  'Medium',
                  'मध्यम',
                  eggCollectionController.mediumCratesController,
                  eggCollectionController.mediumRemainingController,
                ),

                _buildCategoryRow(
                  'Small',
                  'सानो',
                  eggCollectionController.smallCratesController,
                  eggCollectionController.smallRemainingController,
                ),

                _buildCategoryRow(
                  'Crack',
                  'चुकेको',
                  eggCollectionController.crackCratesController,
                  eggCollectionController.crackRemainingController,
                ),

                _buildCategoryRow(
                  'Waste',
                  'खेर गएको',
                  eggCollectionController.wasteCratesController,
                  eggCollectionController.wasteRemainingController,
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 8.h,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: ElevatedButton(
            onPressed: () async {
              // Focus restriction
              FocusManager.instance.primaryFocus?.unfocus();
              await Future.delayed(Duration(milliseconds: 100));

              if (formKey.currentState!.validate() &&
                  eggCollectionController.hasAtLeastOneEntry()) {
                eggCollectionController.createEggCollection();
              } else if (!eggCollectionController.hasAtLeastOneEntry()) {
                CustomDialog.showError(
                  message: 'कुनै पनि अण्डा Entry गरिएको छैन',
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
              'Save',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
