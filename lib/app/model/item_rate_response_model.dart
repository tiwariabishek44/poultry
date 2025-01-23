class ItemsRateResponseModel {
  final String? rateId;
  final String adminId;
  final String category;
  final String itemName;
  final double rate;

  ItemsRateResponseModel({
    this.rateId,
    required this.adminId,
    required this.category,
    required this.itemName,
    required this.rate,
  });

  factory ItemsRateResponseModel.fromJson(Map<String, dynamic> json,
      {String? rateId}) {
    return ItemsRateResponseModel(
      rateId: rateId ?? json['rateId'],
      adminId: json['adminId'] ?? '',
      category: json['category'] ?? '',
      itemName: json['itemName'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'category': category,
      'itemName': itemName,
      'rate': rate,
    };
  }
}
