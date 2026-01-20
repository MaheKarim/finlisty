import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionModel(
        id: transaction.id,
        amount: transaction.amount,
        type: transaction.type,
        walletId: transaction.walletId,
        destinationWalletId: transaction.destinationWalletId,
        categoryId: transaction.categoryId,
        categoryName: transaction.categoryName,
        date: transaction.date,
        note: transaction.note,
      );
      await remoteDataSource.addTransaction(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<TransactionEntity>> getTransactionsStream() {
    return remoteDataSource.getTransactionsStream();
  }

  @override
  Future<Either<Failure, int>> getTransactionCountByWalletId(String walletId) async {
    try {
      final count = await remoteDataSource.getTransactionCountByWalletId(walletId);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
