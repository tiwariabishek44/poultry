// base_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/base_screen/base_screen_controller.dart';
import 'package:poultry/app/modules/dashboard/dashboard.dart';
import 'package:poultry/app/modules/home_screen/dash.dart';
import 'package:poultry/app/modules/home_screen/home_screen.dart';
import 'package:poultry/app/modules/finance_main_page/finance_main_page.dart';
import 'package:poultry/app/modules/transction_main_screen/transction_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaseScreen extends StatelessWidget {
  final controller = Get.put(BaseScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              PoultryDashboard(),
              HomeScreen(),
              FinanceMainScreen(),
              TransactionsScreen(), // Add the new screen here
            ],
          )),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                height: 70, // Increase the height as needed
                child: BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.changeIndex,
                  backgroundColor: Colors.white,
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.textSecondary,
                  selectedLabelStyle: GoogleFonts.notoSansDevanagari(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.notoSansDevanagari(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.layoutDashboard),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.activity),
                      label: 'Activity',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.wallet),
                      label: 'Finance',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.creditCard),
                      label: 'Transaction',
                    ),
                  ],
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width / 4) *
                        controller.selectedIndex.value +
                    (MediaQuery.of(context).size.width / 8) -
                    10,
                bottom: 60,
                child: Container(
                  width: 20,
                  height: 3,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
