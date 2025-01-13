import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/activity_folder/batch_vaccine/batch_vaccine_controller.dart';
import 'package:poultry/appss/widget/batch_dropDown/batch_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VaccinateFlockPage extends StatelessWidget {
  // map of vacine
  final String vaccine;

  final TextEditingController flockController = TextEditingController();

  final TextEditingController flockAge = TextEditingController();

  final controller = Get.put(BatchVaccineController());
  final Rx<NepaliDateTime> selectedDate = NepaliDateTime.now().obs;

  VaccinateFlockPage({
    Key? key,
    required this.vaccine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Flock Vaccination',
          style: GoogleFonts.notoSansDevanagari(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVaccineInfo(),
              SizedBox(height: 4.h),
              _buildSectionCard(
                title: 'Select Batch',
                icon: LucideIcons.layers,
                child: BatchDropDown(),
              ),
              SizedBox(height: 4.h),
              _buildDatePicker(context),
              SizedBox(height: 3.h),
              _buildFlockInput(),
              SizedBox(height: 4.h),
              _flockAge(),
              SizedBox(height: 4.h),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vaccination Date',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(() => Row(
                  children: [
                    Icon(LucideIcons.calendar, color: Colors.grey[600]),
                    SizedBox(width: 3.w),
                    Text(
                      controller.formatNepaliDate(selectedDate.value),
                      style: GoogleFonts.notoSansDevanagari(fontSize: 14),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    NepaliDateTime? picked = await showMaterialDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Widget _buildVaccineInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vaccine,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFlockInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Flock ',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: flockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter flock count ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(LucideIcons.bird),
          ),
        ),
      ],
    );
  }

  Widget _flockAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flock Age in day',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: flockAge,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter flock age in days',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(LucideIcons.calendar),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value ? null : _handleVaccination,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: Size(double.infinity, 6.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  'Confirm Vaccination',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ));
  }

  void _handleVaccination() {
    if (flockController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter flock Number',
          backgroundColor: Colors.red[400], colorText: Colors.white);
      return;
    }
    // age validate
    if (flockAge.text.isEmpty) {
      Get.snackbar('Error', 'Please enter flock age',
          backgroundColor: Colors.red[400], colorText: Colors.white);
      return;
    }

    final count = int.tryParse(flockController.text);
    if (count == null) {
      Get.snackbar('Error', 'Please enter a valid number',
          backgroundColor: Colors.red[400], colorText: Colors.white);
      return;
    }
    controller.addVaccine(
      vaccineName: vaccine,
      flockCount: count,
      age: flockAge.text,
      vaccinateDate: controller.formatNepaliDate(selectedDate.value),
    );

    Get.back();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.notoSansDevanagari(
              color: const Color.fromARGB(255, 54, 53, 53),
              fontSize: 14,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            value,
            style: GoogleFonts.notoSansDevanagari(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
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
}
