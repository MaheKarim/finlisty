import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../../../category/domain/entities/category.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TransactionType _selectedType = TransactionType.expense;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<Wallet> _wallets = [];
  Wallet? _selectedWallet;
  Wallet? _selectedDestWallet; // For Transfer
  Category? _selectedCategory;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWallets();
  }

  Future<void> _fetchWallets() async {
    final result = await sl<WalletRepository>().getWallets();
    result.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.message)),
      ),
      (r) {
        setState(() {
          _wallets = r;
          if (_wallets.isNotEmpty) _selectedWallet = _wallets.first;
        });
      },
    );
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty || _selectedWallet == null) return;
    if (_selectedType == TransactionType.transfer &&
        _selectedDestWallet == null) return;
    if (_selectedType == TransactionType.expense && _selectedCategory == null) return;

    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0.0;

    final transaction = TransactionEntity(
      id: const Uuid().v4(),
      amount: amount,
      type: _selectedType,
      walletId: _selectedWallet!.id,
      destinationWalletId: _selectedDestWallet?.id,
      categoryId: _selectedCategory?.id,
      categoryName: _selectedCategory?.nameEn,
      date: _selectedDate,
      note: _noteController.text,
    );

    final result = await sl<TransactionRepository>().addTransaction(transaction);

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(appLocalizations.addTransaction),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Type Selector
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: TransactionType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? _getTypeColor(type) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          type.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 20),
                  // Amount
                  Text(
                    appLocalizations.amount,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(_selectedType),
                    ),
                    decoration: InputDecoration(
                      prefixText: appLocalizations.currencySymbol,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Wallet Selection
                  _buildDropdown<Wallet>(
                    context: context,
                    label: appLocalizations.fromWallet,
                    value: _selectedWallet,
                    items: _wallets,
                    onChanged: (w) => setState(() => _selectedWallet = w),
                    itemLabel: (w) => '${w.name} (${appLocalizations.currencySymbol}${w.balance})',
                    appLocalizations: appLocalizations,
                  ),

                  if (_selectedType == TransactionType.transfer) ...[
                    const SizedBox(height: 24),
                    _buildDropdown<Wallet>(
                      context: context,
                      label: appLocalizations.toWallet,
                      value: _selectedDestWallet,
                      items: _wallets.where((w) => w != _selectedWallet).toList(),
                      onChanged: (w) => setState(() => _selectedDestWallet = w),
                      itemLabel: (w) => '${w.name} (${appLocalizations.currencySymbol}${w.balance})',
                      appLocalizations: appLocalizations,
                    ),
                  ],

                  if (_selectedType == TransactionType.expense) ...[
                    const SizedBox(height: 24),
                    // Category Selection
                    Text(
                      appLocalizations.category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryGrid(context, appLocalizations),
                  ],

                  const SizedBox(height: 24),

                  // Date
                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _selectedDate = d);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: appLocalizations.date,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Note
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.noteOptional,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getTypeColor(_selectedType),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          appLocalizations.save.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) itemLabel,
    required AppLocalizations appLocalizations,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(appLocalizations.selectWallet),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(itemLabel(item)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context, AppLocalizations appLocalizations) {
    final categories = _getDefaultCategories();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory?.id == category.id;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.getCategoryColor(category.nameEn).withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.getCategoryColor(category.nameEn)
                    : Theme.of(context).colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(category.nameEn),
                  color: isSelected
                      ? AppColors.getCategoryColor(category.nameEn)
                      : Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 4),
                Text(
                  category.getLocalizedName(appLocalizations.locale.languageCode),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppColors.getCategoryColor(category.nameEn)
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(
        id: 'cat_food',
        nameEn: 'Food',
        nameBn: 'খাবার',
        icon: 'restaurant',
        color: AppColors.categoryFood.value.toRadixString(16),
      ),
      Category(
        id: 'cat_transport',
        nameEn: 'Transport',
        nameBn: 'যাতায়াত',
        icon: 'directions_bus',
        color: AppColors.categoryTransport.value.toRadixString(16),
      ),
      Category(
        id: 'cat_rent',
        nameEn: 'Rent',
        nameBn: 'ভাড়া',
        icon: 'home',
        color: AppColors.categoryRent.value.toRadixString(16),
      ),
      Category(
        id: 'cat_bill',
        nameEn: 'Bill',
        nameBn: 'বিল',
        icon: 'receipt',
        color: AppColors.categoryBill.value.toRadixString(16),
      ),
      Category(
        id: 'cat_shopping',
        nameEn: 'Shopping',
        nameBn: 'শপিং',
        icon: 'shopping_bag',
        color: AppColors.categoryShopping.value.toRadixString(16),
      ),
      Category(
        id: 'cat_health',
        nameEn: 'Health',
        nameBn: 'স্বাস্থ্য',
        icon: 'local_hospital',
        color: AppColors.categoryHealth.value.toRadixString(16),
      ),
      Category(
        id: 'cat_others',
        nameEn: 'Others',
        nameBn: 'অন্যান্য',
        icon: 'more_horiz',
        color: AppColors.categoryOthers.value.toRadixString(16),
      ),
    ];
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_bus;
      case 'rent':
        return Icons.home;
      case 'bill':
        return Icons.receipt;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
        return Icons.local_hospital;
      default:
        return Icons.more_horiz;
    }
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return AppColors.income;
      case TransactionType.expense:
        return AppColors.expense;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }
}
