import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.color,
    super.isArchived,
  });

  factory WalletModel.fromSnapshot(DocumentSnapshot doc) {
    // Assuming data exists
    final data = doc.data() as Map<String, dynamic>;
    return WalletModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: _stringToType(data['type'] ?? 'cash'),
      balance: (data['balance'] ?? 0.0).toDouble(),
      color: data['color'] ?? '#000000',
      isArchived: data['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name, // Enum to string
      'balance': balance,
      'color': color,
      'isArchived': isArchived,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static WalletType _stringToType(String type) {
    return WalletType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => WalletType.other,
    );
  }
}
