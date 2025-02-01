import 'dart:developer';

import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/model/rice_husk_reposnse.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/batch_report_repository.dart';
import 'package:poultry/app/repository/medicine_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class BatchReportController extends GetxController {
  final _repository = BatchReportRepository();
  final _loginController = Get.find<LoginController>();

  final feedConsumptions = <FeedConsumptionResponseModel>[].obs;
  final mortalities = <FlockDeathModel>[].obs;
  final riceHusks = <RiceHuskSpray>[].obs;

  final isLoading = false.obs;
  final error = RxnString();

  final selectedBatchId = ''.obs;
  final selectedBatchName = ''.obs;

//  to fetch the feed consumption
  Future<void> fetchFeedConsumptions() async {
    isLoading.value = true;
    error.value = null;
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        error.value = 'Admin ID not found';
        return;
      }

      final response = await _repository.getMonthlyFeedConsumption(
        adminId: adminId,
        batchId: selectedBatchId.value,
      );

      if (response.status == ApiStatus.SUCCESS) {
        feedConsumptions.value = response.response ?? [];
      } else {
        error.value = response.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

// to fetch the motality
  Future<void> fetchMortalities() async {
    log("thi si the motality report fecingn");
    isLoading.value = true;
    error.value = null;

    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        error.value = 'Admin ID not found';
        return;
      }

      final response = await _repository.getMonthlyMortality(
        adminId: adminId,
        batchId: selectedBatchId.value,
      );

      if (response.status == ApiStatus.SUCCESS) {
        mortalities.value = response.response ?? [];
      } else {
        error.value = response.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  // Add these to the BatchReportController class
  final medications = <FlockMedicationResponseModel>[].obs;

  Future<void> fetchMedications() async {
    isLoading.value = true;
    error.value = null;
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        error.value = 'Admin ID not found';
        return;
      }

      final response = await _repository.getMonthlyMedication(
        adminId: adminId,
        batchId: selectedBatchId.value,
      );

      if (response.status == ApiStatus.SUCCESS) {
        medications.value = response.response ?? [];
      } else {
        error.value = response.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }
}
