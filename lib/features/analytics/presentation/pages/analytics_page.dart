import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';

/// Analytics page with charts and financial insights
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.analyticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // TODO: Implement date range picker
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    appLocalizations.totalIncome,
                    '৳0',
                    Colors.green,
                    Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    appLocalizations.totalExpense,
                    '৳0',
                    Colors.red,
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              context,
              appLocalizations.netBalance,
              '৳0',
              Theme.of(context).colorScheme.primary,
              Icons.account_balance_wallet,
            ),
            const SizedBox(height: 24),

            // Category-wise Expense Chart
            _buildSectionHeader(context, appLocalizations.categoryWiseExpense),
            const SizedBox(height: 12),
            _buildChartPlaceholder(context),

            const SizedBox(height: 24),

            // Top Categories
            _buildSectionHeader(context, appLocalizations.topCategories),
            const SizedBox(height: 12),
            _buildCategoriesList(context),

            const SizedBox(height: 24),

            // Loan Snapshot
            _buildSectionHeader(context, appLocalizations.loanSnapshot),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLoanCard(
                    context,
                    appLocalizations.outstandingLoan,
                    '৳0',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLoanCard(
                    context,
                    appLocalizations.outstandingDebt,
                    '৳0',
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    Color color,
    IconData icon,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChartPlaceholder(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 60,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 0,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        itemBuilder: (context, index) {
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoanCard(
    BuildContext context,
    String title,
    String amount,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 8),
          Text(
            amount,
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
