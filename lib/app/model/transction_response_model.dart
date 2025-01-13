// make the enum of the transaction type as ( SALE, PAYMENT_IN, PURCHASE, PAYMENT_OUT, OPENING_BALANCE)

enum TransactionType {
  SALE,
  PAYMENT_IN,
  PURCHASE,
  PAYMENT_OUT,
  OPENING_BALANCE
}

class TransactionResponseModel {
  final String? transactionId;
  final String partyId;
  final String adminId;
  final String yearMonth;
  final String transactionDate;
  final String transactionType; // 'SALE' or 'PAYMENT'
  final String? actionId;
  final double totalAmount;
  final double balance;
  final String paymentMethod;
  final String? bankDetails;
  final String? notes;
  final String status; // 'FULL_PAID', 'PARTIAL_PAID', 'UNPAID'
  final String transactionUnder; // NIC ASIA, PRABHU, etc.a
  final String remarks;
  final String moneyFlow;

  TransactionResponseModel({
    this.transactionId,
    required this.partyId,
    required this.adminId,
    required this.yearMonth,
    required this.transactionDate,
    required this.transactionType,
    required this.actionId,
    required this.totalAmount,
    required this.paymentMethod,
    this.bankDetails,
    required this.balance,
    this.notes,
    required this.status,
    required this.transactionUnder,
    required this.remarks,
    required this.moneyFlow,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json,
      {String? transactionId}) {
    return TransactionResponseModel(
      transactionId: transactionId ?? json['transactionId'],
      partyId: json['partyId'] ?? '',
      adminId: json['adminId'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      transactionDate: json['transactionDate'] ?? '',
      transactionType: json['transactionType'] ?? 'PAYMENT',
      actionId: json['saleId'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'CASH',
      bankDetails: json['bankDetails'],
      balance: (json['balance'] ?? 0.0).toDouble(),
      notes: json['notes'],
      status: json['status'] ?? 'UNPAID',
      transactionUnder: json['transactionUnder'] ?? '',
      remarks: json['remarks'] ??
          '', // for the each transciton writing the party name, purchase/sell itme ok
      moneyFlow: json['moneyFlow'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'adminId': adminId,
      'yearMonth': yearMonth,
      'transactionDate': transactionDate,
      'transactionType': transactionType,
      'actionId': actionId,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'bankDetails': bankDetails,
      'balance': balance,
      'notes': notes,
      'status': status,
      'transactionUnder': transactionUnder,
      'remarks': remarks,
      'moneyFlow': moneyFlow,
    };
  }

  // Helper method to get status display text
  String getStatusDisplay() {
    switch (status) {
      case 'FULL_PAID':
        return 'Fully Paid';
      case 'PARTIAL_PAID':
        return 'Partially Paid';
      case 'UNPAID':
        return 'Unpaid';
      default:
        return status;
    }
  }
}
