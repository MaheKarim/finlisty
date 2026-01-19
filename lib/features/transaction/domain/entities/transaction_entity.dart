import 'package:equatable/equatable.dart';

enum TransactionType { income, expense, transfer }

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  final String walletId;
  final String? destinationWalletId;
  final String? categoryId;
  final String? categoryName;
  final DateTime date;
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.walletId,
    this.destinationWalletId,
    this.categoryId,
    this.categoryName,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        type,
        walletId,
        destinationWalletId,
        categoryId,
        categoryName,
        date,
        note,
      ];
}
