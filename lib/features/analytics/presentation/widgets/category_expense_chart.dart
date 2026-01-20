import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';

/// Category-wise expense pie chart widget
/// Per PRD: Category-wise expense pie chart on Analytics page
class CategoryExpenseChart extends StatefulWidget {
  final Map<String, double> categoryExpenses;

  const CategoryExpenseChart({
    super.key,
    required this.categoryExpenses,
  });

  @override
  State<CategoryExpenseChart> createState() => _CategoryExpenseChartState();
}

class _CategoryExpenseChartState extends State<CategoryExpenseChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.categoryExpenses.values.fold(0.0, (sum, v) => sum + v);
    
    if (widget.categoryExpenses.isEmpty || total == 0) {
      return _buildEmptyState(context);
    }

    final sortedCategories = widget.categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category-wise Expenses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppTheme.spacingSection),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                response.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _buildSections(sortedCategories, total),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingDefault),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sortedCategories.take(5).map((entry) {
                    final index = sortedCategories.indexOf(entry);
                    return _buildLegendItem(
                      context,
                      entry.key,
                      entry.value,
                      _getCategoryColor(index),
                      total,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    List<MapEntry<String, double>> categories,
    double total,
  ) {
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final isTouched = index == touchedIndex;
      final percentage = (category.value / total) * 100;

      return PieChartSectionData(
        color: _getCategoryColor(index),
        value: category.value,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 60 : 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem(
    BuildContext context,
    String category,
    double amount,
    Color color,
    double total,
  ) {
    final percentage = (amount / total) * 100;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      AppColors.categoryFood,
      AppColors.categoryTransport,
      AppColors.categoryRent,
      AppColors.categoryBill,
      AppColors.categoryShopping,
      AppColors.categoryHealth,
      AppColors.categoryOther,
      AppColors.primaryBlue,
      AppColors.accentCyan,
      AppColors.primaryIndigo,
    ];
    return colors[index % colors.length];
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category-wise Expenses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppTheme.spacingSection),
          SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No expense data available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
