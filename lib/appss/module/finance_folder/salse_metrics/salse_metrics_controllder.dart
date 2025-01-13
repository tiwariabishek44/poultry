import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
import 'package:rxdart/rxdart.dart'; // Add this import

class SalesController extends GetxController {
  final loginController = Get.find<PoultryLoginController>();

  // Create an observable for the total sales
  var totalSales = 0.obs;

  // Stream for Egg Sales
  Stream<int> getEggSales(String yearMonth) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) {
      return Stream.value(0); // Return 0 if adminUid is null
    }

    return FirebaseFirestore.instance
        .collection('eggSales')
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      int totalEggSales = 0;
      for (var doc in snapshot.docs) {
        totalEggSales += (doc['totalAmount'] as num).toInt();
      }
      return totalEggSales;
    });
  }

  // Stream for Manure Sales
  Stream<int> getManureSales(String yearMonth) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) {
      return Stream.value(0); // Return 0 if adminUid is null
    }

    return FirebaseFirestore.instance
        .collection('manureSales')
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      int totalManureSales = 0;
      for (var doc in snapshot.docs) {
        totalManureSales += (doc['totalAmount'] as num).toInt();
      }
      return totalManureSales;
    });
  }

  // Stream for Hen Sales
  Stream<int> getHenSales(String yearMonth) {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) {
      return Stream.value(0); // Return 0 if adminUid is null
    }

    return FirebaseFirestore.instance
        .collection('henSales')
        .where('adminUid', isEqualTo: adminUid)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      int totalHenSales = 0;
      for (var doc in snapshot.docs) {
        totalHenSales += (doc['totalAmount'] as num).toInt();
      }
      return totalHenSales;
    });
  }

  // Combine all sales streams to update total sales
  Stream<int> getTotalMonthlySales(String yearMonth) {
    final adminUid = loginController.adminData.value?.uid;

    if (adminUid == null) {
      Get.snackbar('Error', 'Admin data not found');
      return Stream.value(0);
    }

    return CombineLatestStream.combine3(
      getEggSales(yearMonth),
      getManureSales(yearMonth),
      getHenSales(yearMonth),
      (int eggSales, int manureSales, int henSales) =>
          eggSales + manureSales + henSales,
    );
  }

  // New methods for admin metrics
  Stream<int> getCashBalance() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('admins')
        .doc(adminUid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return 0;
      return (snapshot.data()?['cash'] as num?)?.toInt() ?? 0;
    });
  }

  Stream<int> getReceivableBalance() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('admins')
        .doc(adminUid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return 0;
      return (snapshot.data()?['amountReceivable'] as num?)?.toInt() ?? 0;
    });
  }

  Stream<int> getPayableBalance() {
    final adminUid = loginController.adminData.value?.uid;
    if (adminUid == null) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('admins')
        .doc(adminUid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return 0;
      return (snapshot.data()?['amountPayable'] as num?)?.toInt() ?? 0;
    });
  }
}
