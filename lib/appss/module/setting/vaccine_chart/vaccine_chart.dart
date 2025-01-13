import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/module/activity_folder/batch_vaccine/vaccine_complete.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Vaccine Model (Keep existing model)
class VaccineModel {
  String? id;
  String name;
  int flockAge;
  String monthRange;

  VaccineModel({
    this.id,
    required this.name,
    required this.flockAge,
    required this.monthRange,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flockAge': flockAge,
      'monthRange': monthRange,
    };
  }

  factory VaccineModel.fromMap(Map<String, dynamic> map, String id) {
    return VaccineModel(
      id: id,
      name: map['name'],
      flockAge: map['flockAge'],
      monthRange: map['monthRange'],
    );
  }
}

// Updated Controller with Reactive State
class VaccineController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedMonthRange = ''.obs;
  final vaccines = <VaccineModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVaccines();
  }

  Future<void> fetchVaccines() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('vaccines').get();
      final fetchedVaccines = snapshot.docs
          .map((doc) => VaccineModel.fromMap(doc.data(), doc.id))
          .toList();

      // Sort vaccines by flockAge
      fetchedVaccines.sort((a, b) => a.flockAge.compareTo(b.flockAge));
      vaccines.value = fetchedVaccines;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch vaccines: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<VaccineModel> get filteredVaccines {
    if (selectedMonthRange.isEmpty) return vaccines;
    return vaccines
        .where((vaccine) => vaccine.monthRange == selectedMonthRange.value)
        .toList();
  }

  void setMonthRange(String range) {
    selectedMonthRange.value = range;
  }

  void clearFilter() {
    selectedMonthRange.value = '';
  }
}

// Updated UI with Modern Design
class VaccineChartPage extends GetView<VaccineController> {
  VaccineChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VaccineController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Vaccine Chart',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() => controller.selectedMonthRange.isNotEmpty
              ? IconButton(
                  icon: Icon(LucideIcons.x, color: Colors.white),
                  onPressed: controller.clearFilter,
                )
              : SizedBox()),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vaccine List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerEffect();
              }

              final vaccines = controller.filteredVaccines;
              if (vaccines.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.alertCircle,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No vaccines found',
                        style: GoogleFonts.notoSansDevanagari(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: vaccines.length,
                itemBuilder: (context, index) {
                  final vaccine = vaccines[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        // Handle vaccine selection
                        Get.to(() => VaccinateFlockPage(
                              vaccine: vaccine.name,
                            ));
                      },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          LucideIcons.syringe,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        vaccine.name,
                        style: GoogleFonts.notoSansDevanagari(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.5.h),
                          Text(
                            'Flock Standard Age : ${vaccine.flockAge} days',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color.fromARGB(255, 34, 33, 33),
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        ),
      ),
    );
  }
}
