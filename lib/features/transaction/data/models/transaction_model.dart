import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.walletId,
    super.destinationWalletId,
    super.categoryId,
    super.categoryName,
    required super.date,
    super.note,
  });

  factory TransactionModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      amount: (data['amount'] ?? 0.0).toDouble(),
      type: _stringToType(data['type'] ?? 'expense'),
      walletId: data['walletId'] ?? '',
      destinationWalletId: data['destinationWalletId'],
      categoryId: data['categoryId'],
      categoryName: data['categoryName'],
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type.name,
      'walletId': walletId,
      'destinationWalletId': destinationWalletId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'date': Timestamp.fromDate(date),
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static TransactionType _stringToType(String type) {
    return TransactionType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => TransactionType.expense,
    );
  }
}
