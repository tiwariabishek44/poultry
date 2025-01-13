// lib/screens/poultry_home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/finance_main_screen/utility/finanace_tab.dart';
import 'package:poultry/appss/module/finance_folder/party/partyAddPage.dart';

class FinanceManagementPage extends StatefulWidget {
  const FinanceManagementPage({Key? key}) : super(key: key);

  @override
  State<FinanceManagementPage> createState() => _FinanceManagementPageState();
}

class _FinanceManagementPageState extends State<FinanceManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text('Finance Management',
            style: AppTheme.displayMedium.copyWith(color: Colors.white)),
      ),
      body: FinanceTab(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B4513), // Reddish brown
            Color(0xFF6D4C41), // Brown grey
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(() => AddPartyScreen());
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.people_outline, // Changed to people icon
                  color: Colors.white,
                  size: 20, // Slightly smaller icon
                ),
                SizedBox(width: 8),
                Text(
                  'Add Party',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
