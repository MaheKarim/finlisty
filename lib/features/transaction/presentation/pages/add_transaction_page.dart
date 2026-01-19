import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../injection_container.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';

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
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWallets();
  }

  Future<void> _fetchWallets() async {
    final result = await sl<WalletRepository>().getWallets();
    result.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
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
    if (_selectedType == TransactionType.transfer && _selectedDestWallet == null) return;

    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    
    final transaction = TransactionEntity(
      id: const Uuid().v4(), // Generate ID locally or let Firestore handle it (Model ignores ID for new docs usually, but here we pass it)
      amount: amount,
      type: _selectedType,
      walletId: _selectedWallet!.id,
      destinationWalletId: _selectedDestWallet?.id,
      categoryName: _selectedType == TransactionType.expense ? "General" : null, // Todo: Category Picker
      date: _selectedDate,
      note: _noteController.text,
    );

    final result = await sl<TransactionRepository>().addTransaction(transaction);
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      result.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
        (r) => Navigator.pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Transaction"),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Type Selector
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: TransactionType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? _getTypeColor(type) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          type.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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
                  const Text("Amount", style: TextStyle(color: Colors.grey)),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _getTypeColor(_selectedType)),
                    decoration: const InputDecoration(
                      prefixText: "৳",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Wallet Selection
                  _buildDropdown<Wallet>(
                    label: "From Wallet",
                    value: _selectedWallet,
                    items: _wallets,
                    onChanged: (w) => setState(() => _selectedWallet = w),
                    itemLabel: (w) => "${w.name} (৳${w.balance})",
                  ),

                  if (_selectedType == TransactionType.transfer) ...[
                    const SizedBox(height: 24),
                    _buildDropdown<Wallet>(
                      label: "To Wallet",
                      value: _selectedDestWallet,
                      items: _wallets.where((w) => w != _selectedWallet).toList(),
                      onChanged: (w) => setState(() => _selectedDestWallet = w),
                      itemLabel: (w) => "${w.name} (৳${w.balance})",
                    ),
                  ],

                  const SizedBox(height: 24),
                  
                  // Date
                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context, 
                        initialDate: _selectedDate, 
                        firstDate: DateTime(2020), 
                        lastDate: DateTime(2030)
                      );
                      if (d != null) setState(() => _selectedDate = d);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "Date", border: OutlineInputBorder()),
                      child: Text("${_selectedDate.toLocal()}".split(' ')[0]),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Note
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(labelText: "Note (Optional)", border: OutlineInputBorder()),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("SAVE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.income: return AppColors.income;
      case TransactionType.expense: return AppColors.expense;
      case TransactionType.transfer: return Colors.blue;
    }
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) itemLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: const Text("Select"),
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
}
