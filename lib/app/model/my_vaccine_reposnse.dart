import 'package:poultry/app/model/vaccination_schedule_model.dart';

class MyVaccineResponseModel {
  final String? vaccineId; // Firestore document ID
  final String batchId; // Reference to the batch
  final String adminId; // Who administered the vaccine
  final String yearMonth; // For filtering (e.g., "2080-12")
  final String vaccineDate; // Date of administration

  // Vaccine Details
  final String vaccineName; // Name of the vaccine given
  final String disease; // Disease being vaccinated against
  final String method; // How it was administered
  final int birdAge; // Age of birds when vaccinated (in days)
  final String birdAgeUnit; // "दिन" or "हप्ता"

  // Status and Notes
  final bool isScheduled; // Whether this was a scheduled vaccination
  final String? nextDueDate; // Date for next dose if applicable
  final String? notes; // Any observations or additional notes
  final bool isCompleted; // Whether the vaccination was completed

  MyVaccineResponseModel({
    this.vaccineId,
    required this.batchId,
    required this.adminId,
    required this.yearMonth,
    required this.vaccineDate,
    required this.vaccineName,
    required this.disease,
    required this.method,
    required this.birdAge,
    required this.birdAgeUnit,
    required this.isScheduled,
    this.nextDueDate,
    this.notes,
    this.isCompleted = true,
  });

  factory MyVaccineResponseModel.fromJson(Map<String, dynamic> json,
      {String? vaccineId}) {
    return MyVaccineResponseModel(
      vaccineId: vaccineId ?? json['vaccineId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      vaccineDate: json['vaccineDate'] ?? '',
      vaccineName: json['vaccineName'] ?? '',
      disease: json['disease'] ?? '',
      method: json['method'] ?? '',
      birdAge: json['birdAge'] ?? 0,
      birdAgeUnit: json['birdAgeUnit'] ?? 'दिन',
      isScheduled: json['isScheduled'] ?? false,
      nextDueDate: json['nextDueDate'],
      notes: json['notes'],
      isCompleted: json['isCompleted'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'batchId': batchId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'vaccineDate': vaccineDate,
      'vaccineName': vaccineName,
      'disease': disease,
      'method': method,
      'birdAge': birdAge,
      'birdAgeUnit': birdAgeUnit,
      'isScheduled': isScheduled,
      'isCompleted': isCompleted,
    };

    // Only add optional fields if they have values
    if (nextDueDate != null) data['nextDueDate'] = nextDueDate!;
    if (notes != null) data['notes'] = notes!;

    return data;
  }

  // Helper method to determine if the vaccination was on schedule
  bool isOnSchedule(VaccinationSchedule schedule) {
    // Find matching scheduled vaccination
    final scheduledVaccine = schedule.schedule.firstWhere(
        (v) => v.vaccine == vaccineName && v.disease == disease,
        orElse: () => VaccineDetail(
            age: "0",
            ageUnit: "दिन",
            disease: "",
            vaccine: "",
            method: "",
            required: false));

    if (scheduledVaccine.disease.isEmpty) return false;

    // Convert schedule age to days for comparison
    int scheduledAgeDays = int.parse(scheduledVaccine.age);
    if (scheduledVaccine.ageUnit == "हप्ता") {
      scheduledAgeDays *= 7;
    }

    // Convert actual age to days for comparison
    int actualAgeDays = birdAge;
    if (birdAgeUnit == "हप्ता") {
      actualAgeDays *= 7;
    }

    // Allow a 2-day window on either side of scheduled date
    return (actualAgeDays - scheduledAgeDays).abs() <= 2;
  }

  // Helper method to get status text
  String getStatusText() {
    if (!isCompleted) return "Pending";
    if (isScheduled && isOnSchedule(VaccinationSchedule())) {
      return "On Schedule";
    } else if (isScheduled) {
      return "Off Schedule";
    }
    return "Completed";
  }

  // Helper to calculate next due date based on current schedule
  String? calculateNextDueDate(VaccinationSchedule schedule) {
    // Find the next scheduled vaccination after current bird age
    int currentAgeDays = birdAge;
    if (birdAgeUnit == "हप्ता") currentAgeDays *= 7;

    var nextVaccine = schedule.schedule.where((v) {
      int scheduleAge = int.parse(v.age);
      if (v.ageUnit == "हप्ता") scheduleAge *= 7;
      return scheduleAge > currentAgeDays;
    }).fold<VaccineDetail?>(null, (prev, curr) {
      if (prev == null) return curr;
      int prevAge = int.parse(prev.age);
      if (prev.ageUnit == "हप्ता") prevAge *= 7;
      int currAge = int.parse(curr.age);
      if (curr.ageUnit == "हप्ता") currAge *= 7;
      return prevAge < currAge ? prev : curr;
    });

    return nextVaccine?.age;
  }
}
