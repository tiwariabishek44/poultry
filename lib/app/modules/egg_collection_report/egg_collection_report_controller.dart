import 'dart:developer';

import 'package:get/get.dart';
import 'package:poultry/app/model/death_response_model.dart';
import 'package:poultry/app/model/egg_collection_response.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/model/my_vaccine_reposnse.dart';
import 'package:poultry/app/model/rice_husk_reposnse.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/monthly_report_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/filter_dialouge.dart';

class EggCollectionReporController extends GetxController {
  final _repository = MonthlyReportRepository();
  final _loginController = Get.find<LoginController>();

  final collections = <EggCollectionResponseModel>[].obs;

  final isLoading = false.obs;
  final error = RxnString();
  final batchId = ''.obs;
  final filterController = Get.put(FilterController());

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
        yearMonth: '2081-10',
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
}
