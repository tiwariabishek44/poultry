import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batchOperations/batchOperationsController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchUpgradePage extends StatelessWidget {
  final String batchId;
  final String currentStage;
  BatchUpgradePage(
      {super.key, required this.batchId, required this.currentStage});

  final controller = Get.put(BatchOperationsController());

  @override
  Widget build(BuildContext context) {
    final nextStage =
        currentStage.toLowerCase() == 'starter' ? 'Grower' : 'Layer';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'चल्ला स्टेज अपग्रेड',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Simple Status Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Current Stage
                  Text(
                    'अहिलेको स्टेज',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    _getStageNameInNepali(currentStage),
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  SizedBox(height: 3.h),
                  Icon(Icons.arrow_downward, size: 30.sp, color: Colors.grey),
                  SizedBox(height: 3.h),

                  // Next Stage
                  Text(
                    'अर्को स्टेज',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    _getStageNameInNepali(nextStage),
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Important Points
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'महत्त्वपूर्ण जानकारी',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildPoint('दाना परिवर्तन गर्नुहोस्'),
                  _buildPoint('उमेर अनुसारको खोप दिनुहोस्'),
                  _buildPoint('स्वास्थ्य जाँच गर्नुहोस्'),
                ],
              ),
            ),

            SizedBox(height: 6.h),

            // Simple Warning
            Text(
              '* यो कार्य पछि उल्टाउन सकिँदैन',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Big Clear Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () => _showSimpleConfirmation(batchId, currentStage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'अपग्रेड गर्नुहोस्',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.orange[800], size: 16.sp),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSimpleConfirmation(String batchId, String currentStage) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'के तपाईं निश्चित हुनुहुन्छ?',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'पर्खनुहोस्',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.upgradeBatchStage(
                        batchId: batchId,
                        currentStage: currentStage,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text(
                      'हो, अपग्रेड गर्नुहोस्',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.white,
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

  String _getStageNameInNepali(String stage) {
    switch (stage.toLowerCase()) {
      case 'starter':
        return 'स्टार्टर';
      case 'grower':
        return 'ग्रोवर';
      case 'layer':
        return 'लेयर';
      default:
        return stage;
    }
  }
}
