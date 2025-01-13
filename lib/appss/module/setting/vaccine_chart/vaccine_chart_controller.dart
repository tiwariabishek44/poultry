import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// Vaccine Model
class VaccineModel {
  String? id; // Firebase-generated ID
  String name;
  int flockAge; // Stored as days
  String monthRange;

  VaccineModel({
    this.id,
    required this.name,
    required this.flockAge,
    required this.monthRange,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flockAge': flockAge,
      'monthRange': monthRange,
    };
  }

  // Convert from Firebase Map
  factory VaccineModel.fromMap(Map<String, dynamic> map, String id) {
    return VaccineModel(
      id: id,
      name: map['name'],
      flockAge: map['flockAge'],
      monthRange: map['monthRange'],
    );
  }
}

// Vaccine Controller
class VaccineController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Month Ranges
  final List<String> monthRanges = [
    'Chick Stage (Month 0-1)',
    'Grower Stage (Month 2-4)',
    'Developer Stage (Month 5-8)',
    'Layer Stage (Month 9-18)',
    'Peak Production (Month 19-24)',
    'Late Layer (Month 25-36)',
  ];

// Vaccines for Late Layer (Month 25-36)
  final List<VaccineModel> lateLayerVaccines = [
    VaccineModel(
        name: 'Marek’s Disease Vaccine',
        flockAge: 750, // Flock age in days (25 months)
        monthRange: 'Late Layer (Month 25-36)'),
    VaccineModel(
        name: 'Newcastle Disease Vaccine',
        flockAge: 780, // Flock age in days
        monthRange: 'Late Layer (Month 25-36)'),
    VaccineModel(
        name: 'Infectious Bronchitis Vaccine',
        flockAge: 810, // Flock age in days
        monthRange: 'Late Layer (Month 25-36)'),
    VaccineModel(
        name: 'Fowl Pox Vaccine',
        flockAge: 840, // Flock age in days
        monthRange: 'Late Layer (Month 25-36)'),
  ];

  // Method to Upload Vaccines
  Future<void> uploadVaccines(List<VaccineModel> vaccines) async {
    final collectionRef = _firestore.collection('vaccines');

    // Iterate through each vaccine and add it to Firestore
    for (var vaccine in vaccines) {
      // Add vaccine to Firestore
      var docRef = await collectionRef.add(vaccine.toMap());

      // Set the id from the document ID in Firestore
      vaccine.id = docRef.id;
      print('Uploaded Vaccine: ${vaccine.name}, ID: ${vaccine.id}');
    }
  }

  // Initialize Controller
  @override
  void onInit() {
    super.onInit();
    _uploadChickStageVaccinesOnInit();
  }

  // Upload Chick Stage Vaccines Automatically on Initialization
  Future<void> _uploadChickStageVaccinesOnInit() async {
    try {
      print("Uploading Chick Stage Vaccines...");
      await uploadVaccines(lateLayerVaccines);
      print("Chick Stage Vaccines uploaded successfully!");
    } catch (e) {
      print("Failed to upload Chick Stage Vaccines: $e");
    }
  }
}
