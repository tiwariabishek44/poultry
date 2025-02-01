import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/flock_death/flock_death_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:poultry/app/widget/death_cause_drop_down.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FlockDeathPage extends StatelessWidget {
  FlockDeathPage({super.key});

  final flockDeathController = Get.put(FlockDeathController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Mortality Record',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          tooltip: 'पछाडि जानुहोस्',
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Form(
            key: flockDeathController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),

                BatchesDropDown(), SizedBox(height: 3.h),

                // Death Details Card
                _buildDeathDetailsCard(),
                SizedBox(height: 3.h),
                DateSelectorWidget(
                  label: 'Date (मिति)',
                  showCard: false,
                  hint: 'Choose a date',
                ),
                SizedBox(height: 3.h),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentFlockInfo() {
    return Obx(() => Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                icon: LucideIcons.bird,
                label: 'हालको :',
                value:
                    '${flockDeathController.batchesDropDownController.currentFlockCount}',
              ),
              if (flockDeathController
                      .batchesDropDownController.totalDeath.value >
                  0) ...[
                Divider(height: 3.h),
                _buildInfoRow(
                  icon: LucideIcons.alertTriangle,
                  label: 'जम्मा मृत्यु:',
                  value:
                      '${flockDeathController.batchesDropDownController.totalDeath.value}',
                  valueColor: Colors.red,
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildDeathDetailsCard() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'मृत्युको विवरण',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            label: 'मृत्यु संख्या',
            hint: 'मृत   संख्या लेख्नुहोस्',
            controller: flockDeathController.deathCountController,
            keyboardType: TextInputType.number,
            isNumber: true,
            prefix: Icon(LucideIcons.alertCircle, color: Colors.red),
            validator: flockDeathController.validateDeathCount,
          ),
          SizedBox(height: 2.h),
          Divider(
            color: Colors.grey,
          ),
          Text(
            'मृत्युको कारण',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          DeathCauseDropdown(),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20.sp),
        SizedBox(width: 3.w),
        Text(
          label,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            color: valueColor ?? AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: () {
          if (flockDeathController.formKey.currentState!.validate()) {
            flockDeathController.recordFlockDeath(
              deathCount: flockDeathController.deathCountController.text,
              notes: flockDeathController.notesController.text.isEmpty
                  ? null
                  : flockDeathController.notesController.text,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
        icon: Icon(LucideIcons.checkCircle2, color: Colors.white),
        label: Text(
          'Save',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
