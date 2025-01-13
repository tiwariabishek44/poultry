import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';

class CountData {
  int crates = 0;
  int remaining = 0;
  String displayCrates = '0.0';
}

class EggCountController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginController = Get.find<PoultryLoginController>();

  Stream<Map<String, CountData>> getEggCountStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value({});

    return _firestore
        .collection('eggCollections')
        .where('adminUid', isEqualTo: adminUid)
        .snapshots()
        .map((snapshot) {
      Map<String, CountData> counts = {
        'small': CountData(),
        'medium': CountData(),
        'large': CountData(),
        'extra large': CountData(),
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['eggCategory'].toString().toLowerCase();
        final crates = data['crates'] as int;
        final remaining = data['remainingEggs'] as int;

        if (counts.containsKey(category)) {
          counts[category]!.crates += (crates * 30);
          counts[category]!.remaining += remaining;
          counts[category]!.displayCrates = formatCrateCount(
              counts[category]!.crates + counts[category]!.remaining);
        }
      }
      return counts;
    });
  }

  String formatCrateCount(int totalEggs) {
    double crates = totalEggs / 30;
    return crates.toStringAsFixed(1);
  }

  Stream<double> getTotalCreditStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value(0.0);

    return _firestore
        .collection('parties')
        .where('adminUid', isEqualTo: adminUid)
        .where('isCredit', isEqualTo: true) // Only get parties with credit
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.fold(0.0,
          (sum, doc) => sum + (doc.data()['creditAmount'] as num).toDouble());
    });
  }

  Stream<String> getCrackEggCountStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value('0.0');

    return _firestore
        .collection('eggWaste')
        .where('adminUid', isEqualTo: adminUid)
        .snapshots()
        .map((snapshot) {
      int totalEggs = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final crates = (data['crates'] as int) * 30;
        final remaining = data['remainingEggs'] as int;
        totalEggs += crates + remaining;
      }

      return (totalEggs / 30).toStringAsFixed(1);
    });
  }

  Stream<int> getDeathCountStream() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) return Stream.value(0);

    return _firestore
        .collection('deaths')
        .where('adminUid', isEqualTo: adminUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .fold(0, (sum, doc) => sum + (doc.data()['deathCount'] as int));
    });
  }
}
