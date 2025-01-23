import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/item_rate_response_model.dart';
import 'package:poultry/app/modules/item_rates/item_rate_page.dart';
import 'package:poultry/app/modules/item_rates/item_rates_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:shimmer/shimmer.dart';

class FeedSelectionGrid extends StatelessWidget {
  final controller = Get.put(FeedRateController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemsRateResponseModel>>(
      stream: controller.streamFeedRates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid();
        }

        final existingRates = snapshot.data ?? [];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color.fromARGB(255, 132, 134, 138).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Feed Type (दाना प्रकार)',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 16.sp,
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
                    TextButton(
                      onPressed: () {
                        Get.to(() => FeedRatePage());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 66, 147, 68),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 8,
                        ),
                      ),
                      child: Text(
                        existingRates.length > 0 ? 'Edit' : 'Add Rate',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16.sp,
                          color: AppColors.surfaceColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1.h,
                    crossAxisSpacing: 2.w,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: existingRates.length,
                  itemBuilder: (context, index) {
                    final item = existingRates[index];
                    return Obx(() => ChoiceChip(
                          label: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              item.itemName,
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 16.sp,
                                color: controller.selectedFeedType.value ==
                                        item.itemName
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          selected: controller.selectedFeedType.value ==
                              item.itemName,
                          onSelected: (selected) {
                            if (selected) {
                              controller.updateFeedType(
                                  item.itemName, item.rate);
                            }
                          },
                          selectedColor: AppColors.primaryColor,
                          backgroundColor: AppColors.surfaceColor,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Color.fromARGB(255, 132, 134, 138)
                                  .withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ));
                  },
                ),
                SizedBox(height: 2.h),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          Color.fromARGB(255, 132, 134, 138).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Rate (रेट)',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            'Rs. ${controller.selectedFeedRate.value}',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 16.sp,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
