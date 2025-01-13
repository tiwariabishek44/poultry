// // dashboard_controller.dart
// import 'package:get/get.dart';
// import 'package:poultry/app/modules/login%20/login_controller.dart';
// import 'package:poultry/app/repository/batch_repository.dart';
// import 'package:poultry/app/model/batch_response_model.dart';
// import 'package:poultry/app/service/api_client.dart';

// class DashboardController extends GetxController {
//   static DashboardController get instance => Get.find();

//   final _batchRepository = BatchRepository();
//   final _loginController = Get.find<LoginController>();
//   final _batchStreamController = BatchStreamController.instance;

//   final batches = <BatchResponseModel>[].obs;
//   final isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBatches();
//     // Listen to the stream of batch updates
//     ever(_batchStreamController.batchStream, (_) => fetchBatches());
//   }

//   Future<void> fetchBatches() async {
//     isLoading.value = true;
//     try {
//       final adminId = _loginController.adminUid;
//       if (adminId != null) {
//         final response = await _batchRepository.getAllBatches(adminId);
//         if (response.status == ApiStatus.SUCCESS && response.response != null) {
//           batches.value = response.response!;
//         }
//       }
//     } catch (e) {
//       print('Error fetching batches: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   List<BatchResponseModel> getBatchesByStage(String stage) {
//     return batches.where((batch) => batch.stage == stage).toList();
//   }
// }

// class BatchStreamController extends GetxController {
//   static BatchStreamController get instance => Get.put(BatchStreamController());

//   final batchStream = false.obs;

//   void notifyBatchUpdate() {
//     batchStream.toggle(); // Toggle to notify observers
//   }
// }
