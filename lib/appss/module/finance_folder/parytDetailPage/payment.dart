import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:poultry/appss/widget/showSuccessWidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreditPaymentPage extends StatelessWidget {
  final String partyId;
  final String partyName;
  final String salesId;
  final String saleType; // 'eggSales', 'henSales', or 'manureSales'

  CreditPaymentPage({
    Key? key,
    required this.partyId,
    required this.partyName,
    required this.salesId,
    required this.saleType,
  }) : super(key: key);

  final paymentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String get collectionName {
    switch (saleType) {
      case 'henSales':
        return 'henSales';
      case 'manureSales':
        return 'manureSales';

      case 'purchase':
        return 'purchases';
      default:
        return 'eggSales';
    }
  }

  String get paymentType {
    switch (saleType) {
      case 'henSales':
        return 'hen_credit_payment';
      case 'manureSales':
        return 'manure_credit_payment';

      case 'purchase':
        return 'purchases_credit_payment';
      default:
        return 'egg_credit_payment';
    }
  }

  String _formatAmount(int amount) {
    String amountString = amount.toString();
    if (amountString.length <= 3) return amountString;
    String lastThree = amountString.substring(amountString.length - 3);
    String remaining = amountString.substring(0, amountString.length - 3);
    String formattedRemaining = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (Match match) => '${match.group(1)},',
    );
    return '$formattedRemaining,$lastThree';
  }

  final loginController = Get.find<PoultryLoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(7.h),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
          ),
          title: Text('भुक्तानी',
              style: AppTheme.titleLarge.copyWith(color: Colors.white)),
          elevation: 0,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collectionName)
            .doc(salesId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final creditAmount =
              (snapshot.data?.get('creditAmount') ?? 0.0).toDouble();

          return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Party Info Card
                  Container(
                    padding: EdgeInsets.all(4.w),
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.1),
                          child: Text(
                            partyName.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              partyName,
                              style: AppTheme.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'ग्राहक कोड: #${partyId.substring(0, 6)}.......',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Credit Amount Card
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.wallet,
                                    color: Colors.red, size: 20),
                                SizedBox(width: 2.w),
                                Text(
                                  'बाँकी रकम',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Rs. " + _formatAmount(creditAmount.toInt()),
                              style: AppTheme.titleLarge.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Payment Input Section
                  Container(
                    padding: EdgeInsets.all(4.w),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'भुक्तानी रकम हाल्नुहोस्',
                          style: AppTheme.titleMedium,
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: paymentController,
                          keyboardType: TextInputType.number,
                          style: AppTheme.titleMedium,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTheme.backgroundLight,
                            prefixIcon: Icon(LucideIcons.wallet,
                                color: AppTheme.primaryColor),
                            hintText: 'रकम लेख्नुहोस्',
                            hintStyle: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.textLight,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'कृपया रकम हाल्नुहोस्';
                            }
                            final payment = double.tryParse(value!) ?? 0;
                            if (payment <= 0) {
                              return 'रकम शून्य भन्दा बढी हुनुपर्छ';
                            }
                            if (payment > creditAmount) {
                              return 'रकम बाँकी रकम भन्दा बढी हुन सक्दैन';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
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
        child: ElevatedButton(
          onPressed: () => _submitPayment(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'भुक्तानी पेश गर्नुहोस्',
            style: AppTheme.titleMedium.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _submitPayment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'भुक्तानी प्रक्रियामा छ...'),
        ),
        barrierDismissible: false,
      );

      final payment = double.parse(paymentController.text);
      final adminUid = loginController.adminData.value?.uid;
      if (adminUid == null) {
        Get.back();
        Get.snackbar('Error', 'Admin data not found');
        return;
      }
      // Start a transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Read operations first
        final partyDoc = await transaction
            .get(FirebaseFirestore.instance.collection('parties').doc(partyId));

        final saleDoc = await transaction.get(
            FirebaseFirestore.instance.collection(collectionName).doc(salesId));

        // Calculate new credit amounts
        final currentPartyCreditAmount =
            (partyDoc.get('creditAmount') ?? 0.0).toDouble();
        final newPartyCreditAmount = currentPartyCreditAmount - payment;

        final currentSaleCreditAmount =
            (saleDoc.get('creditAmount') ?? 0.0).toDouble();
        final newSaleCreditAmount = currentSaleCreditAmount - payment;
        final currentPaidAmount = (saleDoc.get('paidAmount') ?? 0.0).toDouble();

        // Write operations
        transaction.update(
            FirebaseFirestore.instance.collection('parties').doc(partyId), {
          'creditAmount': newPartyCreditAmount,
          'isCredit': newPartyCreditAmount > 0,
        });

        // Update admin's cash and receivable amounts
        transaction.update(
            FirebaseFirestore.instance.collection('admins').doc(adminUid), {
          'cash': FieldValue.increment(payment),
          'amountReceivable': FieldValue.increment(-payment),
        });

        // Update sale credit and paid amount in the correct collection
        transaction.update(
            FirebaseFirestore.instance.collection(collectionName).doc(salesId),
            {
              'creditAmount': newSaleCreditAmount,
              'paidAmount': currentPaidAmount + payment,
            });

        if (saleType == 'purchase') {
          final paymentRef =
              FirebaseFirestore.instance.collection('payments').doc();
          transaction.set(paymentRef, {
            'paymentId': paymentRef.id,
            'partyId': partyId,
            'purchaseId': salesId,
            'partyName': partyName,
            'amount': payment,
            'paymentType': paymentType,
            'date': formatNepaliDate(NepaliDateTime.now()),
            'createdAt': NepaliDateTime.now().toIso8601String(),
          });
        } else {
          final paymentRef =
              FirebaseFirestore.instance.collection('payments').doc();
          transaction.set(paymentRef, {
            'paymentId': paymentRef.id,
            'partyId': partyId,
            'saleId': salesId,
            'partyName': partyName,
            'amount': payment,
            'paymentType': paymentType,
            'date': formatNepaliDate(NepaliDateTime.now()),
            'createdAt': NepaliDateTime.now().toIso8601String(),
          });
        }
        ;
      });

      Get.back(); // Close loading dialog

      await SuccessDialog.show(
        title: 'भुक्तानी सफल !',
        subtitle: '''
भुक्तानी रकम: ₹${payment.toStringAsFixed(2)}
ग्राहकको नाम: $partyName''',
        additionalInfo: '''
मिति: ${formatNepaliDate(NepaliDateTime.now())}''',
        onButtonPressed: () {
          Get.back(); // Close success dialog
          Get.back(); // Go back to previous screen
        },
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      log('Error submitting payment: $e');
      Get.snackbar(
        'त्रुटि',
        'भुक्तानी प्रक्रिया असफल भयो',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
