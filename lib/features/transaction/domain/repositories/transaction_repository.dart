import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
  Stream<List<TransactionEntity>> getTransactionsStream();
  Future<Either<Failure, int>> getTransactionCountByWalletId(String walletId);
}
