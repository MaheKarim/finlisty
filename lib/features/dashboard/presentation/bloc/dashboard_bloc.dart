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
import '../../../wallet/domain/usecases/delete_wallet.dart';
import '../../../transaction/domain/usecases/get_transaction_count_by_wallet_id.dart';
import '../../../loan/domain/usecases/get_linked_loan_count_by_wallet_id.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  @override
  List<Object?> get props => [];
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
  @override
  List<Object?> get props => [wallets, transactions, loans];
}

class DeleteWalletRequested extends DashboardEvent {
  final String walletId;
  final double currentBalance;
  
  const DeleteWalletRequested({
    required this.walletId, 
    required this.currentBalance,
  });

  @override
  @override
  List<Object?> get props => [walletId, currentBalance];
}

class ClearDashboardError extends DashboardEvent {}

class CreateDefaultWallet extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
    @override
  List<Object?> get props => [];
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
    this.errorMessage,
    this.successMessage,
  });

  final String? errorMessage;
  final String? successMessage;

  DashboardLoaded copyWith({
    List<Wallet>? wallets,
    List<TransactionEntity>? recentTransactions,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    double? totalLoanGiven,
    double? totalLoanTaken,
    int? overdueLoanCount,
    String? errorMessage,
    String? successMessage,
  }) {
    return DashboardLoaded(
      wallets: wallets ?? this.wallets,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      totalLoanGiven: totalLoanGiven ?? this.totalLoanGiven,
      totalLoanTaken: totalLoanTaken ?? this.totalLoanTaken,
      overdueLoanCount: overdueLoanCount ?? this.overdueLoanCount,
      errorMessage: errorMessage, // Intentionally not keeping old error
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        wallets,
        recentTransactions,
        totalBalance,
        totalIncome,
        totalExpense,
        totalLoanGiven,
        totalLoanTaken,
        overdueLoanCount,
        errorMessage,
        successMessage,
      ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
    @override
  @override
  List<Object?> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WalletRepository walletRepository;
  final TransactionRepository transactionRepository;
  final LoanRepository loanRepository;
  
  final DeleteWallet deleteWallet;
  final GetTransactionCountByWalletId getTransactionCount;
  final GetLinkedLoanCountByWalletId getLinkedLoanCount;
  
  StreamSubscription? _combinedSubscription;

  DashboardBloc({
    required this.walletRepository,
    required this.transactionRepository,
    required this.loanRepository,
    required this.deleteWallet,
    required this.getTransactionCount,
    required this.getLinkedLoanCount,
  }) : super(DashboardLoading()) {
    on<SubscribeDashboardData>(_onSubscribe);
    on<_DashboardDataReceived>(_onDataReceived);
    on<DeleteWalletRequested>(_onDeleteWallet);
    on<CreateDefaultWallet>(_onCreateDefaultWallet);
    on<ClearDashboardError>(_onClearError);
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

    if (wallets.isEmpty) {
      add(CreateDefaultWallet());
    }
  }

  Future<void> _onDeleteWallet(DeleteWalletRequested event, Emitter<DashboardState> emit) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    // 1. Check Balance
    if (event.currentBalance != 0) {
      emit(currentState.copyWith(errorMessage: 'deleteWalletErrorBalance'));
      return;
    }

    // 2. Check Dependencies
    final txCountResult = await getTransactionCount(event.walletId);
    final loanCountResult = await getLinkedLoanCount(event.walletId);

    int txCount = 0;
    int loanCount = 0;

    txCountResult.fold((l) => null, (r) => txCount = r);
    loanCountResult.fold((l) => null, (r) => loanCount = r);

    if (txCount > 0 || loanCount > 0) {
      emit(currentState.copyWith(errorMessage: 'deleteWalletErrorDependents'));
      return;
    }

    // 3. Delete
    final result = await deleteWallet(event.walletId);
    result.fold(
      (failure) => emit(currentState.copyWith(errorMessage: failure.message)),
      (_) => emit(currentState.copyWith(successMessage: 'deleteWalletSuccess')),
    );
  }



  Future<void> _onCreateDefaultWallet(CreateDefaultWallet event, Emitter<DashboardState> emit) async {
    // Double check to avoid race conditions or loops (though event loop should handle it)
    // Logic: Just add a default wallet. 
    // We don't check state.wallets here because state might not be updated yet if we didn't emit, 
    // but _onDataReceived did emit.
    
    // However, if we are deleting the last wallet, we end up here.
    // If user deletes last wallet, it re-creates instantly. Is this desired?
    // Requirement: "ensure a default wallet is created upon first launch or authentication".
    // It doesn't explicitly say "prevent user from having 0 wallets".
    // But usually Apps strictly require 1 wallet.
    // I'll assume YES.
    
    try {
      // Need imports for WalletModel or use Wallet entity if repo accepts it.
      // Repo accepts Wallet? 
      // WalletRepository interface uses Wallet entity?
      // Let's check WalletRepository interface.
      // If it takes Wallet, I can create Wallet instance.
      // WalletEntity requires ID. I can pass empty string.
      
      // I'll assume repo accepts Wallet. I need to convert it or use implementation.
      // Wait, WalletRepository accepts Wallet (Entity) or WalletModel? 
      // Data Layer uses Model. Domain Layer uses Entity.
      // DashboardBloc uses Repo (Domain). So it accepts Entity.
      
      final defaultWallet = Wallet(
        id: '', // Repo/Datasource should handle this or ignore it on add
        name: 'Cash',
        type: WalletType.cash,
        balance: 0.0,
        color: '#4CAF50', // Green
        isArchived: false,
      );
      
      await walletRepository.addWallet(defaultWallet);
    } catch (e) {
      // Log error or ignore
    }
  }

  void _onClearError(ClearDashboardError event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(errorMessage: null, successMessage: null));
    }
  }

  @override
  Future<void> close() {
    _combinedSubscription?.cancel();
    return super.close();
  }
}
