import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../transaction/presentation/pages/add_transaction_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(
        walletRepository: sl(),
        transactionRepository: sl(),
      )..add(SubscribeDashboardData()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finlisty"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(child: Text(state.message));
          }
          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {}, // Stream handles updates, but this is good UX
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Balance Card
                    _buildBalanceCard(state.totalBalance),
                    const SizedBox(height: 20),
                    
                    // Income/Expense Row
                    Row(
                      children: [
                        Expanded(child: _buildSummaryCard("Income", state.totalIncome, AppColors.income, Icons.arrow_downward)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSummaryCard("Expense", state.totalExpense, AppColors.expense, Icons.arrow_upward)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Wallets Section
                    const Text("Wallets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.wallets.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.wallets.length) {
                             return _buildAddWalletCard();
                          }
                          return _buildWalletCard(state.wallets[index]);
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Transactions
                    const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...state.recentTransactions.map((t) => _buildTransactionItem(t)),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionPage()));
        },
        label: const Text("Add New"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
         boxShadow: [
          BoxShadow(color: AppColors.secondary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Balance", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            "৳${balance.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text("৳${amount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildWalletCard(Wallet wallet) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Icon(
                 wallet.type == WalletType.cash ? Icons.money : 
                 wallet.type == WalletType.bank ? Icons.account_balance : Icons.phone_android,
                 color: AppColors.primary,
               ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(wallet.name, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text("৳${wallet.balance.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

   Widget _buildAddWalletCard() {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.grey),
      ),
    );
  }

  Widget _buildTransactionItem(TransactionEntity t) {
    final isIncome = t.type == TransactionType.income;
    final isTransfer = t.type == TransactionType.transfer;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade50),
      ),
      child: Row(
        children: [
           Container(
             padding: const EdgeInsets.all(10),
             decoration: BoxDecoration(
               color: isIncome ? AppColors.income.withValues(alpha: 0.1) : 
                      isTransfer ? Colors.blue.withValues(alpha: 0.1) : AppColors.expense.withValues(alpha: 0.1),
               shape: BoxShape.circle,
             ),
             child: Icon(
               isIncome ? Icons.arrow_downward : 
               isTransfer ? Icons.swap_horiz : Icons.arrow_upward,
               color: isIncome ? AppColors.income : 
                      isTransfer ? Colors.blue : AppColors.expense,
               size: 20,
             ),
           ),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   isTransfer ? "Transfer" : (t.categoryName ?? (isIncome ? "Income" : "Expense")),
                   style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                 ),
                 Text(
                   t.date.toString().split(' ')[0],
                   style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                 ),
               ],
             ),
           ),
           Text(
             "${isIncome ? '+' : '-'}৳${t.amount.toStringAsFixed(0)}",
             style: TextStyle(
               color: isIncome ? AppColors.income : AppColors.textPrimaryLight,
               fontWeight: FontWeight.bold,
               fontSize: 16,
             ),
           ),
        ],
      ),
    );
  }
}
