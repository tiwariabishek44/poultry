import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

// import 'package:device_info_plus/device_info_plus.dart';

// Updated Controller
class EggCollectionReportController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedDate = NepaliDateTime.now().obs;
  final totalEggs = 0.obs;
  final isGeneratingPdf = false.obs;
  final isDownloading = false.obs;

  Stream<QuerySnapshot> getCollectionsStream(String yearmonth, String batchId) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('eggCollections')
        .where('batchId', isEqualTo: batchId)
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearmonth)
        .snapshots();
  }

  void calculateTotalEggs(QuerySnapshot snapshot) {
    int total = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += (data['totalEggs'] as int?) ?? 0;
    }
    totalEggs.value = total;
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
