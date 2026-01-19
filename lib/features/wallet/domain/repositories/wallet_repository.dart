import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<Wallet>>> getWallets();
  Future<Either<Failure, void>> addWallet(Wallet wallet);
  Future<Either<Failure, void>> updateWallet(Wallet wallet);
  Stream<List<Wallet>> getWalletsStream();
}
