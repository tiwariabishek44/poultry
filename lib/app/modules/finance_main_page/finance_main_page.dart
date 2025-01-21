import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_party/add_parties.dart';
import 'package:poultry/app/modules/finance_main_page/utils/filter.dart';
import 'package:poultry/app/modules/finance_main_page/utils/finance_hearder.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/modules/parties_detail/party_detail_page.dart';
import 'package:poultry/app/widget/finance_metrics_crousals.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FinanceMainScreen extends StatelessWidget {
  FinanceMainScreen({super.key});

  final controller = Get.put(PartyController());
  final currencyFormat = NumberFormat('#,##,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Finance',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchParties,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Metrics Header
              FinanceMetricsHeader(),

              // Parties Header
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Parties",
                    style: GoogleFonts.notoSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              // Filter Bar
              FinanceFilterBar(controller: controller),

              // Parties List - Now part of the main scroll
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredParties.isEmpty) {
                  return _buildEmptyState();
                }

                // Sort the parties by name
                final sortedParties = controller.filteredParties.toList()
                  ..sort((a, b) => a.partyName.compareTo(b.partyName));

                // Group parties by their starting letter
                final Map<String, List<dynamic>> groupedParties = {};
                for (var party in sortedParties) {
                  final String startingLetter =
                      party.partyName[0].toUpperCase();
                  if (!groupedParties.containsKey(startingLetter)) {
                    groupedParties[startingLetter] = [];
                  }
                  groupedParties[startingLetter]!.add(party);
                }

                return ListView.builder(
                  shrinkWrap: true, // Important!
                  physics: const NeverScrollableScrollPhysics(), // Important!
                  padding: EdgeInsets.only(bottom: 42.h),
                  itemCount: groupedParties.length,
                  itemBuilder: (context, index) {
                    final String startingLetter =
                        groupedParties.keys.elementAt(index);
                    final List<dynamic> parties =
                        groupedParties[startingLetter]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            startingLetter,
                            style: GoogleFonts.notoSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        ...parties
                            .map((party) => _buildPartyCard(party))
                            .toList(),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => AddPartyPage()),
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: Text("Add Party", style: TextStyle(color: Colors.white)),
        elevation: 2,
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            SizedBox(width: 12),
            // _buildFilterChip('Customers', 'customer'),
            SizedBox(width: 12),
            // _buildFilterChip('Suppliers', 'supplier'),
            SizedBox(width: 12),
            _buildFilterChip('To Receive', 'to_receive'),
            SizedBox(width: 12),
            // _buildFilterChip('To Pay', 'to_pay'),
            SizedBox(width: 12),
            _buildFilterChip('Settled', 'settled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
      return InkWell(
        onTap: () => controller.updateFilter(value),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.notoSans(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    });
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
                            fontSize: 16.sp,
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
