import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../../../transaction/domain/repositories/transaction_repository.dart';
import '../../../loan/domain/entities/loan.dart';
import '../../../loan/domain/repositories/loan_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class SubscribeDashboardData extends DashboardEvent {}

class _DashboardDataReceived extends DashboardEvent {
  final List<Wallet> wallets;
  final List<TransactionEntity> transactions;
  final List<Loan> loans;

  const _DashboardDataReceived({
    required this.wallets,
    required this.transactions,
    required this.loans,
  });

  @override
  List<Object> get props => [wallets, transactions, loans];
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
    @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Wallet> wallets;
  final List<TransactionEntity> recentTransactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double totalLoanGiven;
  final double totalLoanTaken;
  final int overdueLoanCount;

  const DashboardLoaded({
    required this.wallets,
    required this.recentTransactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalLoanGiven,
    required this.totalLoanTaken,
    required this.overdueLoanCount,
  });

  @override
  List<Object> get props => [
        wallets,
        recentTransactions,
        totalBalance,
        totalIncome,
        totalExpense,
        totalLoanGiven,
        totalLoanTaken,
        overdueLoanCount,
      ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
    @override
  List<Object> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WalletRepository walletRepository;
  final TransactionRepository transactionRepository;
  final LoanRepository loanRepository;
  
  StreamSubscription? _combinedSubscription;

  DashboardBloc({
    required this.walletRepository,
    required this.transactionRepository,
    required this.loanRepository,
  }) : super(DashboardLoading()) {
    on<SubscribeDashboardData>(_onSubscribe);
    on<_DashboardDataReceived>(_onDataReceived);
  }

  void _onSubscribe(SubscribeDashboardData event, Emitter<DashboardState> emit) {
    _combinedSubscription?.cancel();
    
    // Combine all three streams
    _combinedSubscription = Rx.combineLatest3<List<Wallet>, List<TransactionEntity>, List<Loan>, _DashboardDataReceived>(
      walletRepository.getWalletsStream(),
      transactionRepository.getTransactionsStream(),
      loanRepository.getLoansStream(),
      (wallets, transactions, loans) => _DashboardDataReceived(
        wallets: wallets,
        transactions: transactions,
        loans: loans,
      ),
    ).listen((event) {
      add(event);
    });
  }

  void _onDataReceived(_DashboardDataReceived event, Emitter<DashboardState> emit) {
    final wallets = event.wallets;
    final transactions = event.transactions;
    final loans = event.loans;
    
    final totalBalance = wallets.fold(0.0, (sum, w) => sum + w.balance);
    
    // Monthly calculations (current month)
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    final monthlyTransactions = transactions.where(
      (t) => t.date.isAfter(startOfMonth) || t.date.isAtSameMomentAs(startOfMonth),
    );
    
    final totalIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
        
    final totalExpense = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Loan calculations
    final activeLoans = loans.where((l) => l.status == LoanStatus.active);
    
    final totalLoanGiven = activeLoans
        .where((l) => l.type == LoanType.given)
        .fold(0.0, (sum, l) => sum + l.outstandingAmount);
        
    final totalLoanTaken = activeLoans
        .where((l) => l.type == LoanType.taken)
        .fold(0.0, (sum, l) => sum + l.outstandingAmount);

    // Count overdue loans
    final overdueLoanCount = activeLoans.where((l) =>
        l.dueDate != null && l.dueDate!.isBefore(now)).length;

    emit(DashboardLoaded(
      wallets: wallets,
      recentTransactions: transactions.take(5).toList(),
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      totalLoanGiven: totalLoanGiven,
      totalLoanTaken: totalLoanTaken,
      overdueLoanCount: overdueLoanCount,
    ));
  }

  @override
  Future<void> close() {
    _combinedSubscription?.cancel();
    return super.close();
  }
}
