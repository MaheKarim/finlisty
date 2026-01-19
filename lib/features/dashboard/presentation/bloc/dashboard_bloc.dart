import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../../../transaction/domain/repositories/transaction_repository.dart';

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

  const _DashboardDataReceived({required this.wallets, required this.transactions});

  @override
  List<Object> get props => [wallets, transactions];
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

  const DashboardLoaded({
    required this.wallets,
    required this.recentTransactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  List<Object> get props => [wallets, recentTransactions, totalBalance, totalIncome, totalExpense];
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
  
  StreamSubscription? _combinedSubscription;

  DashboardBloc({
    required this.walletRepository,
    required this.transactionRepository,
  }) : super(DashboardLoading()) {
    on<SubscribeDashboardData>(_onSubscribe);
    on<_DashboardDataReceived>(_onDataReceived);
  }

  void _onSubscribe(SubscribeDashboardData event, Emitter<DashboardState> emit) {
    _combinedSubscription?.cancel();
    
    // Combine both streams and add events to the bloc
    _combinedSubscription = Rx.combineLatest2<List<Wallet>, List<TransactionEntity>, _DashboardDataReceived>(
      walletRepository.getWalletsStream(),
      transactionRepository.getTransactionsStream(),
      (wallets, transactions) => _DashboardDataReceived(
        wallets: wallets,
        transactions: transactions,
      ),
    ).listen((event) {
      add(event);
    });
  }

  void _onDataReceived(_DashboardDataReceived event, Emitter<DashboardState> emit) {
    final wallets = event.wallets;
    final transactions = event.transactions;
    
    final totalBalance = wallets.fold(0.0, (sum, w) => sum + w.balance);
    
    // Simple calculation for MVP (Real app might involve date filtering)
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
        
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    emit(DashboardLoaded(
      wallets: wallets,
      recentTransactions: transactions.take(5).toList(),
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    ));
  }

  @override
  Future<void> close() {
    _combinedSubscription?.cancel();
    return super.close();
  }
}
