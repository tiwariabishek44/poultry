// import main
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/user_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/setting_page/youtube_palyer.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingPage extends GetView<LoginController> {
  SettingPage({Key? key}) : super(key: key);

  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isProfileLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black54,
            ),
          );
        }

        final user = controller.currentAdmin.value;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.alertCircle,
                    size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'User data not available',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileCard(user),
              _buildBatchReports(),
              // amke a listtile for the lable ( Learning video )
              SizedBox(height: 2.h),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.video,
                    size: 20,
                    color: Colors.orange.shade700,
                  ),
                ),
                title: Text(
                  'Learning Video',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'अझै सिक्नको लागि भिडियो ट्युटोरियलहरू हेर्नुहोस्',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                onTap: () {
                  // Handle the tap event here
                  Get.to(() => VideoListScreen());
                },
              ),
              SizedBox(height: 2.h),
              _buildLogoutButton(),
              SizedBox(height: 2.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBatchReports() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.clipboardList,
                  size: 20,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Batch Reports',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          children: [
            Obx(() {
              if (settingsController.isLoading.value) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (settingsController.batches.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No batches found',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: settingsController.batches.map((batch) {
                  final isActive = batch['isActive'] ?? false;
                  final startDate = batch['startingDate'] ?? '';
                  final formattedDate = startDate.isNotEmpty
                      ? NepaliDateFormat('dd MMM yyyy')
                          .format(NepaliDateTime.parse(startDate))
                      : 'No date';

                  return InkWell(
                    onTap: () {
                      // Navigate to batch details
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                LucideIcons.layers,
                                size: 20,
                                color: isActive
                                    ? Colors.green.shade700
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch['batchName'] ?? 'Unnamed Batch',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Completed',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isActive
                                    ? Colors.green.shade700
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          CustomDialog.showConfirmation(
              title: 'Logout',
              message: 'Are you sure you want to logout?',
              confirmText: 'Logout',
              onConfirm: () {
                controller.logout();
              });
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade200),
          ),
          backgroundColor: Colors.red.shade50,
        ),
        icon: Icon(
          LucideIcons.logOut,
          size: 20,
          color: Colors.red.shade700,
        ),
        label: Text(
          'Logout',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserResponseModel user) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
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
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
                        user.fullName,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (user.farmName != null && user.farmName!.isNotEmpty)
                        Text(
                          user.farmName!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildInfoRow(LucideIcons.phone, user.phoneNumber),
                if (user.address != null && user.address!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(LucideIcons.mapPin, user.address!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.black54,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class SettingsController extends GetxController {
  final _loginController = Get.find<LoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final batches = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
  }

  Stream<QuerySnapshot> getBatchesStream() {
    final adminId = _loginController.adminUid;
    if (adminId == null) return Stream.empty();

    return _firestore
        .collection(FirebasePath.batches)
        .where('adminId', isEqualTo: adminId)
        .snapshots();
  }

  void fetchBatches() {
    isLoading.value = true;
    getBatchesStream().listen(
      (snapshot) {
        final batchList = snapshot.docs.map((doc) {
          return {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          };
        }).toList();
        batches.value = batchList;
        isLoading.value = false;
      },
      onError: (error) {
        print("Error fetching batches: $error");
        isLoading.value = false;
      },
    );
  }
}
// class SettingPage extends StatelessWidget {
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
//             onTap: () {},
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
