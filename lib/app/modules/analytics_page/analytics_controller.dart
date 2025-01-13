import 'dart:developer';
import 'package:get/get.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/batch_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';

class AnalyticsController extends GetxController {
  static AnalyticsController get instance => Get.find();

  final _batchRepository = BatchRepository();
  final _loginController = Get.find<LoginController>();

  // Observable lists for batches
  final batches = <BatchResponseModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _batchRepository.getAllBatches(adminId);

      if (response.status == ApiStatus.SUCCESS) {
        batches.value = response.response ?? [];
        log("Fetched ${batches.length} batches");
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to fetch batches',
        );
      }
    } catch (e) {
      log("Error fetching batches: $e");
      CustomDialog.showError(
        message: 'Something went wrong while fetching batches',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Call this when a new batch is added
  void refreshBatches() {
    fetchBatches();
  }
}
