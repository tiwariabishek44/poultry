import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/item_rate_response_model.dart';
import 'package:poultry/app/modules/item_rates/item_rates_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedRatePage extends StatelessWidget {
  final controller = Get.put(FeedRateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Feed Rate',
          style: GoogleFonts.notoSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: StreamBuilder<List<ItemsRateResponseModel>>(
        stream: controller.streamFeedRates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final existingRates = snapshot.data ?? [];
          final existingFeedNames =
              existingRates.map((e) => e.itemName).toList();

          final remainingFeeds = ['L1', 'L2', 'L3', 'PL']
              .where((feed) => !existingFeedNames.contains(feed))
              .toList();

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Existing Rates Section
                if (existingRates.isNotEmpty) ...[
                  _buildSectionHeader("Current Rates"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: existingRates.length,
                    itemBuilder: (context, index) {
                      return _buildRateCard(existingRates[index]);
                    },
                  ),
                  SizedBox(height: 20),
                ],

                // Remaining Feeds Section
                if (remainingFeeds.isNotEmpty) ...[
                  _buildSectionHeader("Add New Rates"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: remainingFeeds.length,
                    itemBuilder: (context, index) {
                      return _buildAddRateCard(remainingFeeds[index]);
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildRateCard(ItemsRateResponseModel rate) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(
              rate.itemName,
              style: GoogleFonts.notoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Rate: Rs. ${rate.rate.toStringAsFixed(2)} / Kg',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color.fromARGB(255, 3, 3, 3),
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: AppColors.primaryColor),
          onPressed: () => _showRateDialog(isEdit: true, existingRate: rate),
        ),
      ),
    );
  }

  Widget _buildAddRateCard(String feedName) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          feedName,
          style: GoogleFonts.notoSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Tap to set rate',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(Duration(milliseconds: 100));

            _showRateDialog(isEdit: false, feedName: feedName);
          },
        ),
      ),
    );
  }

  void _showRateDialog({
    required bool isEdit,
    ItemsRateResponseModel? existingRate,
    String? feedName,
  }) {
    if (isEdit) {
      controller.itemNameController.text = existingRate!.itemName;
      controller.categoryController.text = existingRate.category;
      controller.rateController.text = existingRate.rate.toString();
    } else {
      controller.itemNameController.text = feedName!;
      controller.categoryController.text = 'Feed';
      controller.rateController.clear();
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? 'Update Rate' : 'Add New Rate',
                style: GoogleFonts.notoSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Feed Name Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feed Name',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: controller.itemNameController,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // // Category Field
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'Category',
                    //       style: TextStyle(
                    //         fontSize: 14.sp,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.grey[700],
                    //       ),
                    //     ),
                    //     SizedBox(height: 8),
                    //     TextField(
                    //       controller: controller.categoryController,
                    //       readOnly: true,
                    //       decoration: InputDecoration(
                    //         filled: true,
                    //         fillColor: Colors.grey[100],
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //           borderSide: BorderSide(color: Colors.grey[300]!),
                    //         ),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //           borderSide: BorderSide(color: Colors.grey[300]!),
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //           borderSide:
                    //               BorderSide(color: AppColors.primaryColor),
                    //         ),
                    //         contentPadding: EdgeInsets.symmetric(
                    //             horizontal: 12, vertical: 8),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 16),

                    // Rate Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rate (Rs.)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: controller.rateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter rate',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await Future.delayed(Duration(milliseconds: 100));

                      if (isEdit) {
                        controller.updateFeedRate(existingRate!.rateId!);
                      } else {
                        controller.createFeedRate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isEdit ? 'Update' : 'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
