import 'package:equatable/equatable.dart';

enum LoanType { given, taken }
enum LoanStatus { active, closed }

class Loan extends Equatable {
  final String id;
  final String personName;
  final LoanType type;
  final double principalAmount;
  final double outstandingAmount;
  final double? interestRate;
  final DateTime startDate;
  final DateTime? dueDate;
  final LoanStatus status;
  final String? linkedWalletId;

  const Loan({
    required this.id,
    required this.personName,
    required this.type,
    required this.principalAmount,
    required this.outstandingAmount,
    this.interestRate,
    required this.startDate,
    this.dueDate,
    required this.status,
    this.linkedWalletId,
  });

  @override
  List<Object?> get props => [
        id,
        personName,
        type,
        principalAmount,
        outstandingAmount,
        interestRate,
        startDate,
        dueDate,
        status,
        linkedWalletId,
      ];
}
