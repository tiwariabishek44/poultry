import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class BatchListController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable error message
  final errorMessage = ''.obs;

  Stream<QuerySnapshot> getBatchesStream() {
    try {
      final adminUid = loginController.adminData.value?.uid;

      if (adminUid == null || adminUid.isEmpty) {
        errorMessage.value = 'Please login again to view batches';
        return Stream.error('Admin not logged in');
      }

      return _firestore
          .collection('batches')
          .where('adminUid', isEqualTo: adminUid)
          .snapshots()
          .handleError((error) {
        print('Firestore Error: $error');
        errorMessage.value = 'Failed to load batches. Please try again.';
        return Stream.error(error);
      });
    } catch (e) {
      print('Stream Setup Error: $e');
      errorMessage.value = 'Error loading batches. Please try again.';
      return Stream.error(e);
    }
  }

  Future<void> fetchBatches() async {
    try {
      final adminUid = loginController.adminData.value?.uid;

      if (adminUid == null || adminUid.isEmpty) {
        throw 'Please login again to continue';
      }

      // This will trigger the stream to refresh
      errorMessage.value = '';
    } catch (e) {
      print('Fetch Error: $e');
      errorMessage.value = 'Failed to refresh batches. Please try again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<void> deleteBatch(String batchId) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _firestore.collection('batches').doc(batchId).delete();

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Batch deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to delete batch: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
