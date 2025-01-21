// payment_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/modules/payment/payment_controller.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentRecordPage extends StatelessWidget {
  final PartyResponseModel party;
  final PaymentController controller = Get.put(PaymentController());

  PaymentRecordPage({
    Key? key,
    required this.party,
  }) : super(key: key);
  final numberFormat = NumberFormat("#,##,###");

  @override
  Widget build(BuildContext context) {
    controller.totalCredit.value = party.creditAmount;

    controller.isCustomer.value = party.partyType == 'customer' ? true : false;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Text(
            'Payment Record ',
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
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: EdgeInsets.all(5.w),
        children: [
          _buildPartyInfoCard(),
          SizedBox(height: 3.h),
          _buildDateSelection(),
          SizedBox(height: 3.h),
          _buildAmountInput(),
          SizedBox(height: 3.h),
          _buildNotesSection(),
          SizedBox(height: 4.h),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPartyInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: LucideIcons.user,
            label: 'Party:',
            value: party.partyName,
          ),
          Divider(height: 3.h),
          _buildInfoRow(
            icon: LucideIcons.wallet,
            label: controller.isCustomer.value ? 'To Recive:' : 'To Pay:',
            value: 'Rs. ${numberFormat.format(party.creditAmount)}',
            valueColor: AppColors.primaryColor,
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
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return CustomInputField(
      hint: 'Select Payment Date',
      controller: controller.dateController,
      prefix: Icon(LucideIcons.calendar, color: AppColors.primaryColor),
      onTap: () => controller.pickDate(),
      readOnly: true,
      label: 'Select Payment Date',
    );
  }

  Widget _buildAmountInput() {
    return Column(
      children: [
        CustomInputField(
          hint: 'Enter Payment Amount',
          controller: controller.amountController,
          keyboardType: TextInputType.number,
          validator: (value) =>
              controller.validateAmount(value, party.creditAmount),
          label: 'Enter Payment Amount',
          onChanged: (value) {
            controller.calculateRemainingAmount();
          },
        ),
        SizedBox(height: 2.h),
        // Add remaining amount display
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining Due',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Obx(() => Text(
                    'Rs. ${numberFormat.format(controller.remainingAmount.value)}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.remainingAmount.value > 0
                          ? Colors.red[700]
                          : Colors.green[700],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.pencil, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'Notes',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'Enter Notes...',
            controller: controller.notesController,
            maxLines: 3,
            label: 'Enter the Notes ',
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 6.h,
      child: Obx(() => ElevatedButton.icon(
            onPressed: () async {
              // Dismiss keyboard first
              FocusManager.instance.primaryFocus?.unfocus();

              // Small delay to ensure keyboard is dismissed
              await Future.delayed(Duration(milliseconds: 100));

              controller.isLoading.value
                  ? null
                  : controller.recordPayment(
                      party.partyId!, party.creditAmount, party.partyName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            icon: controller.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(LucideIcons.checkCircle2, color: Colors.white),
            label: Text(
              controller.isLoading.value ? 'Loading ...' : 'Save ',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
