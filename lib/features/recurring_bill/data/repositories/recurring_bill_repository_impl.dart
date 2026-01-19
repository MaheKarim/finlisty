import 'package:dartz/dartz.dart';
import 'package:finlisty/core/error/failures.dart';
import 'package:finlisty/core/network/network_info.dart';
import 'package:finlisty/features/recurring_bill/data/datasources/recurring_bill_remote_data_source.dart';
import 'package:finlisty/features/recurring_bill/data/models/recurring_bill_model.dart';
import 'package:finlisty/features/recurring_bill/domain/entities/recurring_bill.dart';
import 'package:finlisty/features/recurring_bill/domain/repositories/recurring_bill_repository.dart';

/// Implementation of RecurringBillRepository
class RecurringBillRepositoryImpl implements RecurringBillRepository {
  final RecurringBillRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RecurringBillRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RecurringBill>>> getRecurringBills() async {
    if (await networkInfo.isConnected) {
      try {
        final bills = await remoteDataSource.getRecurringBills();
        return Right(bills.map((b) => b.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, RecurringBill>> getRecurringBillById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final bill = await remoteDataSource.getRecurringBillById(id);
        if (bill == null) {
          return Left(NotFoundFailure(message: 'Recurring bill not found'));
        }
        return Right(bill.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addRecurringBill(RecurringBill bill) async {
    if (await networkInfo.isConnected) {
      try {
        final billModel = RecurringBillModel.fromEntity(bill);
        await remoteDataSource.addRecurringBill(billModel);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateRecurringBill(RecurringBill bill) async {
    if (await networkInfo.isConnected) {
      try {
        final billModel = RecurringBillModel.fromEntity(bill);
        await remoteDataSource.updateRecurringBill(billModel);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecurringBill(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteRecurringBill(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsPaid(String billId, DateTime paidDate) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.markAsPaid(billId, paidDate);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<RecurringBill>>> getBillsDueWithinDays(int days) async {
    if (await networkInfo.isConnected) {
      try {
        final bills = await remoteDataSource.getBillsDueWithinDays(days);
        return Right(bills.map((b) => b.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<RecurringBill>>> getOverdueBills() async {
    if (await networkInfo.isConnected) {
      try {
        final bills = await remoteDataSource.getOverdueBills();
        return Right(bills.map((b) => b.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Stream<List<RecurringBill>> watchRecurringBills() {
    return remoteDataSource
        .watchRecurringBills()
        .map((bills) => bills.map((b) => b.toEntity()).toList());
  }
}
