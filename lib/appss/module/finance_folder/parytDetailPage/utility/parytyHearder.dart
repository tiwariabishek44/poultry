import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/module/finance_folder/paryty_payment_history/payment_history_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PartyHeader extends StatelessWidget {
  final String partyName;
  final String companyName;
  final String partyId;
  final String partyPhone;
  final VoidCallback onBack;

  const PartyHeader({
    Key? key,
    required this.partyName,
    required this.companyName,
    required this.partyId,
    required this.partyPhone,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CreditAmountDisplay(partyId: partyId),
                      // ContactButtons(partyPhone: partyPhone, partyId: partyId),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () =>
                        Get.to(() => PaymentHistoryPage(partyId: partyId)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.history, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "Payment History",
                          style:
                              AppTheme.titleMedium.copyWith(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreditAmountDisplay extends StatelessWidget {
  final String partyId;

  const CreditAmountDisplay({
    Key? key,
    required this.partyId,
  }) : super(key: key);

  String _formatAmount(int amount) {
    String amountString = amount.toString();
    if (amountString.length <= 3) {
      return amountString;
    }
    String lastThree = amountString.substring(amountString.length - 3);
    String remaining = amountString.substring(0, amountString.length - 3);
    String formattedRemaining = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+\$)'),
      (Match match) => '${match.group(1)},',
    );
    return '$formattedRemaining,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parties')
          .doc(partyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transction: ',
                    style: AppTheme.titleMedium.copyWith(color: Colors.black),
                  ),
                  Text(
                    '₹ 00',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final creditAmount =
            (snapshot.data?.get('creditAmount') ?? 0).toDouble();
        final phoneNumber = snapshot.data?.get('phone') ?? '';

        Future<void> _launchWhatsApp(String message) async {
          final whatsappUrl = Uri.parse(
              'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
          if (await canLaunchUrl(whatsappUrl)) {
            await launchUrl(whatsappUrl);
          } else {
            throw 'Could not launch WhatsApp';
          }
        }

        Future<void> _sendSMS(String message) async {
          final smsUrl = Uri.parse(
              'sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
          if (await canLaunchUrl(smsUrl)) {
            await launchUrl(smsUrl);
          } else {
            throw 'Could not send SMS';
          }
        }

        Future<void> _makeCall() async {
          final callUrl = Uri.parse('tel:$phoneNumber');
          if (await canLaunchUrl(callUrl)) {
            await launchUrl(callUrl);
          } else {
            throw 'Could not make a call';
          }
        }

        String message = creditAmount > 0
            ? "I have received ₹ ${_formatAmount(creditAmount.toInt())} from you."
            : "Hello! This is a general message.";
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                creditAmount > 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Recive: ',
                              style: AppTheme.titleMedium
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              '₹ ${_formatAmount(creditAmount.toInt())}',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(
                                  width: 8), // Spacing between icon and text
                              Text(
                                'Settled',
                                style: AppTheme.titleMedium.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹ 0.00',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 12), // Spacing between sections
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(() => PaymentHistoryPage(partyId: partyId));
                    //   },
                    //   child: Container(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: [
                    //           Icon(
                    //             Icons.history,
                    //             color:
                    //                 Colors.blue, // Adjust icon color as needed
                    //             size: 20,
                    //           ),
                    //           SizedBox(
                    //               width: 8), // Spacing between icon and text
                    //           Text(
                    //             'Payment History',
                    //             style: AppTheme.bodyMedium.copyWith(
                    //               fontSize: 16.sp,
                    //               color: Colors.blue,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Spacer(),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.whatsapp),
                      onPressed: () => _launchWhatsApp(message),
                    ),
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () => _sendSMS(message),
                    ),
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: _makeCall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
