import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/add_batch/add_batch.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_managemnt.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:poultry/app/utils/bird_status_card.dart';
import 'package:poultry/app/utils/feed_card.dart';
import 'package:poultry/app/utils/finance_card.dart';
import 'package:poultry/app/utils/growth_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActiveBatchesSection extends StatelessWidget {
  ActiveBatchesSection({Key? key}) : super(key: key);

  final controller = Get.put(ActiveBatchStreamController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BatchResponseModel>>(
      stream: controller.activeBatches,
      builder: (context, batchSnapshot) {
        if (!batchSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (batchSnapshot.hasError) {
          return Center(
            child: Text(
              'Error loading batches',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (batchSnapshot.data!.isEmpty) {
          return NoBatchWidget(
            onCreateBatch: () {
              // Navigate to create batch page
              Get.to(() => AddBatchPage());
            },
          );
        }

        final batch = batchSnapshot.data!.first;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Column(
            children: [
              FinanceCard(
                batchId: batch.batchId!,
              ),
              SizedBox(height: 1.h),
              BirdStatusCard(
                batchData: batch,
              ),
              SizedBox(height: 1.h),
              GrowthCard(),
              SizedBox(height: 1.h),
              FeedCard(),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}

class NoBatchWidget extends StatelessWidget {
  final VoidCallback? onCreateBatch;
  const NoBatchWidget({Key? key, this.onCreateBatch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            SizedBox(height: 1.h),

            _buildFeaturesCard(),
            SizedBox(height: 1.h),

            // Create Batch Button
            _buildCreateBatchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Text(
              'कुखुरा फार्म व्यवस्थापन',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            Text(
              'Poultry Farm Management',
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF718096),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'आफ्नो कुखुरा फार्मलाई डिजिटल रूपमा व्यवस्थापन गर्न सुरु गर्नुहोस्',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF718096),
              ),
            ),
            Text(
              'Start managing your poultry farm digitally',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'तपाईं यी कार्यहरू गर्न सक्नुहुन्छ:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            Text(
              'You can perform these activities:',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF718096),
              ),
            ),
            SizedBox(height: 2.h),

            // Feature List
            ..._buildFeatureItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureItems() {
    final features = [
      {
        'icon': Icons.fastfood_outlined,
        'color': Color(0xFF38A169),
        'nepali': 'दैनिक दाना रेकर्ड',
        'english': 'Daily Feed Record',
        'desc': 'Track daily feed consumption and costs'
      },
      {
        'icon': Icons.monitor_heart_outlined,
        'color': Color(0xFFE53E3E),
        'nepali': 'मृत्यु रेकर्ड',
        'english': 'Mortality Record',
        'desc': 'Monitor and record bird mortality'
      },
      {
        'icon': Icons.monitor_weight_outlined,
        'color': Color(0xFF3182CE),
        'nepali': 'दैनिक तौल रेकर्ड',
        'english': 'Daily Weight Record',
        'desc': 'Track bird growth and weight gain'
      },
      {
        'icon': Icons.medical_services_outlined,
        'color': Color(0xFF805AD5),
        'nepali': 'औषधि रेकर्ड',
        'english': 'Medicine Record',
        'desc': 'Manage vaccination and medication schedules'
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'color': Color(0xFFD69E2E),
        'nepali': 'खर्च विवरण',
        'english': 'Expense Details',
        'desc': 'Track all farm-related expenses'
      }
    ];

    return features
        .map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: (feature['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: feature['color'] as Color,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['nepali'] as String,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          feature['english'] as String,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color(0xFF718096),
                          ),
                        ),
                        Text(
                          feature['desc'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF718096),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildCreateBatchButton() {
    return ElevatedButton(
      onPressed: onCreateBatch,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_circle_outline, size: 20.sp),
          SizedBox(width: 2.w),
          Text(
            'Create New Batch',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
