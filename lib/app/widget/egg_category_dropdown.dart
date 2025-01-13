import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Controller for managing state
class EggDropdownController extends GetxController {
  final selectedCategory = 'normal'.obs;
  final selectedSize = 'medium'.obs;

  void updateCategory(String category) {
    selectedCategory!.value = category;
  }

  void updateSize(String size) {
    selectedSize!.value = size;
  }
}

class EggDropdowns extends StatelessWidget {
  final bool isCategory; // Control whether to show category selection

  EggDropdowns({Key? key, this.isCategory = true}) : super(key: key);

  final EggDropdownController controller = Get.put(EggDropdownController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Conditionally show category selection
        if (isCategory) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Egg Category',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 15.sp,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1.h,
              crossAxisSpacing: 2.w,
              childAspectRatio: 2,
              //'normal', 'crack', 'waste'
            ),
            itemCount: [
              'small',
              'medium',
              'large',
              'large_plus',
              'crack',
              'waste'
            ].length,
            itemBuilder: (context, index) {
              final category = [
                'small',
                'medium',
                'large',
                'large_plus',
                'crack',
                'waste'
              ][index];
              return Obx(() => ChoiceChip(
                    label: Text(
                      category.toUpperCase(),
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: controller.selectedCategory!.value == category
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: controller.selectedCategory!.value == category,
                    onSelected: (selected) {
                      if (selected) {
                        controller.updateCategory(category);
                      }
                    },
                    shape: StadiumBorder(
                      side: BorderSide(
                        color:
                            Color.fromARGB(255, 132, 134, 138).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: AppColors.surfaceColor,
                  ));
            },
          ),
          SizedBox(height: 2.h),
        ],

        // Egg Size Dropdown
        // RichText(
        //   text: TextSpan(
        //     children: [
        //       TextSpan(
        //         text: 'Egg Size',
        //         style: GoogleFonts.notoSansDevanagari(
        //           fontSize: 15.sp,
        //           color: AppColors.textPrimary,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //       TextSpan(
        //         text: ' *',
        //         style: GoogleFonts.notoSansDevanagari(
        //           fontSize: 15.sp,
        //           color: AppColors.error,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 1.h),

        // GridView.builder(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3,
        //     mainAxisSpacing: 1.h,
        //     crossAxisSpacing: 0.5.w,
        //     childAspectRatio: 2.4,
        //   ),
        //   itemCount: ['small', 'medium', 'large', 'large_plus'].length,
        //   itemBuilder: (context, index) {
        //     final category = ['small', 'medium', 'large', 'large_plus'][index];
        //     return Obx(() => ChoiceChip(
        //           label: Text(
        //             category.toUpperCase(),
        //             style: GoogleFonts.notoSansDevanagari(
        //               fontSize: 16.sp,
        //               color: controller.selectedSize!.value == category
        //                   ? Colors.white
        //                   : AppColors.textPrimary,
        //             ),
        //           ),
        //           selected: controller.selectedSize!.value == category,
        //           onSelected: (selected) {
        //             if (selected) {
        //               controller.updateSize(category);
        //             }
        //           },
        //           shape: StadiumBorder(
        //             side: BorderSide(
        //               color:
        //                   Color.fromARGB(255, 132, 134, 138).withOpacity(0.5),
        //               width: 1,
        //             ),
        //           ),
        //           selectedColor: AppColors.primaryColor,
        //           backgroundColor: AppColors.surfaceColor,
        //         ));
        //   },
        // ),
      ],
    );
  }
}
