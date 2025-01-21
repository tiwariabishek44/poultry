// class AddNewBottomSheet extends StatelessWidget {
//   const AddNewBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Drag handle
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.symmetric(vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),

//           // Modern Header (similar to your design)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue.shade700, Colors.blue.shade900],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Top Row with Title and Close Button
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Add New Task",
//                       style: GoogleFonts.roboto(
//                         fontSize: 20,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: InkWell(
//                         onTap: () => Navigator.pop(context),
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.yellow.shade300,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // Stats Row (similar to your Farm Overview Stats)
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildOptionStat(
//                         'Reports',
//                         'Create',
//                         Icons.add_chart,
//                         isSmallScreen,
//                       ),
//                     ),
//                     Container(
//                       height: 40,
//                       width: 1,
//                       color: Colors.white.withOpacity(0.2),
//                       margin: const EdgeInsets.symmetric(horizontal: 16),
//                     ),
//                     Expanded(
//                       child: _buildOptionStat(
//                         'Events',
//                         'Schedule',
//                         Icons.event,
//                         isSmallScreen,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   _buildActionCard(
//                     'Add Daily Report',
//                     'Track your daily farm statistics',
//                     Icons.assessment,
//                     () => Navigator.pop(context),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildActionCard(
//                     'Schedule Event',
//                     'Plan your farm activities',
//                     Icons.event_note,
//                     () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOptionStat(
//       String title, String value, IconData icon, bool isSmallScreen) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: isSmallScreen ? 12 : 14,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Icon(icon, color: Colors.white, size: isSmallScreen ? 16 : 20),
//             const SizedBox(width: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: isSmallScreen ? 14 : 16,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildActionCard(
//       String title, String subtitle, IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.blue.shade50,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: Colors.blue.shade100),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade100,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: Colors.blue.shade700),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade900,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.blue.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios,
//                 size: 16, color: Colors.blue.shade700),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/modules/add_batch/add_batch.dart';
import 'package:poultry/app/modules/egg_collection_add/egg_colleciton.dart';
import 'package:poultry/app/modules/feed_consumption/feed_consumption.dart';
import 'package:poultry/app/modules/flock_death/flock_death.dart';
import 'package:poultry/app/modules/my_vaccine/vaccine_schedule.dart';
import 'package:poultry/app/modules/rice_husk_spray/rice_husk_spray.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActivityBottomSheet extends StatelessWidget {
  const ActivityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // row for the heading ( activity) and close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activity Panel",
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildActionCard(
                    'Add New Batch',
                    'नयाँ ब्याच थप्नुहोस्',
                    Icons.assessment,
                    () {
                      Get.to(() => AddBatchPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Egg Collection',
                    'अण्डा संकलन',
                    Icons.assessment,
                    () {
                      Get.to(() => EggCollectionPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Daily Feed Consumption',
                    'दैनिक आहार खपत',
                    Icons.assessment,
                    () {
                      Get.to(() => FeedConsumptionPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Mortality Record',
                    'मृत्यु रेकर्ड',
                    Icons.assessment,
                    () {
                      Get.to(() => FlockDeathPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'भुस Record',
                    'भुस रेकर्ड',
                    Icons.assessment,
                    () {
                      Get.to(() => RiceHuskPage());
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildActionCard(
                    'Vaccine',
                    'खोप तालिका',
                    Icons.assessment,
                    () {
                      Get.to(() => VaccineSchedulePage());
                    },
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionStat(
      String title, String value, IconData icon, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 12 : 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: Colors.white, size: isSmallScreen ? 16 : 20),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue.shade700),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.blue.shade700),
          ],
        ),
      ),
    );
  }
}
