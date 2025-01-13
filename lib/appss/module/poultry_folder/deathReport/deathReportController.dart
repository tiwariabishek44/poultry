import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class DeathRecordController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedDate = NepaliDateTime.now().obs;
  final totalDeaths = 0.obs;

  Stream<QuerySnapshot> getDeathRecordsStream(
    String yearmonth,
    String batchId,
    String stage,
  ) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('deaths')
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearmonth)
        .where('batchId', isEqualTo: batchId)
        .where('stage', isEqualTo: stage)
        .snapshots();
  }

  void calculateTotalDeaths(QuerySnapshot snapshot) {
    int total = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += (data['deathCount'] as int?) ?? 0;
    }
    totalDeaths.value = total;
  }

  String formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
