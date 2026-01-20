import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/loan.dart';
import '../../domain/repositories/loan_repository.dart';

class AddLoanPage extends StatefulWidget {
  const AddLoanPage({super.key});

  @override
  State<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  LoanType _type = LoanType.given;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime? _dueDate;

  bool _isLoading = false;

  Future<void> _saveLoan() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final interest = double.tryParse(_interestController.text);

    final loan = Loan(
      id: '',
      personName: _nameController.text,
      type: _type,
      principalAmount: amount,
      outstandingAmount: amount,
      interestRate: interest,
      startDate: _startDate,
      dueDate: _dueDate,
      status: LoanStatus.active,
    );

    final result = await sl<LoanRepository>().addLoan(loan);

    setState(() => _isLoading = false);

    if (mounted) {
      result.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.message)),
        ),
        (r) => Navigator.pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.addLoanTitle(
          _type == LoanType.given ? appLocalizations.loanGiven : appLocalizations.loanTaken,
        )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Segmented Control
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSegment(
                      context,
                      appLocalizations.loanGiven,
                      LoanType.given,
                      appLocalizations,
                    ),
                  ),
                  Expanded(
                    child: _buildSegment(
                      context,
                      appLocalizations.loanTaken,
                      LoanType.taken,
                      appLocalizations,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Person Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: appLocalizations.personName,
                hintText: 'e.g. Rahim',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter person name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: appLocalizations.principalAmount,
                prefixText: appLocalizations.currencySymbol,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date Row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _startDate = d);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: appLocalizations.startDate,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('${_startDate.toLocal()}'.split(' ')[0]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _startDate.add(const Duration(days: 30)),
                        firstDate: _startDate,
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _dueDate = d);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: appLocalizations.dueDateOptional,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _dueDate != null ? '${_dueDate!.toLocal()}'.split(' ')[0] : 'Select',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Interest Rate
            TextFormField(
              controller: _interestController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: appLocalizations.interestRate,
                suffixText: '%',
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _type == LoanType.given ? AppColors.income : AppColors.expense,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _type == LoanType.given ? 'LEND MONEY' : 'BORROW MONEY',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(
    BuildContext context,
    String title,
    LoanType type,
    AppLocalizations appLocalizations,
  ) {
    final isSelected = _type == type;
    final color = type == LoanType.given ? AppColors.income : AppColors.expense;

    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
