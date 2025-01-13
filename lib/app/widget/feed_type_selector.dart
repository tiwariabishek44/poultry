import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Controller for managing feed selection state
class FeedTypeSelectorController extends GetxController {
  final selectedFeedType = ''.obs;

  void updateFeedType(String type) {
    selectedFeedType.value = type;
  }
}

class FeedTypeSelector extends StatelessWidget {
  FeedTypeSelector({Key? key}) : super(key: key);

  final FeedTypeSelectorController controller =
      Get.put(FeedTypeSelectorController());
  final List<String> feedTypes = ['L0', 'L1', 'L2', 'PL', 'L3'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Select Feed Type (दाना प्रकार)',
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
          itemCount: feedTypes.length,
          itemBuilder: (context, index) {
            final type = feedTypes[index];
            return Obx(() => ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      type,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: controller.selectedFeedType.value == type
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  selected: controller.selectedFeedType.value == type,
                  onSelected: (selected) {
                    if (selected) {
                      controller.updateFeedType(type);
                    }
                  },
                  selectedColor: AppColors.primaryColor,
                  backgroundColor: AppColors.surfaceColor,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color:
                          Color.fromARGB(255, 132, 134, 138).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ));
          },
        ),
      ],
    );
  }
}
