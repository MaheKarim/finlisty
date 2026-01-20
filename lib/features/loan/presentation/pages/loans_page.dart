import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/loan.dart';
import '../../domain/repositories/loan_repository.dart';
import 'add_loan_page.dart';
import 'loan_repayment_page.dart';

/// Loans list page - displays all loans with filtering
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
        body: StreamBuilder<List<Loan>>(
          stream: sl<LoanRepository>().getLoansStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final allLoans = snapshot.data ?? [];
            final givenLoans = allLoans.where((l) => l.type == LoanType.given).toList();
            final takenLoans = allLoans.where((l) => l.type == LoanType.taken).toList();

            return TabBarView(
              children: [
                _buildLoansList(context, givenLoans, appLocalizations, true),
                _buildLoansList(context, takenLoans, appLocalizations, false),
                _buildLoansList(context, allLoans, appLocalizations, null),
              ],
            );
          },
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
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoansList(
    BuildContext context,
    List<Loan> loans,
    AppLocalizations appLocalizations,
    bool? isGiven,
  ) {
    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isGiven == true
                  ? 'No loans given yet'
                  : isGiven == false
                      ? 'No loans taken yet'
                      : 'No loans yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingDefault),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return _buildLoanCard(context, loan, appLocalizations);
      },
    );
  }

  Widget _buildLoanCard(
    BuildContext context,
    Loan loan,
    AppLocalizations appLocalizations,
  ) {
    final isGiven = loan.type == LoanType.given;
    final color = isGiven ? AppColors.success : AppColors.error;
    final isOverdue = loan.dueDate != null && 
        loan.dueDate!.isBefore(DateTime.now()) && 
        loan.status == LoanStatus.active;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingTight),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoanRepaymentPage(loan: loan),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingTight),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                    ),
                    child: Icon(
                      isGiven ? Icons.arrow_upward : Icons.arrow_downward,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingDefault),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.personName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          isGiven 
                              ? appLocalizations.loanGiven 
                              : appLocalizations.loanTaken,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${appLocalizations.currencySymbol}${loan.outstandingAmount.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                      if (loan.status == LoanStatus.closed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Closed',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (isOverdue) ...[
                const SizedBox(height: AppTheme.spacingTight),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingTight,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Overdue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
              if (loan.dueDate != null) ...[
                const SizedBox(height: AppTheme.spacingTight),
                Text(
                  'Due: ${loan.dueDate!.day}/${loan.dueDate!.month}/${loan.dueDate!.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
