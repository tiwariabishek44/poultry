class StockItemResponseModel {
  final String? itemId;
  final String adminId;
  final String itemName;
  final String category; // Feed, Medicine, Equipment, Other

  StockItemResponseModel({
    this.itemId,
    required this.adminId,
    required this.itemName,
    required this.category,
  });

  factory StockItemResponseModel.fromJson(Map<String, dynamic> json,
      {String? itemId}) {
    return StockItemResponseModel(
      itemId: itemId ?? json['itemId'],
      adminId: json['adminId'] ?? '',
      itemName: json['itemName'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'itemName': itemName,
      'category': category,
    };
  }
}
