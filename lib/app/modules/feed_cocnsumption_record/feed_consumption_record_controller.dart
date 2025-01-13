import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/model/feed_consumption_response.dart';
import 'package:poultry/app/repository/feed_consumption_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';

class FeedConsumptionListController extends GetxController {
  final _feedConsumptionRepository = FeedConsumptionRepository();
  final feedConsumptions = <FeedConsumptionResponseModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch with current month
    final now = NepaliDateTime.now();
    String currentYearMonth =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
    fetchFeedConsumptions(currentYearMonth);
  }

  Future<void> fetchFeedConsumptions(String yearMonth) async {
    isLoading.value = true;

    try {
      final response =
          await _feedConsumptionRepository.getFeedConsumptionByMonth(yearMonth);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        feedConsumptions.value = response.response!;
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to fetch feed consumption data',
        );
      }
    } catch (e) {
      log("Error fetching feed consumptions: $e");
      CustomDialog.showError(
        message: 'Failed to fetch feed consumption data',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
