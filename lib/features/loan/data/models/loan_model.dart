import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/loan.dart';

class LoanModel extends Loan {
  const LoanModel({
    required super.id,
    required super.personName,
    required super.type,
    required super.principalAmount,
    required super.outstandingAmount,
    super.interestRate,
    required super.startDate,
    super.dueDate,
    required super.status,
    super.linkedWalletId,
  });

  factory LoanModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoanModel(
      id: doc.id,
      personName: data['personName'] ?? '',
      type: _stringToType(data['type'] ?? 'given'),
      principalAmount: (data['principalAmount'] ?? 0.0).toDouble(),
      outstandingAmount: (data['outstandingAmount'] ?? 0.0).toDouble(),
      interestRate: (data['interestRate'] as num?)?.toDouble(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      status: _stringToStatus(data['status'] ?? 'active'),
      linkedWalletId: data['linkedWalletId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personName': personName,
      'type': type.name == 'given' ? 'GIVEN' : 'TAKEN',
      'principalAmount': principalAmount,
      'outstandingAmount': outstandingAmount,
      'interestRate': interestRate,
      'startDate': Timestamp.fromDate(startDate),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'status': status.name,
      'linkedWalletId': linkedWalletId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static LoanType _stringToType(String type) {
    return type.toUpperCase() == 'GIVEN' ? LoanType.given : LoanType.taken;
  }

  static LoanStatus _stringToStatus(String status) {
    return status == 'closed' ? LoanStatus.closed : LoanStatus.active;
  }
}
