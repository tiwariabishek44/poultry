// stock_item_selector_controller.dart
import 'package:get/get.dart';
import 'package:poultry/app/model/stock_item_reposonse_model.dart';
import 'package:poultry/app/repository/stock_item_reposityr.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';

// stock_selector_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/stock_item_reposonse_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../modules/login /login_controller.dart';

class StockItemsSelectorController extends GetxController {
  final _stockItemRepository = StockItemRepository();
  final _loginController = Get.find<LoginController>();

  final stockItems = <StockItemResponseModel>[].obs;
  final selectedItem = Rx<StockItemResponseModel?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockItems();
  }

  void selectItem(StockItemResponseModel item) {
    selectedItem.value = item;
    Get.back(); // Close the sheet when an item is selected
  }

  Future<void> fetchStockItems() async {
    isLoading.value = true;
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        CustomDialog.showError(
          message: 'Admin ID not found. Please login again.',
        );
        return;
      }

      final response = await _stockItemRepository.getStockItems(adminId);

      if (response.status == ApiStatus.SUCCESS) {
        stockItems.value = response.response ?? [];
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to fetch stock items',
        );
      }
    } catch (e) {
      CustomDialog.showError(message: 'Error fetching stock items');
    } finally {
      isLoading.value = false;
    }
  }
}

class StockSelectorSheet extends StatelessWidget {
  static Future<void> showSelector() async {
    final controller = Get.find<StockItemsSelectorController>();
    await controller.fetchStockItems();

    await Get.bottomSheet(
      StockSelectorSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockItemsSelectorController>();

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildItemsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Select Item',
              style: GoogleFonts.notoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.x, size: 20.sp),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    final controller = Get.find<StockItemsSelectorController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.stockItems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.package,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Items Available',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: controller.stockItems.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final item = controller.stockItems[index];
          return _buildItemTile(item);
        },
      );
    });
  }

  Widget _buildItemTile(StockItemResponseModel item) {
    final controller = Get.find<StockItemsSelectorController>();
    return Obx(() {
      final isSelected = controller.selectedItem.value?.itemId == item.itemId;
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.package,
            color: Colors.blue,
            size: 20.sp,
          ),
        ),
        title: Text(
          item.itemName,
          style: GoogleFonts.notoSans(
            fontSize: 15.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: isSelected
            ? Icon(LucideIcons.check, color: AppColors.primaryColor)
            : null,
        selected: isSelected,
        onTap: () => controller.selectItem(item),
      );
    });
  }
}
