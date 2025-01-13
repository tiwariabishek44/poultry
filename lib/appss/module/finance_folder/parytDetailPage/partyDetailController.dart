import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class PartyDetailController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginController = Get.find<PoultryLoginController>();

  final partyName = ''.obs;
  final partyContact = ''.obs;
  final partyAddress = ''.obs;
  final totalBalance = 0.0.obs;
  final selectedTab = 0.obs;

  Stream<QuerySnapshot> getSalesStream(String partyId) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('sales')
        .where('adminUid', isEqualTo: adminUid)
        .where('partyId', isEqualTo: partyId)
        .snapshots();
  }

  Stream<QuerySnapshot> getPaymentsStream(String partyId) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.empty();

    return _firestore
        .collection('payments')
        .where('partyId', isEqualTo: partyId)
        .snapshots();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
