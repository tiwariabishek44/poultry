import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/batchOperations/batch_operations.dart';
import 'package:poultry/app/modules/batch_finance/batch_finance.dart';
import 'package:poultry/app/modules/batch_managemnt/batch_report_controller.dart';
import 'package:poultry/app/modules/batch_summary/batch_summary.dart';
import 'package:poultry/app/modules/feed_cocnsumption_record/feed_consumption_record.dart';
import 'package:poultry/app/modules/medicine_record/medicine_record.dart';
import 'package:poultry/app/modules/motality_record/motality_record.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BatchManagementPage extends StatelessWidget {
  final BatchResponseModel batch;
  BatchManagementPage({super.key, required this.batch});
  final batchReportController = Get.put(BatchReportController());

  @override
  Widget build(BuildContext context) {
    batchReportController.selectedBatchId.value = batch.batchId!;
    batchReportController.selectedBatchName.value = batch.batchName;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leadingWidth: 64,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(LucideIcons.chevronLeft,
                  color: Colors.black87, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batch Management',
              style: GoogleFonts.inter(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              batch.batchName,
              style: GoogleFonts.inter(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBatchOverview(),
            const SizedBox(height: 24),
            _buildManagementOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchOverview() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.layers,
                      color: Color(0xFF3182CE),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ब्याच विवरण',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        'Batch Overview',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: batch.isActive
                      ? const Color(0xFFF0FFF4)
                      : const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  batch.isActive ? 'Active' : 'Inactive',
                  style: GoogleFonts.inter(
                    color: batch.isActive
                        ? const Color(0xFF38A169)
                        : const Color(0xFFE53E3E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Divider(height: 24),
                _buildOverviewItem(
                  title: 'Current Birds',
                  value: '${batch.currentFlockCount}',
                  icon: LucideIcons.bird,
                ),
                const Divider(height: 24),
                _buildOverviewItem(
                  title: 'Mortality  ',
                  value: '${batch.totalDeath}',
                  icon: LucideIcons.heartPulse,
                ),
                const Divider(height: 24),
                _buildOverviewItem(
                  title: 'कुल कुखुरा बिक्री',
                  value: '${batch.totalSold}',
                  icon: LucideIcons.heartPulse,
                ),
                const Divider(height: 24),
                _buildOverviewItem(
                    title: 'कुल मासु बिक्री',
                    value: '${batch.totalWeight} kg',
                    icon: LucideIcons.scale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Management Options",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildManagementTile(
          title: 'Feed Consumption',
          subtitle: 'Track daily feed usage',
          nepaliTitle: 'दाना खपत रेकर्ड',
          icon: LucideIcons.wheat,
          iconColor: Color.fromRGBO(56, 161, 105, 1),
          onTap: () => Get.to(() => FeedConsumptionRecordPage()),
        ),
        _buildManagementTile(
          title: 'Mortality Record',
          subtitle: 'Monitor bird health and losses',
          nepaliTitle: 'मृत्यु दर',
          icon: LucideIcons.alertTriangle,
          iconColor: const Color(0xFFE53E3E),
          onTap: () => Get.to(() => MortalityRecordPage()),
        ),
        _buildManagementTile(
          title: 'Batch Finance',
          subtitle: 'Track expenses and revenue',
          nepaliTitle: 'ब्याच वित्त',
          icon: LucideIcons.wallet,
          iconColor: const Color(0xFF805AD5),
          onTap: () => Get.to(() => BatchFinancePage(batchId: batch.batchId!)),
        ),
        _buildManagementTile(
          title: 'Medicine Record',
          subtitle: 'Monitor treatments and vaccines',
          nepaliTitle: 'औषधि रेकर्ड',
          icon: Icons.medical_services,
          iconColor: const Color(0xFFDD6B20),
          onTap: () {
            // Handle medicine record
            Get.to(() => MedicationRecordPage());
          },
        ),
        _buildManagementTile(
          title: 'Retire Batch',
          subtitle: 'Close and archive batch',
          nepaliTitle: 'ब्याच निवृत्त गर्नुहोस्',
          icon: LucideIcons.archive,
          iconColor: const Color(0xFFE53E3E),
          onTap: () => Get.to(() => BatchRetirementPage(
                batchId: batch.batchId!,
                batchName: batch.batchName,
              )),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildManagementTile({
    required String title,
    required String subtitle,
    required String nepaliTitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDestructive ? Border.all(color: Colors.red.shade100) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.shade50
                        : iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nepaliTitle,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDestructive
                              ? Colors.red.shade700
                              : const Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: isDestructive
                      ? Colors.red.shade200
                      : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
