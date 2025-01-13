import 'package:flutter/material.dart';
import 'package:poultry/app/utils/batch_card/active_batch_seciton.dart';

class FarmStatusCard extends StatelessWidget {
  const FarmStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Header with Profile
          _buildModernHeader(isSmallScreen),

          const SizedBox(height: 20),

          const SizedBox(height: 24),

          ActiveBatchesSection(),
        ],
      ),
    );
  }

  Widget _buildModernHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row with Profile and Weather
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: isSmallScreen ? 20 : 24,
                    backgroundColor: Colors.white,
                    child: Text(
                      'R',
                      style: TextStyle(
                        color: Colors.indigo.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 18 : 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Ram Krishna',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Weather Widget
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.yellow.shade300,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '25°C',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Farm Overview
          Row(
            children: [
              Expanded(
                child: _buildOverviewStat(
                  'Today\'s Production',
                  '10,850',
                  'eggs collected',
                  Icons.egg_outlined,
                  isSmallScreen,
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildOverviewStat(
                  'Average Rate',
                  '87%',
                  'laying rate',
                  Icons.show_chart,
                  isSmallScreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatsSection(bool isSmallScreen) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMainStatCard(
          'Total Birds',
          '12,450',
          Icons.pets,
          Colors.blue,
          ['+45 today', '98% healthy'],
          isSmallScreen,
        ),
        _buildMainStatCard(
          'Feed Stock',
          '2.5 tons',
          Icons.inventory_2,
          Colors.orange,
          ['4 days left', '120g/bird'],
          isSmallScreen,
        ),
        _buildMainStatCard(
          'Mortality',
          '0.5%',
          Icons.monitor_heart_outlined,
          Colors.red,
          ['12 this month', 'Normal range'],
          isSmallScreen,
        ),
        _buildMainStatCard(
          'Revenue',
          '\$15,240',
          Icons.account_balance_wallet,
          Colors.green,
          ['+\$1,200 today', '87% margin'],
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildOverviewStat(
    String label,
    String value,
    String subtitle,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: isSmallScreen ? 11 : 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 18 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 11 : 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMainStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    List<String> details,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 11 : 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: details.map((detail) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    detail,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmallScreen ? 10 : 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
