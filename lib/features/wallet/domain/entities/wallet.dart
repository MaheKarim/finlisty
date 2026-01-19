import 'package:equatable/equatable.dart';

enum WalletType { cash, bkash, bank, nagad, other }

class Wallet extends Equatable {
  final String id;
  final String name;
  final WalletType type;
  final double balance;
  final String color;
  final bool isArchived;

  const Wallet({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.color,
    this.isArchived = false,
  });

  @override
  List<Object?> get props => [id, name, type, balance, color, isArchived];
}
