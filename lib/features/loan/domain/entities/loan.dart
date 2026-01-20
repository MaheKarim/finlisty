import 'package:equatable/equatable.dart';

enum LoanType { given, taken }
enum LoanStatus { active, closed }

class Loan extends Equatable {
  final String id;
  final String personName;
  final LoanType type;
  final double principalAmount;
  final double outstandingAmount;
  final DateTime startDate;
  final DateTime? dueDate;
  final LoanStatus status;
  final String? linkedWalletId;
  
  // Recurring payment fields (for Loan Taken only)
  final double? monthlyPaymentAmount;
  final DateTime? paymentStartMonth;

  const Loan({
    required this.id,
    required this.personName,
    required this.type,
    required this.principalAmount,
    required this.outstandingAmount,
    required this.startDate,
    this.dueDate,
    required this.status,
    this.linkedWalletId,
    this.monthlyPaymentAmount,
    this.paymentStartMonth,
  });

  @override
  List<Object?> get props => [
        id,
        personName,
        type,
        principalAmount,
        outstandingAmount,
        startDate,
        dueDate,
        status,
        linkedWalletId,
        monthlyPaymentAmount,
        paymentStartMonth,
      ];
}
