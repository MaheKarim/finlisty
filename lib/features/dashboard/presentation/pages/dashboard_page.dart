import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../transaction/presentation/pages/add_transaction_page.dart';
import '../../../wallet/presentation/pages/wallets_page.dart';

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
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
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
              onRefresh: () async {},
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Balance Card
                    _buildBalanceCard(context, state.totalBalance, appLocalizations),
                    const SizedBox(height: 20),

                    // Income/Expense Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            appLocalizations.totalIncome,
                            state.totalIncome,
                            AppColors.income,
                            Icons.arrow_downward,
                            appLocalizations,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            appLocalizations.totalExpense,
                            state.totalExpense,
                            AppColors.expense,
                            Icons.arrow_upward,
                            appLocalizations,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Wallets Section
                    _buildSectionHeader(context, appLocalizations.wallets, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WalletsPage()),
                      );
                    }),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.wallets.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.wallets.length) {
                            return _buildAddWalletCard(context, appLocalizations);
                          }
                          return _buildWalletCard(context, state.wallets[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent Transactions
                    _buildSectionHeader(
                      context,
                      appLocalizations.recentTransactions,
                      () {
                        // TODO: Navigate to transactions page
                      },
                    ),
                    const SizedBox(height: 12),
                    ...state.recentTransactions.map((t) => _buildTransactionItem(context, t)),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
        },
        label: Text(appLocalizations.addTransaction),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    double balance,
    AppLocalizations appLocalizations,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.totalBalance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${appLocalizations.currencySymbol}${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
    IconData icon,
    AppLocalizations appLocalizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${appLocalizations.currencySymbol}${amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback? onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              'See All',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context, Wallet wallet) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.getWalletLightColor(wallet.type.name),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getWalletIcon(wallet.type),
              color: AppColors.getWalletColor(wallet.type.name),
              size: 20,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wallet.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${AppColors.currencySymbol}${wallet.balance.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddWalletCard(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WalletsPage()),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                appLocalizations.addWallet,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionEntity t) {
    final isIncome = t.type == TransactionType.income;
    final isTransfer = t.type == TransactionType.transfer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncome
                  ? AppColors.income.withOpacity(0.1)
                  : isTransfer
                      ? Colors.blue.withOpacity(0.1)
                      : AppColors.expense.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward
                  : isTransfer
                      ? Icons.swap_horiz
                      : Icons.arrow_upward,
              color: isIncome
                  ? AppColors.income
                  : isTransfer
                      ? Colors.blue
                      : AppColors.expense,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTransfer
                      ? 'Transfer'
                      : (t.categoryName ?? (isIncome ? 'Income' : 'Expense')),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  t.date.toString().split(' ')[0],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}${AppColors.currencySymbol}${t.amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isIncome
                  ? AppColors.income
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWalletIcon(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return Icons.money;
      case WalletType.bkash:
      case WalletType.nagad:
        return Icons.phone_android;
      case WalletType.bank:
        return Icons.account_balance;
      case WalletType.other:
        return Icons.wallet;
    }
  }
}
