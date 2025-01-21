// modules/dashboard/dashboard_header_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:poultry/app/model/user_response_model.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/user_data_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class DashboardHeaderController extends GetxController {
  static DashboardHeaderController get instance => Get.find();

  final _userDataRepository = UserDataRepository();
  final _loginController = Get.find<LoginController>();

  final farmName = ''.obs;
  final farmAddress = ''.obs;
  // farmer name
  final farmerName = ''.obs;
  final temperature =
      '25°C'.obs; // Default value, can be updated with real weather API
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;

    try {
      final userId = _loginController.adminUid;
      if (userId != null) {
        final response = await _userDataRepository.getUserData(userId);

        if (response.status == ApiStatus.SUCCESS && response.response != null) {
          farmName.value = response.response!.farmName ?? 'My Farm';
          farmAddress.value = response.response!.address ?? 'No Address';
          farmerName.value = response.response!.fullName ?? 'No Name';
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // You can add weather fetching logic here if needed
  Future<void> fetchWeatherData() async {
    // Implement weather API integration
  }
}
