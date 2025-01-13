import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/activity_folder/batch/batchController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddBatchScreen extends StatelessWidget {
  AddBatchScreen({Key? key}) : super(key: key);

  final batchController = Get.put(BatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          'New Batch (नयाँ ब्याच)',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Wave decoration
          Container(
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: batchController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Batch Details (ब्याच विवरण)',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Please enter details for the new batch (कृपया आफ्नो नयाँ ब्याचको विवरण भर्नुहोस्)',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Main Form Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Batch Name Section
                            // Batch Name Section
                            _buildSectionTitle(
                              title: 'Batch Name (ब्याचको नाम)',
                              icon: LucideIcons.tag,
                            ),
                            SizedBox(height: 1.h),
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Example: ${batchController.selectedMonth.value} (उदाहरण: ${batchController.selectedMonth.value})',
                                      style: GoogleFonts.notoSansDevanagari(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    TextFormField(
                                      controller:
                                          batchController.batchNameController,
                                      style: GoogleFonts.notoSansDevanagari(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter batch name',
                                        hintStyle:
                                            GoogleFonts.notoSansDevanagari(
                                          color: Colors.black38,
                                          fontSize: 14,
                                        ),
                                        prefixIcon: Icon(
                                          LucideIcons.tag,
                                          color: AppTheme.primaryColor,
                                          size: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]!),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]!),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),

                            SizedBox(height: 3.h),

                            // Quantity Section
                            _buildSectionTitle(
                              title: 'Total Flock (कुल कुखुराहरू)',
                              icon: LucideIcons.bird,
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: TextFormField(
                                controller: batchController.quantityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Total Flock',
                                  hintStyle: GoogleFonts.notoSansDevanagari(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    LucideIcons.bird,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(4.w),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'कृपया संख्या हाल्नुहोस्';
                                  }
                                  if (int.tryParse(value!) == null ||
                                      int.parse(value) <= 0) {
                                    return 'कृपया मान्य संख्या हाल्नुहोस्';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Submit Button
                      Container(
                        width: double.infinity,
                        height: 6.5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: batchController.createBatch,
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.plus,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Create Batch ',
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
  
//
//import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:poultry/appss/module/poultry_folder/batch/selecct_room.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../config/constant.dart';
// import '../../poultryLogin/poultryLoginController.dart';
// import '../batch/batchController.dart';

// class AddBatchScreen extends StatelessWidget {
//   // Colors (consistent with previous designs)
//   static const primaryBlue = Color(0xFF2C5282);
//   static const backgroundBlue = Color(0xFFF7FAFC);
//   static const successGreen = Color(0xFF48BB78);

//   AddBatchScreen({Key? key}) : super(key: key);

//   final batchController = Get.put(BatchController());
//   final loginController = Get.find<PoultryLoginController>();

//   // Helper method to build section titles
//   Widget _buildSectionTitle({
//     required String title,
//     required IconData icon,
//   }) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: primaryBlue,
//         ),
//         SizedBox(width: 2.w),
//         Text(
//           title,
//           style: GoogleFonts.notoSansDevanagari(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   // Build form label
//   Widget _buildFormLabel(String label) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 1.h),
//       child: Text(
//         label,
//         style: GoogleFonts.notoSansDevanagari(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey[700],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundBlue,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(LucideIcons.arrowLeft, color: Colors.black87),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           'Add New Batch (नयाँ ब्याच थप्नुहोस्)',
//           style: GoogleFonts.notoSansDevanagari(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               padding: EdgeInsets.all(4.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius:
//                     BorderRadius.vertical(bottom: Radius.circular(20)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Batch Details (ब्याच विवरण)',
//                     style: GoogleFonts.notoSansDevanagari(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     'Please enter details for the new batch (कृपया आफ्नो नयाँ ब्याचको विवरण भर्नुहोस्)',
//                     style: GoogleFonts.notoSansDevanagari(
//                       fontSize: 14,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Main Form Content
//             Padding(
//               padding: EdgeInsets.all(4.w),
//               child: Form(
//                 key: batchController.formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Main Form Card
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(4.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
                          // // Batch Name Section
                          // _buildSectionTitle(
                          //   title: 'Batch Name (ब्याचको नाम)',
                          //   icon: LucideIcons.tag,
                          // ),
                          // SizedBox(height: 1.h),
                          // Obx(() => Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           'Example: ${batchController.selectedMonth.value}-BATCH (उदाहरण: ${batchController.selectedMonth.value}-BATCH)',
                          //           style: GoogleFonts.notoSansDevanagari(
                          //             fontSize: 14,
                          //             color: Colors.black54,
                          //           ),
                          //         ),
                          //         SizedBox(height: 1.h),
                          //         TextFormField(
                          //           controller:
                          //               batchController.batchNameController,
                          //           style: GoogleFonts.notoSansDevanagari(
                          //             fontSize: 15,
                          //             color: Colors.black87,
                          //           ),
                          //           decoration: InputDecoration(
                          //             hintText:
                          //                 'Enter batch name (ब्याचको नाम लेख्नुहोस्)',
                          //             hintStyle: GoogleFonts.notoSansDevanagari(
                          //               color: Colors.black38,
                          //               fontSize: 14,
                          //             ),
                          //             prefixIcon: Icon(
                          //               LucideIcons.tag,
                          //               color: primaryBlue,
                          //               size: 20,
                          //             ),
                          //             border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(12),
                          //               borderSide: BorderSide(
                          //                   color: Colors.grey[300]!),
                          //             ),
                          //             enabledBorder: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(12),
                          //               borderSide: BorderSide(
                          //                   color: Colors.grey[300]!),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     )),

                          // SizedBox(height: 3.h),

//                           // Rooms Section
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildSectionTitle(
//                                 title: 'Selected Rooms',
//                                 icon: LucideIcons.home,
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.add_circle,
//                                   color: primaryBlue,
//                                 ),
//                                 onPressed: () {
//                                   Get.to(() => SelectRoomsPage());
//                                 },
//                               ),
//                             ],
//                           ),

//                           // Selected Rooms List
//                           Obx(() => Column(
//                                 children: batchController.selectedRooms
//                                     .map((room) => Container(
//                                           margin: EdgeInsets.symmetric(
//                                               vertical: 0.5.h),
//                                           padding: EdgeInsets.all(1.w),
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey[100],
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: ListTile(
//                                             title: Text(
//                                               'Room ${room['roomNumber']}',
//                                               style: GoogleFonts.notoSansDevanagari(),
//                                             ),
//                                             subtitle: Text(
//                                               'Birds: ${room['birdCount']}',
//                                               style: GoogleFonts.notoSansDevanagari(),
//                                             ),
//                                             trailing: IconButton(
//                                               icon: Icon(
//                                                 Icons.delete,
//                                                 color: Colors.red,
//                                               ),
//                                               onPressed: () => batchController
//                                                   .removeRoom(room['roomId']),
//                                             ),
//                                           ),
//                                         ))
//                                     .toList(),
//                               )),

//                           SizedBox(height: 3.h),

//                           // Quantity Section
//                           _buildSectionTitle(
//                             title: 'Total Birds (कुल कुखुराहरू)',
//                             icon: LucideIcons.bird,
//                           ),
//                           SizedBox(height: 1.h),
//                           TextFormField(
//                             controller: batchController.quantityController,
//                             keyboardType: TextInputType.number,
//                             readOnly: false, // Make it read-only
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             style: GoogleFonts.notoSansDevanagari(
//                               fontSize: 15,
//                               color: Colors.black87,
//                             ),
//                             decoration: InputDecoration(
//                               hintText:
//                                   'Total Birds (Total calculated from rooms)',
//                               hintStyle: GoogleFonts.notoSansDevanagari(
//                                 color: Colors.black38,
//                                 fontSize: 14,
//                               ),
//                               prefixIcon: Icon(
//                                 LucideIcons.bird,
//                                 color: primaryBlue,
//                                 size: 20,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide:
//                                     BorderSide(color: Colors.grey[300]!),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide:
//                                     BorderSide(color: Colors.grey[300]!),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value?.isEmpty ?? true) {
//                                 return 'Please add rooms and select birds';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 4.h),

//                     // Submit Button
//                     ElevatedButton(
//                       onPressed: batchController.createBatch,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryBlue,
//                         padding: EdgeInsets.symmetric(vertical: 2.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             LucideIcons.plus,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                           SizedBox(width: 2.w),
//                           Text(
//                             'Create Batch (ब्याच सिर्जना गर्नुहोस्)',
//                             style: GoogleFonts.notoSansDevanagari(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
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
// }
