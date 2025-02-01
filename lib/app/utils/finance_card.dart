import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/batch_finance/batch_finance.dart';
import 'package:poultry/app/utils/batch_card/batch_card_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FinanceCard extends StatelessWidget {
  final String batchId;
  const FinanceCard({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActiveBatchStreamController>();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 1.h),
            _buildTotalExpense(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF8FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: Color(0xFF3182CE),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'खर्च विवरण',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Batch Expenses',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the batch finance details page
            Get.to(() => BatchFinancePage(
                  batchId: batchId,
                ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Detail', // Update accordingly based on your logic
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalExpense(ActiveBatchStreamController controller) {
    return StreamBuilder<double>(
      stream: controller.totalCostStream, // Listen to the combined stream
      builder: (context, snapshot) {
        final totalCost = snapshot.data ?? 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF8FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'कुल लागत',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748)),
                      ),
                      Text(
                        'Total Cost',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF718096)),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                  Text(
                    'रु. ${controller.formatNumber(totalCost)}', // Display formatted cost
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3182CE)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
