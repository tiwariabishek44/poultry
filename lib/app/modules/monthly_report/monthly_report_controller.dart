import 'dart:developer';

import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/model/batch_response_model.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/model/my_vaccine_reposnse.dart';
import 'package:poultry/app/model/rice_husk_reposnse.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/monthly_report_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';

class MonthlyReportController extends GetxController {
  final _repository = MonthlyReportRepository();
  final _loginController = Get.find<LoginController>();

  final collections = <EggCollectionResponseModel>[].obs;
  final feedConsumptions = <FeedConsumptionResponseModel>[].obs;
  final mortalities = <FlockDeathModel>[].obs;
  final riceHusks = <RiceHuskSpray>[].obs;
  final vaccines = <MyVaccineResponseModel>[].obs;

  final isLoading = false.obs;
  final error = RxnString();

  final filterController = Get.put(FilterController());

  final items = [
    'Egg Collection',
    'Feeds Consumption',
    'Mortality',
    "भुस Record",
    'Vaccination',
    'Medicaiton'
  ];
  final selectedItem = 'Egg Collection'.obs;

  Future<void> fetchEggCollections() async {
    isLoading.value = true;
    error.value = null;

    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        error.value = 'Admin ID not found';
        return;
      }

      final response = await _repository.getMonthlyEggCollections(
        adminId: adminId,
        yearMonth: filterController.finalDate.value,
        batchId: filterController.selectedBatchId.value,
      );

      if (response.status == ApiStatus.SUCCESS) {
        collections.value = response.response ?? [];
        log(" the empth is ${collections.isEmpty}");
      } else {
        error.value = response.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

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
        yearMonth: filterController.finalDate.value,
        batchId: filterController.selectedBatchId.value,
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
        yearMonth: filterController.finalDate.value,
        batchId: filterController.selectedBatchId.value,
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

  // for the rice-husk
  Future<void> fetchRiceHusks() async {
    isLoading.value = true;
    error.value = null;

    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        error.value = 'Admin ID not found';
        return;
      }

      final response = await _repository.getMonthlyRiceHusk(
        adminId: adminId,
        yearMonth: filterController.finalDate.value,
        batchId: filterController.selectedBatchId.value,
      );

      if (response.status == ApiStatus.SUCCESS) {
        riceHusks.value = response.response ?? [];
      } else {
        error.value = response.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  // to fetch the vaccine
  Future<void> fetchVaccines() async {
    isLoading.value = true;
    error.value = null;

    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) {
        error.value = 'Admin ID not found';
        return;
      }

      final response = await _repository.getMonthlyVaccination(
        adminId: adminId,
        yearMonth: filterController.finalDate.value,
        batchId: filterController.selectedBatchId.value,
      );

      if (response.status == ApiStatus.SUCCESS) {
        vaccines.value = response.response ?? [];
      } else {
        error.value = response.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  void onItemSelected(String item) {
    selectedItem.value = item;
  }

  String get formattedDate {
    final date = NepaliDateFormat('MMMM yyyy').format(NepaliDateTime.now());
    return date;
  }
}
