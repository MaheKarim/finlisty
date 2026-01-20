import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'add_transaction_page.dart';

/// Transactions list page
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.navTransactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: StreamBuilder<List<TransactionEntity>>(
        stream: sl<TransactionRepository>().getTransactionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transactions = snapshot.data ?? [];

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appLocalizations.noData,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingDefault),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
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
            },
          );
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
      ),
    );
  }
}
