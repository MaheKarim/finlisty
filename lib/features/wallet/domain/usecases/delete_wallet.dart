import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wallet_repository.dart';

class DeleteWallet implements UseCase<void, String> {
  final WalletRepository repository;

  DeleteWallet(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteWallet(id);
  }
}
