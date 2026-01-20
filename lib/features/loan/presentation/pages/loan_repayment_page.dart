import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/loan.dart';
import '../../domain/repositories/loan_repository.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';

/// Loan Repayment Page - handles partial and full payments
/// Per PRD: Add loan, Partial repayment, Full settlement, Auto wallet adjustment
class LoanRepaymentPage extends StatefulWidget {
  final Loan loan;

  const LoanRepaymentPage({super.key, required this.loan});

  @override
  State<LoanRepaymentPage> createState() => _LoanRepaymentPageState();
}

class _LoanRepaymentPageState extends State<LoanRepaymentPage> {
  final _amountController = TextEditingController();
  String? _selectedWalletId;
  bool _isLoading = false;
  List<Wallet> _wallets = [];

  @override
  void initState() {
    super.initState();
    _loadWallets();
    _selectedWalletId = widget.loan.linkedWalletId;
  }

  Future<void> _loadWallets() async {
    final walletsStream = sl<WalletRepository>().getWalletsStream();
    walletsStream.listen((wallets) {
      if (mounted) {
        setState(() => _wallets = wallets);
      }
    });
  }

  Future<void> _makePayment(bool isFullSettlement) async {
    final amount = isFullSettlement
        ? widget.loan.outstandingAmount
        : double.tryParse(_amountController.text) ?? 0.0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (amount > widget.loan.outstandingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount exceeds outstanding balance')),
      );
      return;
    }

    if (_selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a wallet')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final isLoanGiven = widget.loan.type == LoanType.given;
    final result = await sl<LoanRepository>().repayLoan(
      widget.loan.id,
      amount,
      _selectedWalletId!,
      isLoanGiven,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      result.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        ),
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFullSettlement ? 'Loan settled!' : 'Payment recorded!',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);
    final isGiven = widget.loan.type == LoanType.given;
    final color = isGiven ? AppColors.success : AppColors.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(isGiven ? 'Receive Payment' : 'Make Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingSection),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Summary Card
            Container(
              width: double.infinity,
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
                    widget.loan.personName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingTight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outstanding Amount',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      Text(
                        '${appLocalizations.currencySymbol}${widget.loan.outstandingAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingTight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Principal Amount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      Text(
                        '${appLocalizations.currencySymbol}${widget.loan.principalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingSection),

            // Payment Amount
            Text(
              'Payment Amount',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingTight),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: appLocalizations.currencySymbol,
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSection),

            // Wallet Selection
            Text(
              isGiven ? 'Receive To Wallet' : 'Pay From Wallet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingTight),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedWalletId,
                  hint: const Text('Select wallet'),
                  isExpanded: true,
                  items: _wallets.map((wallet) {
                    return DropdownMenuItem(
                      value: wallet.id,
                      child: Row(
                        children: [
                          Text(wallet.name),
                          const Spacer(),
                          Text(
                            '${appLocalizations.currencySymbol}${wallet.balance.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedWalletId = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSection),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _makePayment(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Record Partial Payment'),
              ),
            ),
            const SizedBox(height: AppTheme.spacingDefault),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => _makePayment(true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(color: AppColors.success),
                ),
                child: Text(
                  'Full Settlement (${appLocalizations.currencySymbol}${widget.loan.outstandingAmount.toStringAsFixed(0)})',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
