import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class FeedConsumptionReportController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedDate = NepaliDateTime.now().obs;
  final totalFeed = 0.0.obs;

  Stream<QuerySnapshot> getConsumptionsStream(
      String yearmonth, String batchId) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('feedConsumptions')
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearmonth)
        .where('batchId', isEqualTo: batchId)
        .snapshots();
  }

  void calculateTotalFeed(QuerySnapshot snapshot) {
    double total = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += (data['totalFeed'] as num?)?.toDouble() ?? 0.0;
    }
    totalFeed.value = total;
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
