import 'package:finlisty/features/recurring_bill/domain/entities/recurring_bill.dart';

/// RecurringBill model for Firestore serialization/deserialization
class RecurringBillModel extends RecurringBill {
  const RecurringBillModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.frequency,
    required super.startDate,
    super.nextDueDate,
    super.categoryId,
    super.categoryName,
    super.note,
    super.isActive = true,
    required super.createdAt,
    super.lastPaidDate,
  });

  /// Create RecurringBillModel from Firestore document
  factory RecurringBillModel.fromJson(Map<String, dynamic> json) {
    return RecurringBillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      frequency: _parseFrequency(json['frequency'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'] as String)
          : null,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      note: json['note'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastPaidDate: json['lastPaidDate'] != null
          ? DateTime.parse(json['lastPaidDate'] as String)
          : null,
    );
  }

  /// Convert RecurringBillModel to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'frequency': frequency.name,
      'startDate': startDate.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'categoryId': categoryId,
      'categoryName': categoryName,
      'note': note,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastPaidDate': lastPaidDate?.toIso8601String(),
    };
  }

  /// Convert to RecurringBill entity
  RecurringBill toEntity() {
    return RecurringBill(
      id: id,
      name: name,
      amount: amount,
      frequency: frequency,
      startDate: startDate,
      nextDueDate: nextDueDate,
      categoryId: categoryId,
      categoryName: categoryName,
      note: note,
      isActive: isActive,
      createdAt: createdAt,
      lastPaidDate: lastPaidDate,
    );
  }

  /// Create RecurringBillModel from RecurringBill entity
  factory RecurringBillModel.fromEntity(RecurringBill bill) {
    return RecurringBillModel(
      id: bill.id,
      name: bill.name,
      amount: bill.amount,
      frequency: bill.frequency,
      startDate: bill.startDate,
      nextDueDate: bill.nextDueDate,
      categoryId: bill.categoryId,
      categoryName: bill.categoryName,
      note: bill.note,
      isActive: bill.isActive,
      createdAt: bill.createdAt,
      lastPaidDate: bill.lastPaidDate,
    );
  }

  /// Parse frequency from string
  static BillFrequency _parseFrequency(String frequency) {
    return BillFrequency.values.firstWhere(
      (f) => f.name == frequency,
      orElse: () => BillFrequency.monthly,
    );
  }
}
