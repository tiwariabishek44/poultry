// Main Sales Response Model

// SaleItem model for individual items in a sale
class SaleItem {
  final String itemName;
  final String category; // 'egg', 'hen', 'manure'
  final String? batchId; // null for eggs
  final double rate;
  final double quantity;
  final double total;

  SaleItem({
    required this.itemName,
    required this.category,
    this.batchId,
    required this.rate,
    required this.quantity,
    required this.total,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      itemName: json['itemName'] ?? '',
      category: json['category'] ?? '',
      batchId: json['batchId'],
      rate: (json['rate'] ?? 0.0).toDouble(),
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'category': category,
      if (batchId != null) 'batchId': batchId,
      'rate': rate,
      'quantity': quantity,
      'total': total,
    };
  }
}

class SalesResponseModel {
  final String? saleId;
  final String partyId;
  final String adminId;
  final String yearMonth; // Format: "2024-01"
  final String saleDate;
  final List<SaleItem> saleItems;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;
  final String paymentStatus; // 'FULL', 'PARTIAL', 'CREDIT'
  final String? notes;

  SalesResponseModel({
    this.saleId,
    required this.partyId,
    required this.adminId,
    required this.yearMonth,
    required this.saleDate,
    required this.saleItems,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.paymentStatus,
    this.notes,
  });

  factory SalesResponseModel.fromJson(Map<String, dynamic> json,
      {String? saleId}) {
    return SalesResponseModel(
      saleId: saleId ?? json['saleId'],
      partyId: json['partyId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      saleDate: json['saleDate'] ?? '',
      saleItems: (json['saleItems'] as List<dynamic>?)
              ?.map((item) => SaleItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0.0).toDouble(),
      dueAmount: (json['dueAmount'] ?? 0.0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'CREDIT',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'saleDate': saleDate,
      'saleItems': saleItems.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'paymentStatus': paymentStatus,
      if (notes != null) 'notes': notes,
    };
  }
}
