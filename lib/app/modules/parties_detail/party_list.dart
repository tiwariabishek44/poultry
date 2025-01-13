import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_party/add_parties.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/modules/parties_detail/party_detail_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PartyListPage extends StatelessWidget {
  PartyListPage({super.key});

  final controller = Get.put(PartyController());
  final currencyFormat = NumberFormat('#,##,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Parties',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: Colors.white),
            onPressed: () => Get.to(() => AddPartyPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.parties.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.fetchParties,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: controller.parties.length,
                  itemBuilder: (context, index) {
                    final party = controller.parties[index];
                    return _buildPartyCard(party);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.users,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Parties Available',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => AddPartyPage()),
            icon: const Icon(LucideIcons.plus, size: 20),
            label: Text(
              'Add New Party',
              style: GoogleFonts.notoSans(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyCard(dynamic party) {
    final bool isPayable =
        party.partyType == 'supplier'; // Adjust based on your model
    final String amountLabel = party.creditAmount == 0
        ? 'Settled'
        : (isPayable ? 'To Give' : 'To Receive');
    final Color amountColor = party.creditAmount == 0
        ? Colors.black
        : (isPayable ? Colors.red : Colors.green);

    return Card(
      margin: const EdgeInsets.only(bottom: 3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => PartyDetailsPage(partyId: party.partyId!));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          party.partyName,
                          style: GoogleFonts.notoSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(LucideIcons.phone,
                                size: 16.sp, color: AppColors.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              party.phoneNumber,
                              style: GoogleFonts.notoSans(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amountLabel,
                        style: GoogleFonts.notoSans(
                          fontSize: 16.sp,
                          color: const Color.fromARGB(255, 14, 13, 13),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs ${currencyFormat.format(party.creditAmount)}',
                        style: GoogleFonts.notoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: amountColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // finance_controller.dart
// import 'package:get/get.dart';
// import 'dart:developer';

// // finance_dashboard.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'dart:developer';
// import 'package:poultry/app/widget/loading_State.dart';
// import 'package:poultry/app/widget/custom_pop_up.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class FinanceController extends GetxController {
//   // Main Financial Metrics
//   final totalBalance = 450000.0.obs;
//   final monthlyEarning = 125000.0.obs;
//   final monthlyExpense = 75000.0.obs;
//   final totalDue = 85000.0.obs;

//   // Top Parties with Due
//   final List<Map<String, dynamic>> dueParties = [
//     {
//       'name': 'Ram Trading',
//       'totalDue': 35000.0,
//       'lastPaymentDate': '2024-01-10',
//       'status': 'PENDING'
//     },
//     {
//       'name': 'Krishna Store',
//       'totalDue': 25000.0,
//       'lastPaymentDate': '2024-01-09',
//       'status': 'PARTIAL'
//     },
//     {
//       'name': 'Hari Suppliers',
//       'totalDue': 15000.0,
//       'lastPaymentDate': '2024-01-08',
//       'status': 'DUE'
//     },
//   ];
// }

// class PartyListPage extends StatelessWidget {
//   final controller = Get.put(FinanceController());

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 5.h),
//           _buildMainCard(),
//           SizedBox(height: 2.h),
//           _buildQuickStats(),
//           SizedBox(height: 2.h),
//           _buildPartyList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainCard() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade700, Colors.blue.shade900],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total Balance',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.8),
//                   fontSize: 16,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.more_horiz, color: Colors.white),
//                 onPressed: () => _showOptionsMenu(),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Rs. ${controller.totalBalance.value}',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildMainCardItem(
//                 'Monthly Earning',
//                 'Rs. ${controller.monthlyEarning.value}',
//                 Icons.arrow_upward,
//                 Colors.green,
//               ),
//               Container(
//                 width: 1,
//                 height: 40,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               _buildMainCardItem(
//                 'Monthly Expense',
//                 'Rs. ${controller.monthlyExpense.value}',
//                 Icons.arrow_downward,
//                 Colors.red.shade300,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// // Inside FinanceDashboard class
//   void _showOptionsMenu() {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle bar at top
//             Container(
//               width: 40,
//               height: 4,
//               margin: EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             // Title
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   Text(
//                     'Options',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Spacer(),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//             ),

//             // Menu Items
//             _buildOptionItem(
//               icon: Icons.file_download,
//               color: Colors.blue,
//               title: 'Download Statement',
//               subtitle: 'Get monthly financial report',
//               onTap: () {
//                 Get.back();
//                 // Add statement download logic
//               },
//             ),

//             _buildOptionItem(
//               icon: Icons.share,
//               color: Colors.green,
//               title: 'Share Report',
//               subtitle: 'Share via WhatsApp or email',
//               onTap: () {
//                 Get.back();
//                 // Add share logic
//               },
//             ),

//             _buildOptionItem(
//               icon: Icons.filter_alt,
//               color: Colors.purple,
//               title: 'Filter Transactions',
//               subtitle: 'View specific period data',
//               onTap: () {
//                 Get.back();
//                 _showDateFilterDialog();
//               },
//             ),

//             _buildOptionItem(
//               icon: Icons.print,
//               color: Colors.orange,
//               title: 'Print Summary',
//               subtitle: 'Print financial summary',
//               onTap: () {
//                 Get.back();
//                 // Add print logic
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionItem({
//     required IconData icon,
//     required Color color,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: color),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDateFilterDialog() {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Select Date Range',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Date Range Options
//               _buildDateRangeOption('Last 7 Days'),
//               _buildDateRangeOption('Last 30 Days'),
//               _buildDateRangeOption('Last 3 Months'),
//               _buildDateRangeOption('Custom Range'),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Get.back(),
//                     child: Text('Cancel'),
//                   ),
//                   SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.back();
//                       // Apply filter logic
//                     },
//                     child: Text('Apply'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateRangeOption(String title) {
//     return InkWell(
//       onTap: () {
//         // Handle date range selection
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         child: Row(
//           children: [
//             Radio(
//               value: title,
//               groupValue: null, // Connect to controller value
//               onChanged: (value) {
//                 // Handle radio selection
//               },
//             ),
//             Text(
//               title,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // Update the options icon in _buildMainCard():

//   Widget _buildMainCardItem(
//       String label, String value, IconData icon, Color iconColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: iconColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: iconColor, size: 16),
//             ),
//             SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickStats() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildStatCard(
//               'Total Due',
//               'Rs. ${controller.totalDue}',
//               Icons.warning_rounded,
//               Colors.orange,
//               '8 Parties',
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: _buildStatCard(
//               'Due Today',
//               'Rs. 15,000',
//               Icons.calendar_today,
//               Colors.red,
//               '3 Payments',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String amount, IconData icon, Color color,
//       String subtitle) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color, size: 20),
//               ),
//               SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Text(
//             amount,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPartyList() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Parties with Due',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text('View All'),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           ...controller.dueParties.map((party) => _buildPartyCard(party)),
//         ],
//       ),
//     );
//   }

//   Widget _buildPartyCard(Map<String, dynamic> party) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 party['name'][0],
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   party['name'],
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   'Last Payment: ${party['lastPaymentDate']}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'Rs. ${party['totalDue']}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   party['status'],
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 12,
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
