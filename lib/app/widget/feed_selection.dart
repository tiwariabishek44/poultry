import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedSelectionGrid extends StatelessWidget {
  final controller = Get.put(FeedTypeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Feed Type (दाना प्रकार)',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 15.sp,
                      color: Colors.red,
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
                childAspectRatio: 2.3,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                final feedTypes = ['B-0', 'B-1', 'B-2'];
                return Obx(() => ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          feedTypes[index],
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16.sp,
                            color: controller.selectedFeedType.value ==
                                    feedTypes[index]
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                      selected:
                          controller.selectedFeedType.value == feedTypes[index],
                      onSelected: (selected) {
                        if (selected) {
                          controller.updateFeedType(feedTypes[index]);
                        }
                      },
                      selectedColor: AppColors.primaryColor,
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeedTypeController extends GetxController {
  var selectedFeedType = ''.obs;

  void updateFeedType(String type) {
    selectedFeedType.value = type;
  }
}
