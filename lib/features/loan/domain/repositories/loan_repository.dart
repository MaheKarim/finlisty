import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/loan.dart';

abstract class LoanRepository {
  Future<Either<Failure, void>> addLoan(Loan loan);
  Future<Either<Failure, void>> repayLoan(String loanId, double amount, String walletId, bool isLoanGiven);
  Stream<List<Loan>> getLoansStream();
  Future<Either<Failure, int>> getLinkedLoanCountByWalletId(String walletId);
}
