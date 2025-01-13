import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class BatchDropDownController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final selectedBatchId = ''.obs;
  final selectedBatchName = ''.obs;
  final currentCount = 0.obs;
  final totaldeath = 0.obs;
  final flockStage = ''.obs;
  final currentFeed = ''.obs;

  Stream<QuerySnapshot> getBatchesStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('batches')
        .where('adminUid', isEqualTo: adminUid)
        .snapshots();
  }
}
