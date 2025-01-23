import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/batch_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterController extends GetxController {
  final _batchRepository = BatchRepository();
  final _loginController = Get.find<LoginController>();

  final batches = <BatchResponseModel>[].obs;
  final selectedBatch = Rxn<BatchResponseModel>();
  final selectedDate = NepaliDateTime.now().obs;
  final finalDate = ''.obs;
  final isLoading = false.obs;
  final isAllBatchesSelected = true.obs;
  final selectedBatchName = ''.obs;
  final selectedBatchId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
    selectedDate.value = NepaliDateTime.now();
    updateFinalDate();
  }

  Future<void> fetchBatches() async {
    isLoading.value = true;
    try {
      final adminId = _loginController.adminUid;
      if (adminId != null) {
        final response = await _batchRepository.getAllBatches(adminId);
        if (response.status == ApiStatus.SUCCESS) {
          batches.value = response.response ?? [];
        }
      }
    } catch (e) {
      print('Error fetching batches: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilters() {
    selectedBatch.value = null;
    selectedDate.value = NepaliDateTime.now();
    isAllBatchesSelected.value = true;
    selectedBatchId.value = '';
    updateFinalDate();
  }

  void selectBatch(BatchResponseModel? batch) {
    selectedBatch.value = batch;
    selectedBatchId.value = batch?.batchId ?? '';
    isAllBatchesSelected.value = false;
    selectedBatchName.value = batch?.batchName ?? '';
  }

  void selectAllBatches() {
    selectedBatch.value = null;
    isAllBatchesSelected.value = true;
    selectedBatchId.value = '';
    selectedBatchName.value = 'All';
  }

  void updateFinalDate() {
    finalDate.value =
        '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}';
  }
}

class FilterBottomSheet extends StatelessWidget {
  final Function(String) onDateSelected;
  final bool showBatch;
  final bool showYear;
  final FilterController controller = Get.put(FilterController());

  FilterBottomSheet({
    Key? key,
    required this.onDateSelected,
    this.showBatch = true,
    this.showYear = true,
  }) : super(key: key);

  final nepaliMonths = [
    'Baishakh',
    'Jestha',
    'Ashadh',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 15.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.x),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBatch) ...[
                    Text(
                      'Select Batch',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final activeBatches = controller.batches
                          .where((batch) => batch.isActive)
                          .toList();
                      return Wrap(
                        spacing: 5.w,
                        runSpacing: 2.h,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.selectAllBatches();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 3.w),
                              decoration: BoxDecoration(
                                color: controller.isAllBatchesSelected.value
                                    ? AppColors.primaryColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'All',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: controller.isAllBatchesSelected.value
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          ...activeBatches.map((batch) {
                            final isSelected =
                                controller.selectedBatch.value?.batchId ==
                                    batch.batchId;
                            return GestureDetector(
                              onTap: () {
                                controller.selectBatch(batch);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  batch.batchName,
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }),
                    Divider(height: 4.h),
                  ],
                  if (showYear) ...[
                    Text(
                      'Select Year',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Obx(() => Wrap(
                          spacing: 5.w,
                          runSpacing: 2.h,
                          children: List.generate(12, (index) {
                            final year = 2078 + index;
                            final isSelected =
                                controller.selectedDate.value.year == year;
                            return GestureDetector(
                              onTap: () {
                                controller.selectedDate.value = NepaliDateTime(
                                  year,
                                  controller.selectedDate.value.month,
                                  1,
                                );
                                controller.updateFinalDate();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  year.toString(),
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        )),
                    Divider(height: 4.h),
                  ],
                  Text(
                    'Select Month',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Obx(() => Wrap(
                        spacing: 5.w,
                        runSpacing: 2.h,
                        children: List.generate(nepaliMonths.length, (index) {
                          final isSelected =
                              controller.selectedDate.value.month == index + 1;
                          return GestureDetector(
                            onTap: () {
                              controller.selectedDate.value = NepaliDateTime(
                                controller.selectedDate.value.year,
                                index + 1,
                                1,
                              );
                              controller.updateFinalDate();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 3.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                nepaliMonths[index],
                                style: GoogleFonts.notoSansDevanagari(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }),
                      )),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.primaryColor),
                    ),
                    child: Text(
                      'Clear',
                      style: GoogleFonts.notoSansDevanagari(
                        color: AppColors.primaryColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (showBatch &&
                          !controller.isAllBatchesSelected.value &&
                          controller.selectedBatch.value == null) {
                        Get.snackbar(
                          'Error',
                          'Please select a batch or "All"',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      onDateSelected(controller.finalDate.value);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.notoSansDevanagari(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
