import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/model/stock_item_reposonse_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/stock_item_reposityr.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

class StockItemController extends GetxController {
  static StockItemController get instance => Get.find();
  final _stockItemRepository = StockItemRepository();
  final _loginController = Get.find<LoginController>();

  // Observable variables
  final _allStockItems = <StockItemResponseModel>[].obs; // Original list
  final filteredStockItems = <StockItemResponseModel>[].obs; // Filtered list
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs;

  // Getter for the displayed items
  List<StockItemResponseModel> get stockItems => filteredStockItems;

  @override
  void onInit() {
    super.onInit();
    fetchStockItems();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedFilter.value == 'all') {
      filteredStockItems.value = _allStockItems.toList();
    } else {
      filteredStockItems.value = _allStockItems
          .where((item) =>
              item.category.toLowerCase() == selectedFilter.value.toLowerCase())
          .toList();
    }
  }

  // Create new stock item
  Future<void> createStockItem({
    required String itemName,
    required String category,
  }) async {
    Get.dialog(
      const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingState(text: 'Loading ...'),
      ),
      barrierDismissible: false,
    );
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        CustomDialog.showError(
          message: 'Admin ID not found. Please login again.',
        );
        return;
      }

      final itemData = {
        'adminId': adminId,
        'itemName': itemName,
        'category': '',
      };

      final response = await _stockItemRepository.createStockItem(itemData);

      Get.back(); // Close the loading dialog
      if (response.status == ApiStatus.SUCCESS) {
        CustomDialog.showSuccess(
          message: 'Stock item added successfully',
          onConfirm: () {
            fetchStockItems(); // Refresh the list
          },
        );
      } else {
        Get.back();
        CustomDialog.showError(
          message: response.message ?? 'Failed to add stock item',
        );
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(message: 'Error adding stock item');
    }
  }

  // Fetch all stock items
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
        _allStockItems.value =
            response.response ?? []; // Store in original list
        _applyFilter(); // Apply current filter to new data
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

  // Delete stock item
  Future<void> deleteStockItem(String itemId) async {
    try {
      Get.dialog(
        const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const LoadingState(text: 'Deleting ...'),
        ),
        barrierDismissible: false,
      );
      final response = await _stockItemRepository.deleteStockItem(itemId);

      if (response.status == ApiStatus.SUCCESS) {
        fetchStockItems(); // Refresh the list
        Get.back(); // Close the loading dialog

        CustomDialog.showSuccess(
          message: 'Stock item deleted successfully',
          onConfirm: () {},
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to delete stock item',
        );
      }
    } catch (e) {
      CustomDialog.showError(message: 'Error deleting stock item');
    }
  }
}
