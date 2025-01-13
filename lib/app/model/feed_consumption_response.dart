class FeedConsumptionResponseModel {
  final String? consumptionId;
  final String batchId;
  final String adminId;
  final String yearMonth; // Nepali year-month for filtering (e.g., "2080-12")
  final String consumptionDate;

  // Feed Details
  final double quantityKg; // Amount of feed in kilograms
  final String feedType; // Type of feed (e.g., 'starter', 'grower', 'layer')

  FeedConsumptionResponseModel({
    this.consumptionId,
    required this.batchId,
    required this.adminId,
    required this.yearMonth,
    required this.consumptionDate,
    required this.quantityKg,
    required this.feedType,
  });

  factory FeedConsumptionResponseModel.fromJson(Map<String, dynamic> json,
      {String? consumptionId}) {
    return FeedConsumptionResponseModel(
      consumptionId: consumptionId ?? json['consumptionId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      consumptionDate: json['consumptionDate'] ?? '',
      quantityKg: (json['quantityKg'] ?? 0).toDouble(),
      feedType: json['feedType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'consumptionDate': consumptionDate,
      'quantityKg': quantityKg,
      'feedType': feedType,
    };
  }
}
