import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../wallet/domain/entities/wallet.dart';

/// Wallets management page
class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.wallets),
      ),
      body: Center(
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
              appLocalizations.noData,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWalletPage()),
          );
        },
        label: Text(appLocalizations.addWallet),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

/// Add/Edit Wallet page
class AddWalletPage extends StatefulWidget {
  final Wallet? wallet;

  const AddWalletPage({super.key, this.wallet});

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  WalletType _selectedType = WalletType.cash;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.wallet != null) {
      _nameController.text = widget.wallet!.name;
      _balanceController.text = widget.wallet!.balance.toString();
      _selectedType = widget.wallet!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _saveWallet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement wallet save logic

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.wallet == null
              ? appLocalizations.addWalletTitle
              : appLocalizations.editWalletTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Wallet Type Selection
            Text(
              appLocalizations.walletType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildWalletTypeSelector(context, appLocalizations),
            const SizedBox(height: 24),

            // Wallet Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: appLocalizations.walletName,
                hintText: 'e.g. My Cash Wallet',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter wallet name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Initial Balance
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: appLocalizations.initialBalance,
                prefixText: appLocalizations.currencySymbol,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter initial balance';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveWallet,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(appLocalizations.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletTypeSelector(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: WalletType.values.map((type) {
          return Column(
            children: [
              if (type != WalletType.values.first)
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              _buildWalletTypeOption(context, type, appLocalizations),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWalletTypeOption(
    BuildContext context,
    WalletType type,
    AppLocalizations appLocalizations,
  ) {
    final isSelected = _selectedType == type;
    String label;
    IconData icon;

    switch (type) {
      case WalletType.cash:
        label = appLocalizations.walletTypeCash;
        icon = Icons.money;
        break;
      case WalletType.bkash:
        label = appLocalizations.walletTypeBkash;
        icon = Icons.phone_android;
        break;
      case WalletType.nagad:
        label = appLocalizations.walletTypeNagad;
        icon = Icons.phone_android;
        break;
      case WalletType.bank:
        label = appLocalizations.walletTypeBank;
        icon = Icons.account_balance;
        break;
      case WalletType.other:
        label = appLocalizations.walletTypeOther;
        icon = Icons.wallet;
        break;
    }

    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
