// filter dialouge.dart

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

// floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await showDialog(
//             context: context,
//             builder: (context) => FilterDialog(
//               onDateSelected: _onDateSelected,
//             ),
//           );
//           if (result != null) {
//             // Handle filter results
//             setState(() {
//               reportController.selectedBatch.value =
//                   result['batch'] as BatchResponseModel;
//               reportController.selectedDate.value =
//                   result['date'] as NepaliDateTime;
//               log(" the date is ${reportController.selectedDate.value}");
//             });
//           }
//         },
//         child: Icon(Icons.filter_list),
//       ),

class FilterController extends GetxController {
  final _batchRepository = BatchRepository();
  final _loginController = Get.find<LoginController>();

  final batches = <BatchResponseModel>[].obs;
  final selectedBatch = Rxn<BatchResponseModel>();
  final selectedDate = NepaliDateTime.now().obs;
  final finalDate = ''.obs; // Final date in "YYYY-MM" format
  final isLoading = false.obs;
  final isAllBatchesSelected =
      true.obs; // New variable to track "All" selection
  final selectedBatchId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
    // Initialize with current Nepali month
    selectedDate.value = NepaliDateTime.now();
    updateFinalDate();
    log(" this is he final date ${finalDate.value}");
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
  }

  void selectAllBatches() {
    selectedBatch.value = null;
    isAllBatchesSelected.value = true;
    selectedBatchId.value = '';
  }

  void updateFinalDate() {
    finalDate.value =
        '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}';
  }
}

class FilterDialog extends StatelessWidget {
  final Function(String) onDateSelected;
  final FilterController controller = Get.put(FilterController());
  FilterDialog({
    Key? key,
    required this.onDateSelected,
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
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Batch Selection
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Batch',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18.sp,
                  color: const Color.fromARGB(255, 32, 33, 34),
                ),
              ),
            ),
            SizedBox(height: 8),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final activeBatches =
                  controller.batches.where((batch) => batch.isActive).toList();

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // "All" option
                  ChoiceChip(
                    label: Text('All'),
                    selected: controller.isAllBatchesSelected.value,
                    onSelected: (selected) {
                      if (selected) controller.selectAllBatches();
                    },
                    selectedColor: AppColors.primaryColor,
                    labelStyle: GoogleFonts.notoSansDevanagari(
                      color: controller.isAllBatchesSelected.value
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  ...activeBatches.map((batch) {
                    final isSelected =
                        controller.selectedBatch.value?.batchId ==
                            batch.batchId;
                    return ChoiceChip(
                      label: Text(batch.batchName),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) controller.selectBatch(batch);
                      },
                      backgroundColor: Color.fromARGB(31, 90, 87, 87),
                      selectedColor: AppColors.primaryColor,
                      labelStyle: GoogleFonts.notoSansDevanagari(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    );
                  }).toList(),
                ],
              );
            }),

            Divider(
              height: 32,
              color: Colors.grey,
            ),

            // Month Selection
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Month',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18.sp,
                  color: Color.fromARGB(255, 24, 25, 26),
                ),
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(nepaliMonths.length, (index) {
                    final isSelected =
                        controller.selectedDate.value.month == index + 1;
                    return ChoiceChip(
                      label: Text(nepaliMonths[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedDate.value = NepaliDateTime(
                            controller.selectedDate.value.year,
                            index + 1,
                            1,
                          );
                          controller.updateFinalDate();
                        }
                      },
                      selectedColor: AppColors.primaryColor,
                      backgroundColor: Color.fromARGB(31, 90, 87, 87),
                      labelStyle: GoogleFonts.notoSansDevanagari(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    );
                  }),
                )),

            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    controller.clearFilters();
                    Navigator.pop(context);
                  },
                  child: Text('Clear'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (!controller.isAllBatchesSelected.value &&
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
                  ),
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
