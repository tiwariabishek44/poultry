class RiceHuskSpray {
  final String? ricehuskId;
  final String batchId;
  final String adminId;
  final String yearMonth;
  final String date;
  final int totalBags; // Number of bags (bora)
  final String? notes;

  RiceHuskSpray({
    this.ricehuskId,
    required this.batchId,
    required this.adminId,
    required this.yearMonth,
    required this.date,
    required this.totalBags,
    this.notes,
  });

  factory RiceHuskSpray.fromJson(Map<String, dynamic> json,
      {String? ricehuskId}) {
    return RiceHuskSpray(
      ricehuskId: ricehuskId ?? json['ricehuskId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      date: json['date'] ?? '',
      totalBags: json['totalBags'] ?? 0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'date': date,
      'totalBags': totalBags,
      if (notes != null) 'notes': notes,
    };
  }
}
