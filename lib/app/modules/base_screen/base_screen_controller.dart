// base_screen_controller.dart
import 'package:get/get.dart';

class BaseScreenController extends GetxController {
  static BaseScreenController get instance => Get.find();

  final selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
