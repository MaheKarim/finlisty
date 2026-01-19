import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finlisty/features/recurring_bill/data/models/recurring_bill_model.dart';

/// Remote data source for RecurringBill operations using Firestore
abstract class RecurringBillRemoteDataSource {
  /// Get all recurring bills for the current user
  Future<List<RecurringBillModel>> getRecurringBills();

  /// Get a specific recurring bill by ID
  Future<RecurringBillModel?> getRecurringBillById(String id);

  /// Add a new recurring bill
  Future<void> addRecurringBill(RecurringBillModel bill);

  /// Update an existing recurring bill
  Future<void> updateRecurringBill(RecurringBillModel bill);

  /// Delete a recurring bill
  Future<void> deleteRecurringBill(String id);

  /// Mark a bill as paid and update next due date
  Future<void> markAsPaid(String billId, DateTime paidDate);

  /// Get bills due within the next N days
  Future<List<RecurringBillModel>> getBillsDueWithinDays(int days);

  /// Get overdue bills
  Future<List<RecurringBillModel>> getOverdueBills();

  /// Stream of recurring bills for real-time updates
  Stream<List<RecurringBillModel>> watchRecurringBills();
}

/// Implementation of RecurringBillRemoteDataSource
class RecurringBillRemoteDataSourceImpl implements RecurringBillRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RecurringBillRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String get _userId => auth.currentUser?.uid ?? '';

  CollectionReference get _billsCollection =>
      firestore.collection('users').doc(_userId).collection('recurring_bills');

  @override
  Future<List<RecurringBillModel>> getRecurringBills() async {
    final snapshot = await _billsCollection
        .where('isActive', isEqualTo: true)
        .orderBy('nextDueDate', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => RecurringBillModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RecurringBillModel?> getRecurringBillById(String id) async {
    final doc = await _billsCollection.doc(id).get();
    if (!doc.exists) return null;
    return RecurringBillModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> addRecurringBill(RecurringBillModel bill) async {
    await _billsCollection.doc(bill.id).set(bill.toJson());
  }

  @override
  Future<void> updateRecurringBill(RecurringBillModel bill) async {
    await _billsCollection.doc(bill.id).update(bill.toJson());
  }

  @override
  Future<void> deleteRecurringBill(String id) async {
    // Soft delete - mark as inactive
    await _billsCollection.doc(id).update({'isActive': false});
  }

  @override
  Future<void> markAsPaid(String billId, DateTime paidDate) async {
    final doc = await _billsCollection.doc(id).get();
    if (!doc.exists) return;

    final bill = RecurringBillModel.fromJson(doc.data() as Map<String, dynamic>);
    final nextDueDate = bill.calculateNextDueDate();

    await _billsCollection.doc(id).update({
      'lastPaidDate': paidDate.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
    });
  }

  @override
  Future<List<RecurringBillModel>> getBillsDueWithinDays(int days) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));

    final snapshot = await _billsCollection
        .where('isActive', isEqualTo: true)
        .where('nextDueDate', isGreaterThanOrEqualTo: now.toIso8601String())
        .where('nextDueDate', isLessThanOrEqualTo: futureDate.toIso8601String())
        .orderBy('nextDueDate', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => RecurringBillModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<RecurringBillModel>> getOverdueBills() async {
    final now = DateTime.now();

    final snapshot = await _billsCollection
        .where('isActive', isEqualTo: true)
        .where('nextDueDate', isLessThan: now.toIso8601String())
        .orderBy('nextDueDate', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => RecurringBillModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<RecurringBillModel>> watchRecurringBills() {
    return _billsCollection
        .where('isActive', isEqualTo: true)
        .orderBy('nextDueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecurringBillModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
