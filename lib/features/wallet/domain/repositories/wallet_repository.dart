import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<Wallet>>> getWallets();
  Future<Either<Failure, void>> addWallet(Wallet wallet);
  Future<Either<Failure, void>> updateWallet(Wallet wallet);
  Future<Either<Failure, void>> deleteWallet(String id);
  Stream<List<Wallet>> getWalletsStream();
}
