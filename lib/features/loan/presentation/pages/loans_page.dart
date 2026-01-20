import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import 'add_loan_page.dart';

/// Loans list page
class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.navLoans),
          bottom: TabBar(
            tabs: [
              Tab(text: appLocalizations.loanGiven),
              Tab(text: appLocalizations.loanTaken),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLoansList(context, appLocalizations.loanGiven),
            _buildLoansList(context, appLocalizations.loanTaken),
            _buildLoansList(context, 'All'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddLoanPage()),
            );
          },
          label: Text(appLocalizations.addLoanTitle('Loan')),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildLoansList(BuildContext context, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No $title yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
