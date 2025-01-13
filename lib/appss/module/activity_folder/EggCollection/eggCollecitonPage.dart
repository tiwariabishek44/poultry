import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/activity_folder/EggCollection/eggCollectionContorller.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class EggCollectionScreen extends StatelessWidget {
  EggCollectionScreen({Key? key}) : super(key: key);
  final controller = Get.put(EggCollectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          'Egg Collection',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Wave decoration
            Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Batch Selection Card
                  _buildSectionCard(
                    title: 'Select Batch',
                    icon: LucideIcons.layers,
                    child: BatchDropDown(),
                  ),

                  SizedBox(height: 3.h),

                  // Egg Type Selection
                  _buildSectionCard(
                    title: 'Egg Type',
                    icon: LucideIcons.egg,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => _buildSelectionButton(
                                    title: 'Normal',
                                    icon: LucideIcons.checkCircle,
                                    isSelected:
                                        controller.eggType.value == 'normal',
                                    onTap: () =>
                                        controller.eggType.value = 'normal',
                                  )),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Obx(() => _buildSelectionButton(
                                    title: 'Crack',
                                    icon: LucideIcons.alertCircle,
                                    isSelected:
                                        controller.eggType.value == 'crack',
                                    onTap: () =>
                                        controller.eggType.value = 'crack',
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Egg Category Selection
                  _buildSectionCard(
                    title: 'Egg Size',
                    icon: LucideIcons.ruler,
                    child: Obx(() => Wrap(
                          spacing: 2.w,
                          runSpacing: 2.w,
                          children: [
                            _buildCategoryChip(
                              title: 'Small',
                              isSelected:
                                  controller.eggCategory.value == 'small',
                              onTap: () =>
                                  controller.eggCategory.value = 'small',
                            ),
                            _buildCategoryChip(
                              title: 'Medium',
                              isSelected:
                                  controller.eggCategory.value == 'medium',
                              onTap: () =>
                                  controller.eggCategory.value = 'medium',
                            ),
                            _buildCategoryChip(
                              title: 'Large',
                              isSelected:
                                  controller.eggCategory.value == 'large',
                              onTap: () =>
                                  controller.eggCategory.value = 'large',
                            ),
                            _buildCategoryChip(
                              title: 'Extra Large',
                              isSelected:
                                  controller.eggCategory.value == 'extra large',
                              onTap: () =>
                                  controller.eggCategory.value = 'extra large',
                            ),
                          ],
                        )),
                  ),

                  SizedBox(height: 3.h),

                  // Quantity Input Section
                  _buildSectionCard(
                    title: 'मात्रा विवरण',
                    icon: LucideIcons.clipboardList,
                    child: Column(
                      children: [
                        _buildQuantityInput(
                          label: 'कुल क्रेट्स',
                          controller: controller.crateController,
                          icon: LucideIcons.package,
                        ),
                        SizedBox(height: 2.h),
                        _buildQuantityInput(
                          label: 'खुद्रा अण्डा',
                          controller: controller.remainingEggsController,
                          icon: LucideIcons.egg,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Submit Button
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(Get.context!).unfocus();

                      controller.submitCollection();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 6.5.h,
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.save,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Save Collection',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 4.w),
              width: 4.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              SizedBox(width: 2.w),
              Text(
                title,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          child,
        ],
      ),
    );
  }

  Widget _buildSelectionButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 1.h),
              Text(
                title,
                style: GoogleFonts.notoSansDevanagari(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.h,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            style: GoogleFonts.notoSansDevanagari(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: GoogleFonts.notoSansDevanagari(
          fontSize: 15,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.notoSansDevanagari(
            color: Colors.black,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'कृपया $label हाल्नुहोस्';
          }
          if (int.tryParse(value) == null) {
            return 'मान्य संख्या हाल्नुहोस्';
          }
          return null;
        },
      ),
    );
  }
}
