import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/module/activity_folder/activity_folder_mainScreen/activity_folder_mainScreen.dart';
import 'package:poultry/appss/module/finance_folder/finance_main_screen/finance_main_screen.dart';
import 'package:poultry/appss/module/poultry_folder/home_screen_tabs/poultry_dashboard_screen.dart';
import 'package:poultry/appss/module/setting/setting_main_screen/setting_main_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Navigation Tabs Enum remains the same
enum NavigationTab {
  dashboard,
  activity,

  finance,
  setting;

  String get label {
    switch (this) {
      case NavigationTab.dashboard:
        return 'Poultry';
      case NavigationTab.finance:
        return 'Finance';
      case NavigationTab.activity:
        return 'Activity';
      case NavigationTab.setting:
        return 'Setting';
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.dashboard:
        return Icons.home_outlined;
      case NavigationTab.finance:
        return Icons.account_balance_wallet_outlined;
      case NavigationTab.activity:
        return LucideIcons.syringe;
      case NavigationTab.setting:
        return Icons.settings_outlined;
    }
  }

  Widget get screen {
    switch (this) {
      case NavigationTab.dashboard:
        return PoultryDashboardScreen();
      case NavigationTab.finance:
        return FinanceManagementPage();
      case NavigationTab.activity:
        return ActivityMainScreen();
      case NavigationTab.setting:
        return SettingsPage();
    }
  }
}

// Navigation Controller remains the same
class PoultryNavigationController extends GetxController {
  final _currentTab = NavigationTab.dashboard.obs;
  final PageStorageBucket bucket = PageStorageBucket();

  NavigationTab get currentTab => _currentTab.value;
  Widget get currentScreen => currentTab.screen;

  void changeTab(NavigationTab tab) {
    _currentTab.value = tab;
  }
}

// Main Screen remains the same
class PoultryMainScreen extends StatelessWidget {
  PoultryMainScreen({super.key});

  final navigationController = Get.put(PoultryNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SafeArea(
          child: PageStorage(
            bucket: navigationController.bucket,
            child: navigationController.currentScreen,
          ),
        ),
      ),
      bottomNavigationBar: const PoultryBottomNavBar(),
    );
  }
}

// Updated Bottom Navigation Bar with reduced height
class PoultryBottomNavBar extends StatelessWidget {
  const PoultryBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PoultryNavigationController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 110, 109, 109).withOpacity(0.4),
            blurRadius: 1,
            offset: const Offset(1, -1),
          ),
        ],
      ),
      child: BottomAppBar(
        height: 75, // Reduced from 75
        elevation: 0,
        padding: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: NavigationTab.values
                .map(
                  (tab) => _NavBarItem(
                    tab: tab,
                    isSelected: controller.currentTab == tab,
                    onTap: () => controller.changeTab(tab),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

// Updated Navigation Bar Item with smaller dimensions
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final NavigationTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 6), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tab.icon,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : Color.fromARGB(255, 8, 8, 8),

              size: 18.sp, // Reduced from 20.sp
            ),
            SizedBox(height: 2), // Reduced from 4
            Text(
              tab.label,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 15.sp, // Reduced from 14.5.sp
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : Color.fromARGB(255, 8, 8, 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
