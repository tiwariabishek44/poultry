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
import 'package:poultry/app/modules/parties_detail/party_list.dart';
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
              TransactionPage(),
              PartyListPage(),
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
                      icon: Icon(LucideIcons.banknote),
                      label: 'Transction',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.wallet),
                      label: 'Finance',
                    ),
                  ],
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width / 4) *
                        controller.selectedIndex.value +
                    (MediaQuery.of(context).size.width / 8) -
                    10,
                bottom: 50,
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

// transaction_page.dart
class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'लेनदेन विवरण',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Add new transaction
            },
            icon: Icon(LucideIcons.plus, color: Colors.white),
            label: Text(
              'नयाँ लेनदेन',
              style: GoogleFonts.notoSansDevanagari(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          _buildTotalCard(),
          SizedBox(height: 3.h),
          _buildTransactionList(),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'आम्दानी',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'रु. 50,000',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppColors.dividerColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'खर्च',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'रु. 30,000',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'हालैका लेनदेनहरू',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            bool isIncome = index % 2 == 0;
            return Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: (isIncome ? Colors.green : Colors.red)
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome ? LucideIcons.arrowDown : LucideIcons.arrowUp,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncome ? 'अन्डा बिक्री' : 'दाना खरिद',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '2024-01-11',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'रु. ${isIncome ? "1,000" : "500"}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
