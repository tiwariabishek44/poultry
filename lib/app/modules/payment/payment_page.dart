import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/modules/payment/payment_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentRecordPage extends StatelessWidget {
  final PartyResponseModel party;
  final PaymentController controller = Get.put(PaymentController());
  final numberFormat = NumberFormat("#,##,###");

  PaymentRecordPage({
    Key? key,
    required this.party,
  }) : super(key: key) {
    controller.totalCredit.value = party.creditAmount;
    controller.isCustomer.value = party.partyType == 'customer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 70,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Center(
        child: Material(
          color: const Color.fromARGB(255, 232, 231, 231),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Get.back(),
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                LucideIcons.chevronLeft,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Record Payment',
        style: GoogleFonts.inter(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 24),
          _buildPaymentDetailsCard(),
          const SizedBox(height: 24),
          // _buildNotesCard(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(const Duration(milliseconds: 100));
                    controller.recordPayment(
                      party.partyId!,
                      party.creditAmount,
                      party.partyName,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.isLoading.value)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(LucideIcons.checkCircle2, size: 18),
                const SizedBox(width: 8),
                Text(
                  controller.isLoading.value ? 'Processing...' : 'Save Payment',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildHeaderCard() {
    final isCustomer = controller.isCustomer.value;
    final statusColor =
        isCustomer ? const Color.fromARGB(255, 6, 113, 200) : Colors.teal;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.user,
                    size: 20,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            party.partyName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isCustomer ? 'Customer' : 'Supplier',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCustomer ? 'To Receive' : 'To Pay',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rs. ${numberFormat.format(party.creditAmount)}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.wallet,
                  size: 18,
                  color: Colors.purple.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Details',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDateInput(),
          const SizedBox(height: 20),
          _buildAmountInput(),
          const SizedBox(height: 16),
          _buildRemainingAmount(),
        ],
      ),
    );
  }

  Widget _buildDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Date (भुक्तानी मिति)',
          style: GoogleFonts.inter(
            fontSize: 15.5.sp,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => controller.pickDate(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 197, 197, 197)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.calendar,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 12),
                Text(
                  controller.dateController.text.isEmpty
                      ? 'Select date'
                      : controller.dateController.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: controller.dateController.text.isEmpty
                        ? Colors.black38
                        : Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Amount(भुक्तानी रकम)',
          style: GoogleFonts.inter(
            fontSize: 15.5.sp,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.amountController,
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.calculateRemainingAmount(),
          validator: (value) =>
              controller.validateAmount(value, party.creditAmount),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromARGB(255, 175, 173, 173)),
              ),
              child: Text(
                'Rs.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            hintText: 'Enter amount',
            hintStyle: GoogleFonts.inter(
              color: Colors.black38,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 149, 147, 147)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 173, 171, 171)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 159, 157, 157)),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildRemainingAmount() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remaining (बाँकी रकम)',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      'Rs. ${numberFormat.format(controller.remainingAmount.value)}',
                      style: GoogleFonts.inter(
                        fontSize: 16.5.sp,
                        fontWeight: FontWeight.w600,
                        color: controller.remainingAmount.value > 0
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: controller.remainingAmount.value > 0
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(() => Text(
                  controller.remainingAmount.value > 0
                      ? 'Partial Payment'
                      : 'Full Payment',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: controller.remainingAmount.value > 0
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return TextFormField(
      controller: controller.notesController,
      maxLines: 4,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        hintText: 'Enter notes',
        hintStyle: GoogleFonts.inter(
          color: Colors.black38,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
