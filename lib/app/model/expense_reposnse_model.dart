// expense_model.dart

class ExpenseResponseModel {
  final String? expenseId;
  final String adminId;
  final String yearMonth; // Format: "2024-01"
  final String expenseDate;
  final String category; // 'UTILITY', 'SALARY', 'MAINTENANCE', etc.
  final double amount;
  final String paymentMethod; // 'CASH', 'BANK', 'WALLET'
  final String expenseType; // 'BATCH', 'GENERAL'
  final String? notes;
  final String? bankName; // If paid through bank
  final String? walletName; // If paid through digital wallet
  final String? batchId; // null for eggs

  ExpenseResponseModel({
    this.expenseId,
    required this.adminId,
    required this.yearMonth,
    required this.expenseDate,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.expenseType,
    this.notes,
    this.bankName,
    this.walletName,
    this.batchId,
  });

  factory ExpenseResponseModel.fromJson(Map<String, dynamic> json,
      {String? expenseId}) {
    return ExpenseResponseModel(
      expenseId: expenseId ?? json['expenseId'],
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      expenseDate: json['expenseDate'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'CASH',
      expenseType: json['expenseType'] ?? 'GENERAL',
      notes: json['notes'],
      bankName: json['bankName'],
      walletName: json['walletName'],
      batchId: json['batchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'yearMonth': yearMonth,
      'expenseDate': expenseDate,
      'category': category,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'expenseType': expenseType,
      if (notes != null) 'notes': notes,
      if (bankName != null) 'bankName': bankName,
      if (walletName != null) 'walletName': walletName,
      if (batchId != null) 'batchId': batchId,
    };
  }
}
