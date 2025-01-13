
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButtons extends StatelessWidget {
  final String partyPhone;
  final String partyId;

  const ContactButtons({
    Key? key,
    required this.partyPhone,

    required this.partyId
  }) : super(key: key);

  void _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }

  void _sendMessage(String platform, String message, String phone) {
    final phoneNumber = phone.replaceAll(RegExp(r'[^\d+]'), '');
    String url;
    
    switch (platform) {
      case 'whatsapp':
        url = 'https://wa.me/977$phoneNumber?text=${Uri.encodeComponent(message)}';
        break;
      case 'sms':
        url = 'sms:$phoneNumber?body=${Uri.encodeComponent(message)}';
        break;
      default:
        url = 'sms:$phoneNumber';
    }

    launchUrl(Uri.parse(url)).catchError((_) {
      Get.snackbar(
        'Error',
        'Could not open $platform',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }

  void _showMessageOptions() {
    Get.bottomSheet(
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('parties')
            .doc(partyId)
            .snapshots(),
        builder: (context, snapshot) {
          final creditAmount = snapshot.hasData 
              ? (snapshot.data?.get('creditAmount') ?? 0).toDouble()
              : 0.0;
          
          final messageText = creditAmount > 0
              ? 'नमस्कार, तपाईंको बाँकी रकम ₹${_formatAmount(creditAmount.toInt())} छ। कृपया भुक्तानी गर्नुहोस्।'
              : 'नमस्कार, कसरी सहयोग गर्न सक्छु?';

          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('सन्देश पठाउनुहोस्', style: AppTheme.titleLarge),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(messageText, style: AppTheme.bodyLarge),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MessageOption(
                      platform: 'whatsapp',
                      label: 'WhatsApp',
                      onTap: () => _sendMessage('whatsapp', messageText, partyPhone),
                    ),
                    MessageOption(
                      platform: 'sms',
                      label: 'SMS',
                      onTap: () => _sendMessage('sms', messageText, partyPhone),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ContactButton(
            icon: Icons.call,
            backgroundColor: Colors.blue,
            onTap: () => _launchUrl('tel:+977$partyPhone'),
          ),
          SizedBox(width: 3.w),
          ContactButton(
            icon: Icons.message,
            backgroundColor: Colors.orange,
            onTap: _showMessageOptions,
          ),
        ],
      ),
    );
  }
}

// Extracted contact button component
class ContactButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ContactButton({
    Key? key,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 4.w,
        ),
      ),
    );
  }
}

// Message option button component
class MessageOption extends StatelessWidget {
  final String platform;
  final String label;
  final VoidCallback onTap;

  const MessageOption({
    Key? key,
    required this.platform,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              platform == 'whatsapp' ? LucideIcons.messageCircle : LucideIcons.mail,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
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