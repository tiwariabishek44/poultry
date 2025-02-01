class DailyGasModel {
  final String? gasId;
  final String batchId;
  final String date;
  final int totalGasCount; // Number of gas cylinders
  final double rate; // Price per cylinder
  final double totalAmount;
  final String adminId;

  DailyGasModel({
    this.gasId,
    required this.batchId,
    required this.date,
    required this.totalGasCount,
    required this.rate,
    required this.totalAmount,
    required this.adminId,
  });

  factory DailyGasModel.fromJson(Map<String, dynamic> json, {String? gasId}) {
    return DailyGasModel(
      gasId: gasId ?? json['gasId'],
      batchId: json['batchId'] ?? '',
      date: json['date'] ?? '',
      totalGasCount: json['totalGasCount'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      adminId: json['adminId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'date': date,
      'totalGasCount': totalGasCount,
      'rate': rate,
      'totalAmount': totalAmount,
      'adminId': adminId,
    };
  }
}
