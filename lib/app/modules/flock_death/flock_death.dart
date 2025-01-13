import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/flock_death/flock_death_controller.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/death_cause_drop_down.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FlockDeathPage extends StatefulWidget {
  const FlockDeathPage({super.key});

  @override
  State<FlockDeathPage> createState() => _FlockDeathPageState();
}

class _FlockDeathPageState extends State<FlockDeathPage> {
  final flockDeathController = Get.put(FlockDeathController());
  final formKey = GlobalKey<FormState>();

  final deathCountController = TextEditingController();
  final causeController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    deathCountController.dispose();
    causeController.dispose();
    notesController.dispose();
    super.dispose();
  }

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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Flock Info Card

                // Batch Selection
                _buildBatchSelection(),
                SizedBox(height: 3.h),

                // Death Details Card
                _buildDeathDetailsCard(),
                SizedBox(height: 3.h),

                // Notes Section
                _buildNotesSection(),
                SizedBox(height: 4.h),

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
                label: 'हालको   संख्या:',
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

  Widget _buildBatchSelection() {
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
          Row(
            children: [
              Icon(LucideIcons.bird, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'बैच चयन गर्नुहोस्',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          BatchesDropDown(),
          SizedBox(height: 3.h),
          _buildCurrentFlockInfo(),
        ],
      ),
    );
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
            controller: deathCountController,
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

  Widget _buildNotesSection() {
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
          Row(
            children: [
              Icon(LucideIcons.pencil, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'थप टिप्पणीहरू',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'कुनै अतिरिक्त टिप्पणीहरू लेख्नुहोस्',
            controller: notesController,
            maxLines: 3,
            suffix: Icon(Icons.description, color: AppColors.primaryColor),
            label: 'Notes :',
          ),
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
          if (formKey.currentState!.validate()) {
            flockDeathController.recordFlockDeath(
              deathCount: deathCountController.text,
              notes: notesController.text.isEmpty ? null : notesController.text,
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
