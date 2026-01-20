import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../../transaction/domain/repositories/transaction_repository.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../widgets/daily_expense_chart.dart';
import '../widgets/category_expense_chart.dart';

/// Analytics page with charts and financial insights
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int _selectedDays = 7;
  Map<DateTime, double> _dailyExpenses = {};
  Map<String, double> _categoryExpenses = {};
  List<MapEntry<String, double>> _topCategories = [];
  double _totalIncome = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenseData();
  }

  Future<void> _loadExpenseData() async {
    setState(() => _isLoading = true);
    
    try {
      final stream = sl<TransactionRepository>().getTransactionsStream();
      final transactions = await stream.first;
      
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: _selectedDays));
      
      final Map<DateTime, double> dailyExpenses = {};
      final Map<String, double> categoryExpenses = {};
      double totalIncome = 0;
      
      for (var transaction in transactions) {
        if (transaction.type == TransactionType.expense &&
            transaction.date.isAfter(startDate)) {
          // Aggregate by day
          final dateKey = DateTime(
            transaction.date.year,
            transaction.date.month,
            transaction.date.day,
          );
          dailyExpenses[dateKey] = (dailyExpenses[dateKey] ?? 0.0) + transaction.amount;
          
          // Aggregate by category
          final category = transaction.categoryName ?? 'Others';
          categoryExpenses[category] = (categoryExpenses[category] ?? 0.0) + transaction.amount;
        }
        if (transaction.type == TransactionType.income &&
            transaction.date.isAfter(startDate)) {
          totalIncome += transaction.amount;
        }
      }
      
      // Get top 3 categories
      final sortedCategories = categoryExpenses.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topCategories = sortedCategories.take(3).toList();
      
      setState(() {
        _dailyExpenses = dailyExpenses;
        _categoryExpenses = categoryExpenses;
        _topCategories = topCategories;
        _totalIncome = totalIncome;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.analyticsTitle),
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenseData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Range Selector
              _buildTimeRangeSelector(context),
              const SizedBox(height: AppTheme.spacingSection),

              // Daily Expense Chart
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                DailyExpenseChart(
                  dailyExpenses: _dailyExpenses,
                  daysToShow: _selectedDays,
                ),
              
              const SizedBox(height: AppTheme.spacingSection),

              // Category-wise Pie Chart (PRD requirement)
              CategoryExpenseChart(categoryExpenses: _categoryExpenses),
              
              const SizedBox(height: AppTheme.spacingSection),

              // Top 3 Expense Categories (PRD requirement)
              if (_topCategories.isNotEmpty) ..._buildTopCategories(context),

              const SizedBox(height: AppTheme.spacingSection),

              // Monthly Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      appLocalizations.totalIncome,
                      '৳${_totalIncome.toStringAsFixed(0)}',
                      AppColors.success,
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingTight),
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      appLocalizations.totalExpense,
                      '৳${_calculateTotalExpense()}',
                      AppColors.error,
                      Icons.trending_down,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeRangeButton(context, '7 Days', 7),
          ),
          Expanded(
            child: _buildTimeRangeButton(context, '30 Days', 30),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(BuildContext context, String label, int days) {
    final isSelected = _selectedDays == days;
    
    return GestureDetector(
      onTap: () {
        setState(() => _selectedDays = days);
        _loadExpenseData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  String _calculateTotalExpense() {
    final total = _dailyExpenses.values.fold(0.0, (sum, amount) => sum + amount);
    return total.toStringAsFixed(0);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Card(
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
            const SizedBox(height: AppTheme.spacingTight),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopCategories(BuildContext context) {
    return [
      Text(
        'Top 3 Expense Categories',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      const SizedBox(height: AppTheme.spacingTight),
      ...List.generate(_topCategories.length, (index) {
        final entry = _topCategories[index];
        final total = _categoryExpenses.values.fold(0.0, (sum, v) => sum + v);
        final percentage = total > 0 ? (entry.value / total) * 100 : 0;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingTight),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _getCategoryDisplayColor(index),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingDefault),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: AppColors.borderLight,
                        color: _getCategoryDisplayColor(index),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingDefault),
              Text(
                '৳${entry.value.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        );
      }),
    ];
  }

  Color _getCategoryDisplayColor(int index) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.accentCyan,
      AppColors.primaryIndigo,
    ];
    return colors[index % colors.length];
  }
}
