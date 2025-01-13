import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/setting/batchReport/batch_action.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:poultry/appss/module/setting/aboutUs/aboutUs.dart';
import 'package:poultry/appss/module/poultry_folder/contactUs/contactUs.dart';
import 'package:poultry/appss/module/setting/vaccine_chart/vaccine_chart.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final loginController = Get.find<PoultryLoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Settings',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section (Keep existing code)
            Container(
              color: AppTheme.primaryColor,
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      LucideIcons.user,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              loginController.adminData.value?.farmName ??
                                  'Farm Name',
                              style: GoogleFonts.notoSansDevanagari(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        SizedBox(height: 0.5.h),
                        Obx(() => Text(
                              loginController.adminData.value?.name ?? 'Email',
                              style: GoogleFonts.notoSansDevanagari(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Settings Sections
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poultry Management Section
                  _buildSection(
                    title: 'Poultry Management',
                    items: [
                      SettingItem(
                        icon: LucideIcons.layers,
                        title: 'Batch Records',
                        subtitle: 'View and manage all batch records',
                        onTap: () {
                          Get.bottomSheet(
                            BatchListBottomSheet(
                                adminId:
                                    loginController.adminData.value?.uid ?? ''),
                            isScrollControlled: true,
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Support & About
                  _buildSection(
                    title: 'Support & About ',
                    items: [
                      SettingItem(
                        icon: LucideIcons.helpCircle,
                        title: 'Contact Us',
                        subtitle: 'Get help and contact support',
                        onTap: () {
                          Get.to(() => ContactUsPage());
                        },
                      ),
                      SettingItem(
                        icon: LucideIcons.info,
                        title: 'About App',
                        subtitle: 'Version and app information',
                        onTap: () {
                          Get.to(() => const AboutUsPage());
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _handleLogout();
                      },
                      icon: Icon(LucideIcons.logOut, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.notoSansDevanagari(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // App Version
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: GoogleFonts.notoSansDevanagari(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
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

  void _handleLogout() async {
    Get.back();
    // Show confirmation dialog
    bool confirm = await showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: Text('Confirm Logout', style: AppTheme.titleLarge),
            content: Text('Are you sure you want to logout?',
                style: AppTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel',
                    style: AppTheme.bodyLarge
                        .copyWith(color: AppTheme.textMedium)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Logout',
                    style: AppTheme.bodyLarge.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      // Show loading dialog
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingWidget(text: 'Logging out...'),
        ),
        barrierDismissible: false,
      );

      // Perform logout
      await loginController.logout();
    }
  }

  Widget _buildSection({
    required String title,
    required List<SettingItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            title,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
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
            children: items.map((item) {
              final isLast = items.last == item;
              return Column(
                children: [
                  ListTile(
                    onTap: item.onTap,
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: GoogleFonts.notoSansDevanagari(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Icon(
                      LucideIcons.chevronRight,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class BatchListBottomSheet extends StatelessWidget {
  final String adminId;
  final RxList<DocumentSnapshot> batches = <DocumentSnapshot>[].obs;
  final isLoading = true.obs;

  BatchListBottomSheet({required this.adminId}) {
    _loadBatches();
  }

  void _loadBatches() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('batches')
          .where('adminUid', isEqualTo: adminId)
          .get();

      batches.value = snapshot.docs;
    } catch (e) {
      print('Error loading batches: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            title: Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.5.h),
                Container(
                  width: 150,
                  height: 14,
                  color: Colors.white,
                ),
                SizedBox(height: 0.5.h),
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
            trailing: Container(
              width: 60,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Batch Records',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: const Color.fromARGB(255, 28, 27, 27)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (isLoading.value) {
                return _buildShimmerLoading();
              }

              if (batches.isEmpty) {
                return Center(
                  child: Text('No batches found',
                      style:
                          GoogleFonts.notoSansDevanagari(color: Colors.grey)),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: batches.length,
                itemBuilder: (context, index) {
                  final batch = batches[index].data() as Map<String, dynamic>;
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    title: Text(
                      batch['batchName'] ?? 'Unnamed Batch',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0.5.h),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       LucideIcons.calendar,
                        //       size: 14,
                        //       color: Colors.grey[600],
                        //     ),
                        //     SizedBox(width: 1.w),
                        //     Text(
                        //       'Started: ${batch['createdAt']}',
                        //       style: GoogleFonts.notoSansDevanagari(
                        //         fontSize: 13,
                        //         color: Colors.grey[600],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.bird,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Birds: ${batch['currentQuantity']}/${batch['quantity']}',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: batch['status'] == 'active'
                            ? Colors.green[50]
                            : Colors.orange[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        batch['status']?.toString().toUpperCase() ?? 'UNKNOWN',
                        style: GoogleFonts.notoSansDevanagari(
                          color: batch['status'] == 'active'
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => BatchActonPage(
                            batch: batch,
                          ));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
