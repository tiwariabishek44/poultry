// modules/register/register_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:poultry/app/model/user_response_model.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/loading_State.dart';
import '../../repository/register_repository.dart';

class RegisterController extends GetxController {
  final RegisterRepository _registerRepository = RegisterRepository();
  var isRegisterLoading = false.obs;
  var registerApiResponse = ApiResponse<UserResponseModel>.initial().obs;

  void registerDummyUser() async {
    isRegisterLoading.value = true;

    final dummyData = {
      "fullName": "Test Admin",
      "phoneNumber": "8888888888",
      "email": "8888888888@gmail.com",
      "farmName": "Test Farm",
      "address": "Test Address",
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
      "isActive": true,
    };
    Get.dialog(
      const LoadingState(text: 'Registering user...'),
      barrierDismissible: false,
    );

    try {
      final response = await _registerRepository.registerUser(dummyData);
      registerApiResponse.value = response;
      if (response.status == ApiStatus.SUCCESS) {
        Get.back(); // Close loading dialog
        // Success handling
      } else {
        Get.back(); // Close loading dialog
        // Error handling
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      // Error handling
    } finally {
      isRegisterLoading.value = false;
    }
  }
}
