import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/appss/module/activity_folder/activity_folder_mainScreen/batchList.dart';
import 'package:poultry/appss/module/activity_folder/EggCollection/eggCollecitonPage.dart';
import 'package:poultry/appss/module/activity_folder/batch/addBatchPage.dart';
import 'package:poultry/appss/module/activity_folder/feed_consumption/feed_Consumption.dart';
import 'package:poultry/appss/module/activity_folder/death/deathPage.dart';
import 'package:poultry/appss/module/activity_folder/waste/wastePage.dart';
import 'package:poultry/appss/module/setting/vaccine_chart/vaccine_chart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActivityConstants {
  static const primaryColor = Color(0xFF8B4513);
  static const secondaryColor = Color(0xFFD2691E);
  static const backgroundColor = Color(0xFFF5E6E0);

  static final menuItems = [
    MenuItem(
      title: 'New Batch',
      subtitle: 'Create and manage new batches',
      icon: Icons.add_circle_outline,
      page: AddBatchScreen(),
      category: MenuCategory.management,
    ),
    MenuItem(
      title: 'Egg Collection',
      subtitle: 'Record daily egg collections',
      icon: Icons.egg_outlined,
      page: EggCollectionScreen(),
      category: MenuCategory.production,
    ),
    MenuItem(
      title: 'Death Entry',
      subtitle: 'Monitor mortality rates',
      icon: Icons.report_outlined,
      page: DeathEntryScreen(),
      category: MenuCategory.health,
    ),
    MenuItem(
      title: 'Egg Waste Entry',
      subtitle: 'Track damaged eggs',
      icon: Icons.egg_alt_outlined,
      page: WasteEggCollectionScreen(),
      category: MenuCategory.production,
    ),
    MenuItem(
      title: 'Daily Feed',
      subtitle: 'Monitor feed usage',
      icon: Icons.grain_outlined,
      page: FeedConsumptionScreen(),
      category: MenuCategory.management,
    ),
    MenuItem(
      title: 'Vaccination',
      subtitle: 'Track vaccination schedule',
      icon: LucideIcons.syringe,
      page: VaccineChartPage(),
      category: MenuCategory.health,
    ),
    MenuItem(
      title: 'Batch Retire',
      subtitle: 'Complete batch lifecycle',
      icon: Icons.delete_forever_outlined,
      page: BatchList(isBatchUpgrade: false),
      category: MenuCategory.management,
    ),
  ];
}

enum MenuCategory {
  management,
  production,
  health;

  String get displayName {
    switch (this) {
      case MenuCategory.management:
        return 'Farm Management';
      case MenuCategory.production:
        return 'Production';
      case MenuCategory.health:
        return 'Health & Monitoring';
    }
  }

  Color get color {
    switch (this) {
      case MenuCategory.management:
        return Colors.blue;
      case MenuCategory.production:
        return Colors.green;
      case MenuCategory.health:
        return Colors.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case MenuCategory.management:
        return LucideIcons.settings;
      case MenuCategory.production:
        return LucideIcons.warehouse;
      case MenuCategory.health:
        return LucideIcons.stethoscope;
    }
  }
}

class MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
  final MenuCategory category;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
    required this.category,
  });
}

class ActivityMainScreen extends StatelessWidget {
  const ActivityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Flock Management',
          style: GoogleFonts.notoSansDevanagari(
              fontSize: 20, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFFCD853F),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage your farm Efficiently',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B4513),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 16,
        childAspectRatio: 2.8,
      ),
      itemCount: ActivityConstants.menuItems.length,
      itemBuilder: (context, index) {
        final item = ActivityConstants.menuItems[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.page),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    const Color.fromARGB(255, 129, 128, 128).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 129, 128, 128).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(item.icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
