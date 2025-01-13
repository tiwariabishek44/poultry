import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.notoSansDevanagari(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.contact_support_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get in Touch',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re here to help and answer any questions you might have',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Contact Options
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Email Card
                  _buildContactCard(
                    context,
                    icon: Icons.email_outlined,
                    title: 'Email Us',
                    subtitle: 'tiwariabishek44@gmail.com',
                    onTap: () => _launchEmail('tiwariabishek44@gmail.com'),
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[900]!],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Phone Numbers Card
                  _buildContactCard(
                    context,
                    icon: Icons.phone_outlined,
                    title: 'Call Us',
                    subtitle: '9742555741\n9742555743',
                    onTap: () => _showPhoneOptions(context),
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[900]!],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // WhatsApp Card
                  _buildContactCard(
                    context,
                    icon: Icons.message_outlined,
                    title: 'WhatsApp',
                    subtitle: '9742555741',
                    onTap: () => _launchWhatsApp('9742555741'),
                    gradient: LinearGradient(
                      colors: [Colors.teal[700]!, Colors.teal[900]!],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Viber Card
                  _buildContactCard(
                    context,
                    icon: Icons.message_outlined,
                    title: 'Viber',
                    subtitle: '9742555741',
                    onTap: () => _launchViber('9742555741'),
                    gradient: LinearGradient(
                      colors: [Colors.purple[700]!, Colors.purple[900]!],
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

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        // onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhoneOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Call Us',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('9742555741'),
              onTap: () => _launchPhone('9742555741'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('9742555743'),
              onTap: () => _launchPhone('9742555743'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch email client',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch phone app',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse('whatsapp://send?phone=+977$phone');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch WhatsApp',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _launchViber(String phone) async {
    final Uri viberUri = Uri.parse('viber://chat?number=$phone');
    if (await canLaunchUrl(viberUri)) {
      await launchUrl(viberUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch Viber',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:poultry/appss/config/constant.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ContactUsPage extends StatelessWidget {
//   final String phoneNumber = '+9779845408829';
//   final String message = 'Hello dude, are you ok?';

//   Future<void> _launchWhatsApp() async {
//     final whatsappUrl = Uri.parse(
//         'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
//     if (await canLaunchUrl(whatsappUrl)) {
//       await launchUrl(whatsappUrl);
//     } else {
//       throw 'Could not launch WhatsApp';
//     }
//   }

//   Future<void> _sendSMS() async {
//     final smsUrl =
//         Uri.parse('sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
//     if (await canLaunchUrl(smsUrl)) {
//       await launchUrl(smsUrl);
//     } else {
//       throw 'Could not send SMS';
//     }
//   }

//   Future<void> _makeCall() async {
//     final callUrl = Uri.parse('tel:$phoneNumber');
//     if (await canLaunchUrl(callUrl)) {
//       await launchUrl(callUrl);
//     } else {
//       throw 'Could not make a call';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Communication Page'),
//       ),
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               icon:
//                   const Icon(Icons.wechat_sharp, color: Colors.green, size: 40),
//               onPressed: _launchWhatsApp,
//             ),
//             IconButton(
//               icon: const Icon(Icons.message, color: Colors.blue, size: 40),
//               onPressed: _sendSMS,
//             ),
//             IconButton(
//               icon: const Icon(Icons.phone, color: Colors.red, size: 40),
//               onPressed: _makeCall,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
