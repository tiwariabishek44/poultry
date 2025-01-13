import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'About Us',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  Icon(
                    LucideIcons.egg,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Poultry Management System',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: GoogleFonts.notoSansDevanagari(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'About The App',
                    'Our comprehensive poultry management system helps farmers streamline their operations and maximize productivity. With intuitive features and robust tracking capabilities, we make poultry farm management easier than ever.',
                  ),
                  _buildFeaturesList(),
                  _buildSection(
                    'Developer',
                    'Developed with ❤️ by Business IT Partners\n\nWe specialize in creating innovative solutions for agricultural businesses.',
                  ),
                  // _buildSection(
                  //   'Contact Us',
                  //   'Email: support@businessitpartners.com\nWebsite: www.businessitpartners.com',
                  // ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      '© 2024 Business IT Partners. All rights reserved.',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildSection(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      _Feature(
        icon: LucideIcons.layers,
        title: 'Batch Management',
        description:
            'Track and manage multiple batches of poultry with detailed records',
      ),
      _Feature(
        icon: LucideIcons.egg,
        title: 'Egg Collection',
        description:
            'Record and monitor daily egg collection with quality tracking',
      ),
      _Feature(
        icon: LucideIcons.trash2,
        title: 'Waste Management',
        description: 'Monitor and track waste for better resource optimization',
      ),
      _Feature(
        icon: LucideIcons.alertCircle,
        title: 'Mortality Tracking',
        description: 'Keep accurate records of mortality rates and causes',
      ),
      _Feature(
        icon: LucideIcons.receipt,
        title: 'Sales Management',
        description:
            'Track sales, generate invoices, and manage customer accounts',
      ),
      _Feature(
        icon: LucideIcons.users,
        title: 'Party Management',
        description:
            'Manage relationships with vendors, customers, and partners',
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Features',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => _buildFeatureItem(feature)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(_Feature feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature.icon,
              size: 20,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: GoogleFonts.notoSansDevanagari(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
} 
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:poultry/appss/config/constant.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AboutUsPage extends StatelessWidget {
//   const AboutUsPage({Key? key}) : super(key: key);

//   void _launchUrl(String url) async {
//     try {
//       await launchUrl(Uri.parse(url));
//     } catch (e) {
//       Get.snackbar('त्रुटि', '$url खोल्न सकिएन');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppTheme.primaryColor,
//                 AppTheme.primaryColor.withOpacity(0.8),
//               ],
//             ),
//           ),
//         ),
//         title: Text(
//           'हाम्रो बारेमा',
//           style: GoogleFonts.notoSansDevanagari(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // App Info Section with Logo
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppTheme.primaryColor,
//                     AppTheme.primaryColor.withOpacity(0.8),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: 2.h),
//                   // Logo Container
//                   Container(
//                     width: 25.w,
//                     height: 25.w,
//                     padding: EdgeInsets.all(4.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Icon(
//                           LucideIcons.egg,
//                           size: 12.w,
//                           color: AppTheme.primaryColor,
//                         ),
//                         Positioned(
//                           bottom: 1.w,
//                           right: 1.w,
//                           child: Icon(
//                             LucideIcons.bird,
//                             size: 8.w,
//                             color: AppTheme.primaryColor.withOpacity(0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     'पोल्ट्री म्यानेजर',
//                     style: GoogleFonts.notoSansDevanagari(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 0.5.h),
//                   Text(
//                     'संस्करण १.०.०',
//                     style: GoogleFonts.notoSansDevanagari(
//                       fontSize: 14,
//                       color: Colors.white.withOpacity(0.9),
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                 ],
//               ),
//             ),

//             // Content Sections
//             Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(4.w),
//                 child: Column(
//                   children: [
//                     _buildInfoSection(
//                       icon: LucideIcons.info,
//                       title: 'एप बारे',
//                       content: 'पोल्ट्री म्यानेजर तपाईंको कुखुरा फार्म व्यवस्थापनको लागि एक व्यापक समाधान हो। हाम्रो सजिलो इन्टरफेसको साथ अण्डा संकलन ट्र्याक गर्नुहोस्, ब्याचहरू व्यवस्थापन गर्नुहोस्, खर्चहरू अनुगमन गर्नुहोस्।',
//                     ),
                    
//                     _buildInfoSection(
//                       icon: LucideIcons.layers,
//                       title: 'विशेषताहरू',
//                       content: '''• ब्याच व्यवस्थापन
// • अण्डा संकलन ट्र्याकिङ
// • मृत्यु रेकर्ड व्यवस्थापन
// • खर्च ट्र्याकिङ
// • बहु फार्म समर्थन
// • रियल-टाइम डाटा सिंक
// • नेपाली मिति प्रणाली''',
//                     ),
                    
//                     _buildInfoSection(
//                       icon: LucideIcons.code,
//                       title: 'डेभलपर',
//                       content: 'कृषि व्यवस्थापनको लागि नवीन समाधानहरू सिर्जना गर्न समर्पित टीम, पीके डिजिटल सोलुसन्स द्वारा विकसित।',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoSection({
//     required IconData icon,
//     required String title,
//     required String content,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 3.h),
//       padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.2),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: AppTheme.primaryColor, size: 20),
//               SizedBox(width: 3.w),
//               Text(
//                 title,
//                 style: GoogleFonts.notoSansDevanagari(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             content,
//             style: GoogleFonts.notoSansDevanagari(
//               fontSize: 14,
//               color: Colors.black54,
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
 