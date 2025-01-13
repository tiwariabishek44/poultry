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
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddPurchasePage extends StatelessWidget {
  final controller = Get.put(PurchaseController());
  final PartyResponseModel party;

  AddPurchasePage({
    required this.party,
  });

  @override
  Widget build(BuildContext context) {
    controller.partyId.value = party.partyId!;
    controller.partyCurrentCredit.value = party.creditAmount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'New Purchase',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPartyCard(),
              SizedBox(height: 2.h),
              _buildItemsSection(),
              SizedBox(height: 2.h),
              _buildAmountCard(),
              SizedBox(height: 2.h),
              _buildNotesCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPartyCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.users, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'Party Details',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                radius: 6.w,
                child: Text(
                  party.partyName[0].toUpperCase(),
                  style: GoogleFonts.inter(
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.partyName,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      party.phoneNumber,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
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

  Widget _buildItemsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.shoppingCart, color: AppColors.primaryColor),
                  SizedBox(width: 2.w),
                  Text(
                    'Purchase Items',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () async {
                  final PurchaseItem? result =
                      await Get.to(() => AddPurchaseItemsPage());
                  if (result != null) {
                    controller.addPurchaseItem(result);
                  }
                },
                icon: Icon(LucideIcons.plus, color: AppColors.primaryColor),
                label: Text(
                  'Add Item',
                  style: GoogleFonts.notoSansDevanagari(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildItemsList(),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Obx(() {
      if (controller.selectedItems.isEmpty) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Add Purchase Items',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 17.sp,
                color: const Color.fromARGB(255, 43, 43, 43),
              ),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.selectedItems.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.dividerColor,
          height: 2.h,
        ),
        itemBuilder: (context, index) {
          final item = controller.selectedItems[index];
          return Dismissible(
            key: Key(item.itemName + index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                LucideIcons.trash2,
                color: Colors.red[600],
              ),
            ),
            onDismissed: (_) => controller.removePurchaseItem(index),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.itemName.toUpperCase(),
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.category.toUpperCase(),
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                if (item.subcategory != null) ...[
                                  SizedBox(width: 1.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.subcategory!.toUpperCase(),
                                      style: GoogleFonts.notoSansDevanagari(
                                        fontSize: 12.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.removePurchaseItem(index),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.x,
                            color: Colors.red[600],
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.scale,
                            size: 16.sp,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${NumberFormat("#,##0.##").format(item.quantity)}${item.unit != null ? ' ${item.unit}' : ''} × Rs. ${NumberFormat("#,##0.##").format(item.rate)}',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Rs. ${NumberFormat("#,##,###").format(item.total)}',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (item.description != null) ...[
                    SizedBox(height: 1.h),
                    Text(
                      item.description!,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAmountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.wallet, color: AppColors.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'Payment Details',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Obx(() => Text(
                    'Rs. ${NumberFormat("#,##,###").format(controller.totalAmount.value)}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            controller: controller.invoiceNumber,
            label: 'Invoice Number',
            hint: 'Enter invoice number if available',
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            controller: controller.paidAmount,
            label: 'Amount Paid',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.onPaidAmountChanged(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              final amount = double.tryParse(value);
              if (amount == null) return 'Invalid amount';
              if (amount > controller.totalAmount.value)
                return 'Cannot exceed total amount';
              return null;
            },
          ),
          SizedBox(height: 2.h),
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
                  'Balance Due',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Obx(() => Text(
                      'Rs. ${NumberFormat("#,##,###").format(controller.dueAmount.value)}',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: controller.dueAmount > 0
                            ? Colors.red[700]
                            : Colors.green[700],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            controller: controller.notes,
            hint: 'Add any additional notes here...',
            maxLines: 3,
            label: 'Write Any Notes',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
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
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: () async {
            // Focus restriction
            FocusManager.instance.primaryFocus?.unfocus();

            // Small delay to ensure keyboard is dismissed
            await Future.delayed(Duration(milliseconds: 100));

            controller.createPurchaseRecord();
          },
          icon: Icon(LucideIcons.checkCircle2, color: Colors.white),
          label: Text(
            'Create Purchase',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
