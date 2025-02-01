// finance_filter_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';

class FinanceFilterBar extends StatelessWidget {
  final PartyController controller;

  const FinanceFilterBar({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            _buildFilterChip('Customers', 'customer'),
            SizedBox(width: 12),
            _buildFilterChip('Suppliers', 'supplier'),
            SizedBox(width: 12),
            _buildFilterChip('To Receive', 'to_receive'),
            SizedBox(width: 12),
            _buildFilterChip('To Pay', 'to_pay'),
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
            color: isSelected
                ? AppColors.primaryColor
                : Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : const Color.fromARGB(255, 149, 149, 149)!,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.notoSans(
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 33, 33, 33),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }
}
