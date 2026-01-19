import 'package:dartz/dartz.dart';
import 'package:finlisty/core/error/failures.dart';
import 'package:finlisty/features/recurring_bill/domain/entities/recurring_bill.dart';

/// Repository interface for RecurringBill operations
abstract class RecurringBillRepository {
  /// Get all recurring bills for the current user
  Future<Either<Failure, List<RecurringBill>>> getRecurringBills();

  /// Get a specific recurring bill by ID
  Future<Either<Failure, RecurringBill>> getRecurringBillById(String id);

  /// Add a new recurring bill
  Future<Either<Failure, void>> addRecurringBill(RecurringBill bill);

  /// Update an existing recurring bill
  Future<Either<Failure, void>> updateRecurringBill(RecurringBill bill);

  /// Delete a recurring bill
  Future<Either<Failure, void>> deleteRecurringBill(String id);

  /// Mark a bill as paid and update next due date
  Future<Either<Failure, void>> markAsPaid(String billId, DateTime paidDate);

  /// Get bills due within the next N days
  Future<Either<Failure, List<RecurringBill>>> getBillsDueWithinDays(int days);

  /// Get overdue bills
  Future<Either<Failure, List<RecurringBill>>> getOverdueBills();

  /// Stream of recurring bills for real-time updates
  Stream<List<RecurringBill>> watchRecurringBills();
}
