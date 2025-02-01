import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_expense/add_expense_page.dart';
import 'package:poultry/app/modules/add_party/add_parties.dart';
import 'package:poultry/app/modules/finance_main_page/utils/filter.dart';
import 'package:poultry/app/modules/finance_main_page/utils/finance_hearder.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/modules/parties_detail/party_detail_page.dart';
import 'package:poultry/app/modules/stock_item/stock_item_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Filter Header Delegate for sticky filter
class FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PartyController controller;
  final bool isDarkMode;

  FilterHeaderDelegate({required this.controller, required this.isDarkMode});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF8FAFC),
      child: FinanceFilterBar(
        controller: controller,
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant FilterHeaderDelegate oldDelegate) {
    return isDarkMode != oldDelegate.isDarkMode;
  }
}

class FinanceMainScreen extends StatefulWidget {
  const FinanceMainScreen({Key? key}) : super(key: key);

  @override
  State<FinanceMainScreen> createState() => _FinanceMainScreenState();
}

class _FinanceMainScreenState extends State<FinanceMainScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(PartyController());
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final currencyFormat = NumberFormat('#,##,###');
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildEnhancedAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      scrolledUnderElevation: 0,
      expandedHeight: _showSearch ? 120 : 60,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          'Finance Management',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'export', child: Text('Export Data')),
            const PopupMenuItem(value: 'settings', child: Text('Settings')),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPartyCard(dynamic party) {
    final bool isPayable = party.partyType == 'supplier';
    final String amountLabel = party.creditAmount == 0
        ? 'Settel' // Settled in Nepali
        : (isPayable
            ? 'To Pay' // To Pay in Nepali
            : 'To Revice'); // To Pay/To Receive in Nepali
    final Color amountColor = party.creditAmount == 0
        ? const Color(0xFF64748B) // Grey for settled
        : (isPayable
            ? const Color(0xFFDC2626)
            : const Color(0xFF059669)); // Red for payable, Green for receivable

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.to(() => PartyDetailsPage(partyId: party.partyId!)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Party Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          party.partyName,
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.phone,
                              size: 14,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              party.phoneNumber,
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Amount Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amountLabel,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'रु. ${NumberFormat('#,##,###').format(party.creditAmount)}',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Icon(LucideIcons.users, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Parties (कुनै पार्टीहरू छैनन् )',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildEnhancedAppBar(),
          // Financial Metrics
          SliverToBoxAdapter(
            child: FinancialMetrics(isDarkMode: isDarkMode),
          ),
          // Party List Header - Moved above filter
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Party List',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.to(() => AddPartyPage());
                    },
                    icon: const Icon(Icons.person_add_outlined, size: 18),
                    label: const Text('Add Party'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0EA5E9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sticky Filter Header - Moved below Party List header
          SliverPersistentHeader(
            pinned: true,
            delegate: FilterHeaderDelegate(
              controller: controller,
              isDarkMode: isDarkMode,
            ),
          ),
          // Party List

          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredParties.isEmpty) {
                return _buildEmptyState();
              }

              // Simple alphabetical sorting
              final sortedParties = controller.filteredParties.toList()
                ..sort((a, b) => a.partyName
                    .toLowerCase()
                    .compareTo(b.partyName.toLowerCase()));

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 42.h),
                  itemCount: sortedParties.length,
                  itemBuilder: (context, index) {
                    final party = sortedParties[index];
                    return _buildPartyCard(party);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'financepage',
        backgroundColor: AppColors.success,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          _showMenu(context);
        },
      ),

      // Floating Action Button
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
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

            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add New Party(नयाँ पार्टी थप्नुहोस्)'),
              onTap: () {
                // Handle add new batch action
                Navigator.pop(context);
                Get.to(() => AddPartyPage());
              },
            ),
            // for daily feed
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Expense (खर्च)'),
              onTap: () {
                // Handle daily feed record action
                Navigator.pop(context);
                Get.to(() => AddExpensePage());
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Stock Items(स्टक item)'),
              onTap: () {
                // Handle mortality record action
                Navigator.pop(context);
                Get.to(() => StockItemsListPage());
              },
            ),

            SizedBox(height: 15.h),
          ],
        );
      },
    );
  }
}
