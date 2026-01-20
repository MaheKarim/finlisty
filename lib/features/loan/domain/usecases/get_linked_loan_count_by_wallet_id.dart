import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/loan_repository.dart';

class GetLinkedLoanCountByWalletId implements UseCase<int, String> {
  final LoanRepository repository;

  GetLinkedLoanCountByWalletId(this.repository);

  @override
  Future<Either<Failure, int>> call(String walletId) async {
    return await repository.getLinkedLoanCountByWalletId(walletId);
  }
}
