import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/activity_folder/waste/wasteController.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WasteEggCollectionScreen extends StatelessWidget {
  WasteEggCollectionScreen({Key? key}) : super(key: key);
  final controller = Get.put(WasteEggCollectionController());

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
          'Egg Waste Records',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Batch Details',
                    icon: LucideIcons.layers,
                    child: BatchDropDown(),
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    title: 'Category',
                    icon: LucideIcons.ruler,
                    child: Obx(() => Wrap(
                          // Changed this line
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
                  _buildSection(
                    title: 'Collection Details',
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
                  Container(
                    width: double.infinity,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.red.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.submitCollection,
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
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
                                'Save Record',
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
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
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
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              SizedBox(width: 2.w),
              Text(
                title,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
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
            color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: GoogleFonts.notoSansDevanagari(
          fontSize: 15,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.notoSansDevanagari(
            color: Colors.black54,
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
          contentPadding: EdgeInsets.all(4.w),
        ),
      ),
    );
  }
}
