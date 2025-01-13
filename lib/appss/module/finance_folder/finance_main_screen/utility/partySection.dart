import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/finance_main_screen/finance_main_screen_controller.dart';
import 'package:poultry/appss/module/finance_folder/parytDetailPage/partyDetailPage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PartySection extends StatelessWidget {
  PartySection({Key? key}) : super(key: key);

  final PartyGetController controller = Get.put(PartyGetController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PartySectionHeader(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refreshParties,
            child: Obx(() => _buildContent()),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError.value) {
      return ErrorView(
        message: controller.errorMessage.value,
        onRetry: controller.refreshParties,
      );
    }

    if (controller.allParties.isEmpty) {
      return const EmptyStateView();
    }

    if (controller.filteredParties.isEmpty) {
      return NoPartyTypeView(partyType: controller.selectedParty.value);
    }

    return PartyListView(parties: controller.filteredParties);
  }
}

class PartySectionHeader extends StatelessWidget {
  const PartySectionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartyGetController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Party List',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textRich,
                ),
              ),
              SizedBox(height: 0.5.h),
              Obx(() => Text(
                    '${controller.filteredParties.length} Parties',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
            ],
          ),
          // const PartyTypeToggle(),
        ],
      ),
    );
  }
}

class PartyTypeToggle extends StatelessWidget {
  const PartyTypeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PartyTypeButton(label: 'Customer', type: 'customer'),
        SizedBox(width: 2.w),
        PartyTypeButton(label: 'Supplier', type: 'supplier'),
      ],
    );
  }
}

class PartyTypeButton extends StatelessWidget {
  final String label;
  final String type;

  const PartyTypeButton({
    Key? key,
    required this.label,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartyGetController>();

    return Obx(() {
      final isSelected = controller.selectedParty.value.toLowerCase() == type;
      return GestureDetector(
        onTap: () => controller.selectParty(type),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryColor
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 15.sp,
            ),
          ),
        ),
      );
    });
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 2.h),
          Text(
            message,
            style: AppTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 48, color: AppTheme.textMedium),
          SizedBox(height: 2.h),
          Text('No parties found', style: AppTheme.titleMedium),
          SizedBox(height: 1.h),
          Text('Add your first party to get started',
              style: AppTheme.bodyMedium),
        ],
      ),
    );
  }
}

class NoPartyTypeView extends StatelessWidget {
  final String partyType;

  const NoPartyTypeView({Key? key, required this.partyType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off_outlined, size: 48, color: AppTheme.textMedium),
          SizedBox(height: 2.h),
          Text('No $partyType found', style: AppTheme.titleMedium),
          SizedBox(height: 1.h),
          Text(
            'Add a new $partyType or switch party type',
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PartyListView extends StatelessWidget {
  final List<dynamic> parties;

  const PartyListView({Key? key, required this.parties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: parties.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.2),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final party = parties[index].data() as Map<String, dynamic>;
        return PartyCard(party: party);
      },
    );
  }
}

class PartyCard extends StatelessWidget {
  final Map<String, dynamic> party;

  const PartyCard({Key? key, required this.party}) : super(key: key);

  String _formatAmount(int amount) {
    return NumberFormat('#,##,###').format(amount);
  }

  void _navigateToDetail() {
    Get.to(() => PartyDetailPage(
          partyCompany: party['company'],
          partyId: party['partyId'],
          partyName: party['name'],
          partyPhone: party['phone'],
          partyaddress: party['address'],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final name = party['name'] ?? 'Unknown Party';
    final company = party['company'] ?? 'No Company';
    final creditAmount = (party['creditAmount'] ?? 0).toInt();
    final isSupplier = party['type'] == 'supplier';

    return Material(
      color: AppTheme.cardLight,
      child: InkWell(
        onTap: _navigateToDetail,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 2.5.h), // Increased vertical padding
          child: Row(
            children: [
              PartyAvatar(name: name),
              SizedBox(width: 3.5.w), // Slightly increased spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp, // Increased from 15.sp
                        color: AppTheme.textRich,
                      ),
                    ),
                    if (company != 'No Company') ...[
                      SizedBox(height: 0.8.h), // Increased spacing
                      Text(
                        company,
                        style: TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 14.sp, // Increased from 13.sp
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        isSupplier
                            ? Icons.arrow_circle_up_outlined
                            : Icons.arrow_circle_down_outlined,
                        size: 18, // Increased from 16
                        color: isSupplier ? Colors.red : Colors.green,
                      ),
                      SizedBox(width: 1.2.w), // Slightly increased
                      Text(
                        '₹${_formatAmount(creditAmount)}',
                        style: TextStyle(
                          color: isSupplier ? Colors.red : Colors.green,
                          fontSize: 16.sp, // Increased from 15.sp
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h), // Increased spacing
                  Text(
                    isSupplier ? 'Payable' : 'Receivable',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12.sp, // Increased from 11.sp
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

class PartyAvatar extends StatelessWidget {
  final String name;

  const PartyAvatar({Key? key, required this.name}) : super(key: key);

  String get initials {
    if (name.length > 1) return name.substring(0, 2).toUpperCase();
    if (name.length == 1) return name[0].toUpperCase();
    return 'UN';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45, // Increased from 40
      height: 45, // Increased from 40
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.7),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 15.sp, // Increased from 14.sp
          ),
        ),
      ),
    );
  }
}

class PartyCardContent extends StatelessWidget {
  final String name;
  final String company;
  final String phone;

  const PartyCardContent({
    Key? key,
    required this.name,
    required this.company,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          PartyAvatar(name: name),
          SizedBox(width: 4.w),
          Expanded(
            child: PartyInfo(
              name: name,
              company: company,
              phone: phone,
            ),
          ),
        ],
      ),
    );
  }
}

class PartyInfo extends StatelessWidget {
  final String name;
  final String company;
  final String phone;

  const PartyInfo({
    Key? key,
    required this.name,
    required this.company,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 0.3.h),
        company != ''
            ? Text(
                company,
                style: TextStyle(
                  color: AppTheme.textMedium,
                  fontSize: 13.sp,
                ),
              )
            : Row(
                children: [
                  Icon(Icons.phone, size: 14, color: AppTheme.textLight),
                  SizedBox(width: 1.w),
                  Text(
                    phone,
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
        SizedBox(height: 0.3.h),
      ],
    );
  }
}
