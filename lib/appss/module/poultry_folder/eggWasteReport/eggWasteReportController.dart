import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

// Updated Controller
class EggWasteReportController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedDate = NepaliDateTime.now().obs;
  final totalEggs = 0.obs;

  Stream<QuerySnapshot> getCollectionsStream(String yearmonth) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('eggWaste')
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
