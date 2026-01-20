import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionCountByWalletId implements UseCase<int, String> {
  final TransactionRepository repository;

  GetTransactionCountByWalletId(this.repository);

  @override
  Future<Either<Failure, int>> call(String walletId) async {
    return await repository.getTransactionCountByWalletId(walletId);
  }
}
