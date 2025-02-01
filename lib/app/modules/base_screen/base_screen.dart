import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/base_screen/base_screen_controller.dart';
import 'package:poultry/app/modules/home_screen/dash.dart';
import 'package:poultry/app/modules/finance_main_page/finance_main_page.dart';
import 'package:poultry/app/modules/setting_page/setting_page.dart';
import 'package:poultry/app/modules/transction_main_screen/transction_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaseScreen extends StatelessWidget {
  final controller = Get.put(BaseScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              FarmDashboard(),
              FinanceMainScreen(),
              TransactionsScreen(),
              SettingPage(), // Add the More screen here
            ],
          )),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                height: 70, // Increase the height as needed
                child: BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.changeIndex,
                  backgroundColor: Colors.white,
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.textSecondary,
                  selectedLabelStyle: GoogleFonts.notoSansDevanagari(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.notoSansDevanagari(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.layoutDashboard),
                      label: 'Poultry',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.wallet),
                      label: 'Finance',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.creditCard),
                      label: 'Transaction',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.settings), // Icon for "More"
                      label: 'Setting',
                    ),
                  ],
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width / 4) *
                        controller.selectedIndex.value +
                    (MediaQuery.of(context).size.width / 8) -
                    10,
                bottom: 60,
                child: Container(
                  width: 20,
                  height: 3,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 

// class ProfilePage extends StatelessWidget {
//   // Dummy data - replace with actual data later
//   final Map<String, dynamic> userData = {
//     'name': 'John Doe',
//     'businessName': 'Doe Poultry Farm',
//     'email': 'john@example.com',
//     'phone': '+977 9876543210',
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F9),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//         title: Text(
//           'More',
//           style: GoogleFonts.inter(
//             color: Colors.black87,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildProfileSection(),
//             _buildSettingsSection(),
//             _buildSupportSection(),
//             const SizedBox(height: 20),
//             _buildLogoutButton(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     userData['name']![0],
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blue.shade700,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       userData['name']!,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       userData['businessName']!,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(LucideIcons.edit3),
//                 color: Colors.grey[700],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               'Settings',
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.bell,
//             title: 'Notifications',
//             onTap: () {},
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.languages,
//             title: 'Language',
//             subtitle: 'English',
//             onTap: () {},
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.palette,
//             title: 'Appearance',
//             subtitle: 'Light',
//             onTap: () {},
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.smartphone,
//             title: 'Device Settings',
//             onTap: () {
//               Get.to(() => DeviceSettingsPage());
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSupportSection() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               'Help & Support',
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.helpCircle,
//             title: 'Help Center',
//             onTap: () {},
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.messageCircle,
//             title: 'Contact Us',
//             onTap: () {},
//           ),
//           _buildSettingsTile(
//             icon: LucideIcons.info,
//             title: 'About',
//             subtitle: 'Version 1.0.0',
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsTile({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, size: 20, color: Colors.grey[700]),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 15.sp,
//                   color: Colors.grey[800],
//                 ),
//               ),
//             ),
//             if (subtitle != null) ...[
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               SizedBox(width: 4),
//             ],
//             Icon(
//               LucideIcons.chevronRight,
//               size: 20,
//               color: Colors.grey[400],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoutButton() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       child: InkWell(
//         onTap: () {
//           // Handle logout
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Ink(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.red.shade50,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 LucideIcons.logOut,
//                 size: 20,
//                 color: Colors.red.shade700,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 'Logout',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.red.shade700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DeviceSettingsPage extends StatelessWidget {
//   // Controller could be added here for managing settings state
//   final RxBool isNotificationsEnabled = true.obs;
//   final RxBool isLocationEnabled = false.obs;
//   final RxBool isAutoBackupEnabled = true.obs;
//   final RxBool isDataSaverEnabled = false.obs;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F9),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           icon: const Icon(LucideIcons.chevronLeft),
//           onPressed: () => Get.back(),
//           color: Colors.grey[800],
//         ),
//         title: Text(
//           'Device Settings',
//           style: GoogleFonts.inter(
//             color: Colors.black87,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildStorageSection(),
//             _buildNotificationSection(),
//             _buildDataSection(),
//             _buildPermissionsSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStorageSection() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(
//                   LucideIcons.hardDrive,
//                   size: 20,
//                   color: Colors.grey[700],
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Storage',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildStorageItem(
//             title: 'App Data',
//             usedSpace: '156 MB',
//             totalSpace: '500 MB',
//             percentage: 0.31,
//           ),
//           _buildStorageItem(
//             title: 'Cache',
//             usedSpace: '24 MB',
//             totalSpace: '100 MB',
//             percentage: 0.24,
//           ),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     // Handle clear cache
//                   },
//                   child: Text(
//                     'Clear Cache',
//                     style: TextStyle(
//                       color: Colors.blue[700],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStorageItem({
//     required String title,
//     required String usedSpace,
//     required String totalSpace,
//     required double percentage,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               Text(
//                 '$usedSpace / $totalSpace',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: percentage,
//               backgroundColor: Colors.grey[200],
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//               minHeight: 6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(
//                   LucideIcons.bell,
//                   size: 20,
//                   color: Colors.grey[700],
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Notifications',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildSettingsSwitch(
//             'Push Notifications',
//             'Receive alerts and reminders',
//             isNotificationsEnabled,
//           ),
//           _buildSettingsSwitch(
//             'Location Services',
//             'Allow app to access location',
//             isLocationEnabled,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDataSection() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(
//                   LucideIcons.database,
//                   size: 20,
//                   color: Colors.grey[700],
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Data Management',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildSettingsSwitch(
//             'Auto Backup',
//             'Backup data every 24 hours',
//             isAutoBackupEnabled,
//           ),
//           _buildSettingsSwitch(
//             'Data Saver',
//             'Reduce data usage',
//             isDataSaverEnabled,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPermissionsSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(
//                   LucideIcons.shield,
//                   size: 20,
//                   color: Colors.grey[700],
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'App Permissions',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildPermissionTile('Camera', 'Allowed'),
//           _buildPermissionTile('Storage', 'Allowed'),
//           _buildPermissionTile('Location', 'When in use'),
//           _buildPermissionTile('Contacts', 'Not allowed'),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsSwitch(
//     String title,
//     String subtitle,
//     RxBool value,
//   ) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Obx(
//             () => Switch.adaptive(
//               value: value.value,
//               onChanged: (newValue) => value.value = newValue,
//               activeColor: Colors.blue[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPermissionTile(String permission, String status) {
//     return InkWell(
//       onTap: () {
//         // Handle permission settings
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               permission,
//               style: TextStyle(
//                 fontSize: 15.sp,
//                 color: Colors.grey[800],
//               ),
//             ),
//             Row(
//               children: [
//                 Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 Icon(
//                   LucideIcons.chevronRight,
//                   size: 20,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class FarmDashboard extends StatelessWidget {
//   const FarmDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.1),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'January 2024',
//               style: TextStyle(
//                 color: Color(0xFF2D3748),
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               'Day 15',
//               style: TextStyle(
//                 color: const Color(0xFF718096),
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           BirdStatusCard(),
//           SizedBox(height: 16),
//           GrowthCard(),
//           SizedBox(height: 16),
//           FeedCard(),
//         ],
//       ),
//     );
//   }
// }

// class BirdStatusCard extends StatelessWidget {
//   const BirdStatusCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTitle('चल्ला स्थिति', 'Bird Status'),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: _buildMainMetric(
//                     'जीवित चल्ला',
//                     'Live Birds',
//                     '985',
//                     '/1000',
//                     true,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   flex: 2,
//                   child: _buildMainMetric(
//                     'मृत्यु',
//                     'Mortality',
//                     '15',
//                     '1.5%',
//                     false,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle(String nepali, String english) {
//     return Row(
//       children: [
//         Text(
//           nepali,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           '($english)',
//           style: const TextStyle(
//             fontSize: 14,
//             color: Color(0xFF718096),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMainMetric(
//     String nepaliLabel,
//     String englishLabel,
//     String value,
//     String suffix,
//     bool showProgress,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           nepaliLabel,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Color(0xFF718096),
//           ),
//         ),
//         Text(
//           englishLabel,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Color(0xFF9AA5B1),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.baseline,
//           textBaseline: TextBaseline.alphabetic,
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: showProgress
//                     ? const Color(0xFF3182CE)
//                     : const Color(0xFFE53E3E),
//               ),
//             ),
//             Text(
//               suffix,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF718096),
//               ),
//             ),
//           ],
//         ),
//         if (showProgress) ...[
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: 0.985,
//             backgroundColor: const Color(0xFFEBF8FF),
//             valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3182CE)),
//             minHeight: 6,
//           ),
//         ],
//       ],
//     );
//   }
// }

// class GrowthCard extends StatelessWidget {
//   const GrowthCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'वृद्धि स्थिति • Growth Status',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildGrowthMetric(
//                     'औसत तौल',
//                     'Weight',
//                     '250.0',
//                     'gm',
//                     '+2.5%',
//                     true,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildGrowthMetric(
//                     'दैनिक वृद्धि',
//                     'Daily Gain',
//                     '15.5',
//                     'gm',
//                     'Normal',
//                     false,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGrowthMetric(
//     String nepaliLabel,
//     String englishLabel,
//     String value,
//     String unit,
//     String status,
//     bool isPositive,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFEDF2F7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             nepaliLabel,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF718096),
//             ),
//           ),
//           Text(
//             englishLabel,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF9AA5B1),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 unit,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF718096),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedCard extends StatelessWidget {
//   const FeedCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'दाना व्यवस्थापन • Feed Management',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildFeedMetric(
//                     'आजको खपत',
//                     'Today\'s Feed',
//                     '45.5',
//                     'kg',
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildFeedMetric(
//                     'कुल खपत',
//                     'Total Feed',
//                     '450.0',
//                     'kg',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildFCR(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeedMetric(
//     String nepaliLabel,
//     String englishLabel,
//     String value,
//     String unit,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           nepaliLabel,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Color(0xFF718096),
//           ),
//         ),
//         Text(
//           englishLabel,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Color(0xFF9AA5B1),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.baseline,
//           textBaseline: TextBaseline.alphabetic,
//           children: [
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               unit,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF718096),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFCR() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEDF2F7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Text(
//                 'FCR',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '(दाना रूपान्तरण दर)',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF718096),
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFEDF2F7)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(
//                       Icons.arrow_downward,
//                       size: 12,
//                       color: Color(0xFF38A169),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       '2.3%',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF38A169),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const Text(
//                 '1.65',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF0FFF4),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   'Good Performance',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF38A169),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// // }





// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class FinanceCard extends StatelessWidget {
//   const FinanceCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 20),
//             _buildTotalExpense(),
//             const SizedBox(height: 20),
//             // _buildExpenseBreakdown(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEBF8FF),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.account_balance_wallet_outlined,
//                 color: Color(0xFF3182CE),
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'खर्च विवरण',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 Text(
//                   'Batch Expenses',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF718096),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE6FFFA),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: const Text(
//             'Day 15',
//             style: TextStyle(
//               color: Color(0xFF319795),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTotalExpense() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEBF8FF),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'कुल खर्च',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                   Text(
//                     'Total Expense',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF718096),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Text(
//                         'रु.',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF3182CE),
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         '145,250',
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF3182CE),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Color(0xFFE2E8F0)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: const [
//                     Text(
//                       'प्रति चल्ला',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF718096),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'रु. 147.46',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExpenseBreakdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: const [
//             Icon(
//               Icons.pie_chart_outline,
//               size: 16,
//               color: Color(0xFF718096),
//             ),
//             SizedBox(width: 8),
//             Text(
//               'खर्चको विवरण',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             SizedBox(width: 4),
//             Text(
//               '(Expense Details)',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF718096),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         _buildExpenseItem(
//           icon: Icons.shopping_bag_outlined,
//           label: 'दाना खर्च / Feed',
//           amount: '98,500',
//           color: const Color(0xFFF6E05E),
//         ),
//         _buildExpenseItem(
//           icon: Icons.egg_outlined,
//           label: 'चल्ला खर्च / Chicks',
//           amount: '35,000',
//           color: const Color(0xFF9AE6B4),
//         ),
//         _buildExpenseItem(
//           icon: Icons.medical_services_outlined,
//           label: 'औषधि खर्च / Medicine',
//           amount: '11,750',
//           color: const Color(0xFF90CDF4),
//         ),
//       ],
//     );
//   }

//   Widget _buildExpenseItem({
//     required IconData icon,
//     required String label,
//     required String amount,
//     required Color color,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFE2E8F0)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 size: 20,
//                 color: color.withOpacity(0.8),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF4A5568),
//                 ),
//               ),
//             ),
//             Text(
//               'रु. $amount',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ///
// /////////////////////////////////////
// ///
// ///
// ///
// ///

// //--------------------------------- 2nd part ------------------------------

// class FarmDashboard extends StatelessWidget {
//   const FarmDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 239, 238, 238),
//       appBar: _buildEnhancedAppBar(),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             // Implement refresh logic
//           },
//           child: CustomScrollView(
//             slivers: [
//               SliverPadding(
//                 padding: const EdgeInsets.all(16),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     SizedBox(height: 1.h),
//                     FinanceCard(),
//                     SizedBox(height: 1.h),
//                     const BirdStatusCard(),
//                     SizedBox(height: 1.h),
//                     const GrowthCard(),
//                     SizedBox(height: 1.h),
//                     const FeedCard(),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildEnhancedAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       scrolledUnderElevation: 2,
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'January 2024',
//             style: TextStyle(
//               color: Color(0xFF2D3748),
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 'Day 15',
//                 style: TextStyle(
//                   color: const Color(0xFF718096),
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE6FFFA),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   'Batch #A123',
//                   style: TextStyle(
//                     color: Color(0xFF319795),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: Stack(
//             children: [
//               const Icon(
//                 Icons.notifications_outlined,
//                 color: Color(0xFF2D3748),
//               ),
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE53E3E),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   constraints: const BoxConstraints(
//                     minWidth: 8,
//                     minHeight: 8,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.more_vert,
//             color: Color(0xFF2D3748),
//           ),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
// }

// class BirdStatusCard extends StatelessWidget {
//   const BirdStatusCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildEnhancedTitle(),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: _buildMainMetric(
//                     'जीवित चल्ला',
//                     'Live Birds',
//                     '985',
//                     '/1000',
//                     true,
//                     const Color(0xFF3182CE),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   flex: 2,
//                   child: _buildMainMetric(
//                     'मृत्यु',
//                     'Mortality',
//                     '15',
//                     '1.5%',
//                     false,
//                     const Color(0xFFE53E3E),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildTrend(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedTitle() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEBF8FF),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.pets_outlined,
//                 color: Color(0xFF3182CE),
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'चल्ला स्थिति',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 Text(
//                   'Bird Status',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF718096),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         PopupMenuButton<String>(
//           icon: const Icon(
//             Icons.more_horiz,
//             color: Color(0xFF718096),
//           ),
//           itemBuilder: (context) => [
//             const PopupMenuItem(
//               value: 'details',
//               child: Text('View Details'),
//             ),
//             const PopupMenuItem(
//               value: 'export',
//               child: Text('Export Data'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildMainMetric(
//     String nepaliLabel,
//     String englishLabel,
//     String value,
//     String suffix,
//     bool showProgress,
//     Color accentColor,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: showProgress ? const Color(0xFFEBF8FF) : const Color(0xFFFFF5F5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             nepaliLabel,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           Text(
//             englishLabel,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF718096),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.baseline,
//             textBaseline: TextBaseline.alphabetic,
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: accentColor,
//                 ),
//               ),
//               Text(
//                 suffix,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF718096),
//                 ),
//               ),
//             ],
//           ),
//           if (showProgress) ...[
//             const SizedBox(height: 12),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(4),
//               child: LinearProgressIndicator(
//                 value: 0.985,
//                 backgroundColor: Colors.white,
//                 valueColor: AlwaysStoppedAnimation<Color>(accentColor),
//                 minHeight: 8,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTrend() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Weekly Trend',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF718096),
//             ),
//           ),
//           Row(
//             children: const [
//               Icon(
//                 Icons.trending_down,
//                 size: 16,
//                 color: Color(0xFFE53E3E),
//               ),
//               SizedBox(width: 4),
//               Text(
//                 '0.5%',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFFE53E3E),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GrowthCard extends StatelessWidget {
//   const GrowthCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 16),
//             Row(
//               children: const [
//                 Expanded(
//                   child: GrowthMetricTile(
//                     nepaliLabel: 'औसत तौल',
//                     englishLabel: 'Average Weight',
//                     value: '250.0',
//                     unit: 'gm',
//                     trend: '+2.5%',
//                     isPositive: true,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: GrowthMetricTile(
//                     nepaliLabel: 'दैनिक वृद्धि',
//                     englishLabel: 'Daily Gain',
//                     value: '15.5',
//                     unit: 'gm',
//                     trend: 'Normal',
//                     isPositive: true,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildWeeklyChart(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF0FFF4),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.monitor_weight_outlined,
//                 color: Color(0xFF38A169),
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'वृद्धि स्थिति',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 Text(
//                   'Growth Status',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF718096),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         PopupMenuButton<String>(
//           icon: const Icon(
//             Icons.more_horiz,
//             color: Color(0xFF718096),
//           ),
//           itemBuilder: (context) => [
//             const PopupMenuItem(
//               value: 'history',
//               child: Text('View History'),
//             ),
//             const PopupMenuItem(
//               value: 'export',
//               child: Text('Export Data'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildWeeklyChart() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Weekly Growth Trend',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: List.generate(
//                 7,
//                 (index) => _buildBar(index),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBar(int index) {
//     final heights = [0.4, 0.6, 0.8, 0.7, 0.9, 0.5, 0.7];
//     final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           width: 24,
//           height: 80 * heights[index],
//           decoration: BoxDecoration(
//             color: const Color(0xFF38A169).withOpacity(0.7),
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           days[index],
//           style: const TextStyle(
//             fontSize: 12,
//             color: Color(0xFF718096),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class GrowthMetricTile extends StatelessWidget {
//   final String nepaliLabel;
//   final String englishLabel;
//   final String value;
//   final String unit;
//   final String trend;
//   final bool isPositive;

//   const GrowthMetricTile({
//     Key? key,
//     required this.nepaliLabel,
//     required this.englishLabel,
//     required this.value,
//     required this.unit,
//     required this.trend,
//     required this.isPositive,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEDF2F7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             nepaliLabel,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF718096),
//             ),
//           ),
//           Text(
//             englishLabel,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF9AA5B1),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 unit,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF718096),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: isPositive
//                   ? const Color(0xFFF0FFF4)
//                   : const Color(0xFFFFF5F5),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   isPositive ? Icons.arrow_upward : Icons.arrow_downward,
//                   size: 12,
//                   color: isPositive
//                       ? const Color(0xFF38A169)
//                       : const Color(0xFFE53E3E),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   trend,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: isPositive
//                         ? const Color(0xFF38A169)
//                         : const Color(0xFFE53E3E),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedCard extends StatelessWidget {
//   const FeedCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 16),
//             Row(
//               children: const [
//                 Expanded(
//                   child: FeedMetricTile(
//                     nepaliLabel: 'आजको खपत',
//                     englishLabel: "Today's Feed",
//                     value: '45.5',
//                     unit: 'kg',
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: FeedMetricTile(
//                     nepaliLabel: 'कुल खपत',
//                     englishLabel: 'Total Feed',
//                     value: '450.0',
//                     unit: 'kg',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildFCRMetric(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFF5F5),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.inventory_2_outlined,
//                 color: Color(0xFFE53E3E),
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'दाना व्यवस्थापन',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 Text(
//                   'Feed Management',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF718096),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         PopupMenuButton<String>(
//           icon: const Icon(
//             Icons.more_horiz,
//             color: Color(0xFF718096),
//           ),
//           itemBuilder: (context) => [
//             const PopupMenuItem(
//               value: 'inventory',
//               child: Text('View Inventory'),
//             ),
//             const PopupMenuItem(
//               value: 'history',
//               child: Text('Feed History'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFCRMetric() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEDF2F7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: const [
//                   Text(
//                     'FCR',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     '(दाना रूपान्तरण दर)',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF718096),
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFEDF2F7)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(
//                       Icons.arrow_downward,
//                       size: 12,
//                       color: Color(0xFF38A169),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       '2.3%',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF38A169),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const Text(
//                 '1.65',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF0FFF4),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   'Good Performance',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF38A169),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeedMetricTile extends StatelessWidget {
//   final String nepaliLabel;
//   final String englishLabel;
//   final String value;
//   final String unit;

//   const FeedMetricTile({
//     Key? key,
//     required this.nepaliLabel,
//     required this.englishLabel,
//     required this.value,
//     required this.unit,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEDF2F7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             nepaliLabel,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF718096),
//             ),
//           ),
//           Text(
//             englishLabel,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF9AA5B1),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.baseline,
//             textBaseline: TextBaseline.alphabetic,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 unit,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF718096),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

