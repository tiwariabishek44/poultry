import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'dart:developer' as developer;

class TotalPurchaseController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();

  var totalPurchases = 0.obs;

  Stream<int> getTotalMonthlyPurchases(String yearMonth) {
    final adminUid = loginController.adminData.value?.uid;

    developer.log('Starting purchase calculation for month: $yearMonth');
    developer.log('Admin UID: $adminUid');

    if (adminUid == null) {
      developer.log('Error: Admin UID is null');
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('purchases')
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      int total = 0;
      developer
          .log('Number of purchase documents found: ${snapshot.docs.length}');

      for (var doc in snapshot.docs) {
        final amount = (doc['totalAmount'] as num).toInt();
        developer.log('Purchase ID: ${doc.id}, Amount: $amount');
        total += amount;
      }

      developer.log('Total purchase amount calculated: $total');
      totalPurchases.value = total;
      return total;
    });
  }

  void initializeMonthlyListener(String yearMonth) {
    developer.log('Initializing purchase listener for month: $yearMonth');

    getTotalMonthlyPurchases(yearMonth).listen((total) {
      totalPurchases.value = total;
      developer.log('Updated total purchases value: $total');
    }, onError: (error) {
      developer.log('Error in purchase listener: $error', error: error);
      Get.snackbar('Error', 'Failed to load purchase data');
    }, onDone: () {
      developer.log('Purchase listener completed successfully');
    });
  }

  @override
  void onInit() {
    super.onInit();
    developer.log('TotalPurchaseController initialized');
  }

  @override
  void onClose() {
    developer.log('TotalPurchaseController closing');
    super.onClose();
  }
}
