import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/model/purchase_repsonse_model.dart';
import 'package:poultry/app/modules/add_purchase/add_purchase_controller.dart';
import 'package:poultry/app/modules/add_purchase/add_purchase_item.dart';
import 'package:poultry/app/widget/batch_drop_down.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:poultry/app/widget/date_select_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddPurchasePage extends StatelessWidget {
  final controller = Get.put(PurchaseController());
  final PartyResponseModel party;
  final dateSelectorController = Get.put(DateSelectorController());

  AddPurchasePage({super.key, required this.party}) {
    controller.partyId.value = party.partyId!;
    controller.partyCurrentCredit.value = party.creditAmount;
    controller.partyName.value = party.partyName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 234, 234),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 64,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(LucideIcons.chevronLeft,
                  color: Colors.black87, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          'New Purchase',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPartyCard(),
              const SizedBox(height: 20),
              _buildPurchaseTypeSelector(),
              const SizedBox(height: 20),
              _buildItemsSection(),
              const SizedBox(height: 20),
              _buildPaymentDetails(),
              const SizedBox(height: 20),
              // _buildNotes(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPartyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Icon(
                LucideIcons.users,
                size: 18,
                color: Colors.black45,
              ),
              const SizedBox(width: 8),
              Text(
                'Supplier Details',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    party.partyName[0].toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.partyName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.phone,
                          size: 14,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          party.phoneNumber,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.package,
                    size: 18,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Purchase Type',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Batch',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Switch.adaptive(
                      value: controller.purchaseType.value == 'batch',
                      onChanged: (value) {
                        controller.purchaseType.value =
                            value ? 'batch' : 'general';
                      },
                      activeColor: AppColors.primaryColor,
                      activeTrackColor: AppColors.primaryColor.withOpacity(0.2),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(() {
            if (controller.purchaseType.value == 'batch') {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: BatchesDropDown(isDropDown: true),
              );
            }
            return Container();
          })
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final result = await Get.to(() => AddPurchaseItemsPage());
                  if (result != null) {
                    controller.addPurchaseItem(result);
                  }
                },
                icon: const Icon(
                  LucideIcons.plus,
                  size: 18,
                ),
                label: const Text('Add Item'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildItemsList(),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Obx(() {
      if (controller.selectedItems.isEmpty) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 222, 221, 221),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(" खरिद वस्तुहरू थप्नुहोस्",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black,
                )),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.selectedItems.length,
        separatorBuilder: (_, __) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final item = controller.selectedItems[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.package,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat("#,##0.##").format(item.quantity)}${item.unit != null ? ' ${item.unit}' : ''} × Rs. ${NumberFormat("#,##0.##").format(item.rate)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                    if (item.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.alignLeft,
                              size: 14,
                              color: Colors.black45,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.description!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Rs. ${NumberFormat("#,##,###").format(item.total)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => controller.removePurchaseItem(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: 14,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Payment Details',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                TextSpan(
                  text: '     *',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // golden color
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount (कुल रकम)',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Obx(() => Text(
                    'Rs. ${NumberFormat("#,##,###").format(controller.totalAmount.value)}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 2.h),
          Divider(
            color: Color.fromARGB(255, 207, 207, 207),
            thickness: 1,
          ),
          SizedBox(height: 2.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Payment Details  (भुक्तानी रकम)',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: controller.paidAmount,
            keyboardType: TextInputType.number,
            onChanged: controller.onPaidAmountChanged,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              final amount = double.tryParse(value);
              if (amount == null) return 'Invalid amount';
              if (amount > controller.totalAmount.value)
                return 'Cannot exceed total amount';
              return null;
            },
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Amount Paid (भुक्तानी रकम)',
              labelStyle: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.black,
              ),
              hintText: 'Enter amount',
              hintStyle: GoogleFonts.inter(
                color: Colors.black38,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 178, 176, 176)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 180, 179, 179)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 182, 180, 180)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade200),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance Due',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                Obx(() => Text(
                      'Rs. ${NumberFormat("#,##,###").format(controller.dueAmount.value)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: controller.dueAmount.value > 0
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DateSelectorWidget(
            label: 'Purchase Date',
            showCard: false,
            hint: 'Select date',
          ),
        ],
      ),
    );
  }

  // Widget _buildNotes() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.03),
  //           blurRadius: 10,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Additional Notes',
  //           style: GoogleFonts.inter(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         TextFormField(
  //           controller: controller.notes,
  //           maxLines: 3,
  //           style: GoogleFonts.inter(fontSize: 14),
  //           decoration: InputDecoration(
  //             hintText: 'Add any notes here...',
  //             hintStyle: GoogleFonts.inter(
  //               color: Colors.black38,
  //             ),
  //             filled: true,
  //             fillColor: Colors.grey.shade50,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12),
  //               borderSide: BorderSide(color: Colors.grey.shade200),
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12),
  //               borderSide: BorderSide(color: Colors.grey.shade200),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12),
  //               borderSide: BorderSide(color: Colors.grey.shade300),
  //             ),
  //             contentPadding: const EdgeInsets.all(16),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 100));
            controller.createPurchaseRecord(
              dateSelectorController.dateController.text,
              dateSelectorController.selectedMonthYear.value,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.checkCircle2, size: 18),
              const SizedBox(width: 8),
              Text(
                'Save ',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
