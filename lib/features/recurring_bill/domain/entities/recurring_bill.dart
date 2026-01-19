import 'package:equatable/equatable.dart';

/// Recurring Bill entity for managing periodic expenses
enum BillFrequency { weekly, monthly }

class RecurringBill extends Equatable {
  final String id;
  final String name;
  final double amount;
  final BillFrequency frequency;
  final DateTime startDate;
  final DateTime? nextDueDate;
  final String? categoryId;
  final String? categoryName;
  final String? note;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastPaidDate;

  const RecurringBill({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.nextDueDate,
    this.categoryId,
    this.categoryName,
    this.note,
    this.isActive = true,
    required this.createdAt,
    this.lastPaidDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        frequency,
        startDate,
        nextDueDate,
        categoryId,
        categoryName,
        note,
        isActive,
        createdAt,
        lastPaidDate,
      ];

  /// Calculate the next due date based on frequency
  DateTime calculateNextDueDate() {
    final baseDate = lastPaidDate ?? nextDueDate ?? startDate;
    
    switch (frequency) {
      case BillFrequency.weekly:
        return baseDate.add(const Duration(days: 7));
      case BillFrequency.monthly:
        // Add 1 month while preserving the day
        return DateTime(
          baseDate.year + (baseDate.month == 12 ? 1 : 0),
          baseDate.month == 12 ? 1 : baseDate.month + 1,
          baseDate.day,
        );
    }
  }

  /// Check if the bill is overdue
  bool isOverdue() {
    if (!isActive || nextDueDate == null) return false;
    return DateTime.now().isAfter(nextDueDate!);
  }

  /// Check if the bill is due within the next N days
  bool isDueWithinDays(int days) {
    if (!isActive || nextDueDate == null) return false;
    final now = DateTime.now();
    final dueDate = nextDueDate!;
    final difference = dueDate.difference(now).inDays;
    return difference >= 0 && difference <= days;
  }

  /// Get days until due
  int getDaysUntilDue() {
    if (nextDueDate == null) return -1;
    final now = DateTime.now();
    return nextDueDate!.difference(now).inDays;
  }

  /// Create a copy with modified fields
  RecurringBill copyWith({
    String? id,
    String? name,
    double? amount,
    BillFrequency? frequency,
    DateTime? startDate,
    DateTime? nextDueDate,
    String? categoryId,
    String? categoryName,
    String? note,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastPaidDate,
  }) {
    return RecurringBill(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastPaidDate: lastPaidDate ?? this.lastPaidDate,
    );
  }
}
