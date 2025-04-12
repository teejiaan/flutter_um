class TransactionModel {
  final String transactionId;
  final String userId;
  final String product;
  final int amount;
  final String organization;
  final double paidRM;
  final int pointsAdded;
  final String time;
  final String date;
  final String paymentMethod;
  final String receiptId;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.product,
    required this.amount,
    required this.organization,
    required this.paidRM,
    required this.pointsAdded,
    required this.time,
    required this.date,
    required this.paymentMethod,
    required this.receiptId,
  });

  // From Firestore
  factory TransactionModel.fromFirestore(Map<String, dynamic> data) {
    return TransactionModel(
      transactionId: data['transactionId'] ?? '',
      userId: data['userId'] ?? '',
      product: data['product'] ?? '',
      amount: data['amount'] ?? 0,
      organization: data['organization'] ?? '',
      paidRM: (data['paidRM'] as num?)?.toDouble() ?? 0.0,
      pointsAdded: data['pointsAdded'] ?? 0,
      time: data['time'] ?? '',
      date: data['date'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      receiptId: data['receiptId'] ?? '',
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'product': product,
      'amount': amount,
      'organization': organization,
      'paidRM': paidRM,
      'pointsAdded': pointsAdded,
      'time': time,
      'date': date,
      'paymentMethod': paymentMethod,
      'receiptId': receiptId,
    };
  }
}
