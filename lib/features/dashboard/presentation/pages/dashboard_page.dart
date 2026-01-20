import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
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
        loanRepository: sl(),
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

                    // Loan Snapshot Section (Per PRD requirement)
                    _buildSectionHeader(context, appLocalizations.loanSnapshot, null),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildLoanCard(
                            context,
                            appLocalizations.outstandingLoan,
                            state.totalLoanGiven,
                            AppColors.success,
                            appLocalizations,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildLoanCard(
                            context,
                            appLocalizations.outstandingDebt,
                            state.totalLoanTaken,
                            AppColors.error,
                            appLocalizations,
                          ),
                        ),
                      ],
                    ),
                    if (state.overdueLoanCount > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Text(
                              '${state.overdueLoanCount} overdue loan(s)',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],

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
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
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
      padding: const EdgeInsets.all(AppTheme.spacingSection),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.totalBalance,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: AppTheme.spacingTight),
          Text(
            '${appLocalizations.currencySymbol}${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
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
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              'See All',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryBlue,
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingTight),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingDefault),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingTight),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.success.withOpacity(0.1)
                    : isTransfer
                        ? AppColors.info.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
              ),
              child: Icon(
                isIncome
                    ? Icons.trending_up
                    : isTransfer
                        ? Icons.swap_horiz
                        : Icons.trending_down,
                color: isIncome
                    ? AppColors.success
                    : isTransfer
                        ? AppColors.info
                        : AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingDefault),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTransfer
                        ? 'Transfer'
                        : (t.categoryName ?? (isIncome ? 'Income' : 'Expense')),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    t.date.toString().split(' ')[0],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${AppColors.currencySymbol}${t.amount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isIncome ? AppColors.success : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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

  Widget _buildLoanCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
    AppLocalizations appLocalizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingDefault),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: AppTheme.spacingTight),
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
}
