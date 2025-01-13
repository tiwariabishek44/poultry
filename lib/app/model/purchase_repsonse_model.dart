// Purchase Item model for individual items in a purchase
class PurchaseItem {
  final String itemName;
  final String category; // 'product', 'service'
  final String?
      subcategory; // 'feed', 'medicine', 'equipment', 'maintenance', etc.
  final double rate;
  final double quantity;
  final String? unit; // 'kg', 'pieces', 'bags', etc.
  final double total;
  final String? description;

  PurchaseItem({
    required this.itemName,
    required this.category,
    this.subcategory,
    required this.rate,
    required this.quantity,
    this.unit,
    required this.total,
    this.description,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      itemName: json['itemName'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'],
      rate: (json['rate'] ?? 0.0).toDouble(),
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unit: json['unit'],
      total: (json['total'] ?? 0.0).toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      'rate': rate,
      'quantity': quantity,
      if (unit != null) 'unit': unit,
      'total': total,
      if (description != null) 'description': description,
    };
  }
}

class PurchaseResponseModel {
  final String? purchaseId;
  final String partyId;
  final String adminId;
  final String yearMonth; // Format: "2024-01"
  final String purchaseDate;
  final List<PurchaseItem> purchaseItems;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;
  final String paymentStatus; // 'FULL', 'PARTIAL', 'CREDIT'
  final String? invoiceNumber;
  final String? notes;
  final bool
      isServicePurchase; // To distinguish between product and service purchases

  PurchaseResponseModel({
    this.purchaseId,
    required this.partyId,
    required this.adminId,
    required this.yearMonth,
    required this.purchaseDate,
    required this.purchaseItems,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.paymentStatus,
    this.invoiceNumber,
    this.notes,
    this.isServicePurchase = false,
  });

  factory PurchaseResponseModel.fromJson(Map<String, dynamic> json,
      {String? purchaseId}) {
    return PurchaseResponseModel(
      purchaseId: purchaseId ?? json['purchaseId'],
      partyId: json['partyId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      purchaseDate: json['purchaseDate'] ?? '',
      purchaseItems: (json['purchaseItems'] as List<dynamic>?)
              ?.map((item) => PurchaseItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0.0).toDouble(),
      dueAmount: (json['dueAmount'] ?? 0.0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'CREDIT',
      invoiceNumber: json['invoiceNumber'],
      notes: json['notes'],
      isServicePurchase: json['isServicePurchase'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'purchaseDate': purchaseDate,
      'purchaseItems': purchaseItems.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'paymentStatus': paymentStatus,
      if (invoiceNumber != null) 'invoiceNumber': invoiceNumber,
      if (notes != null) 'notes': notes,
      'isServicePurchase': isServicePurchase,
    };
  }
}
