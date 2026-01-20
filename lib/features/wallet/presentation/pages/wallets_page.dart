import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../../../../injection_container.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardLoaded) {
            if (state.errorMessage != null) {
              String message = state.errorMessage!;
              if (message == 'deleteWalletErrorBalance') {
                 message = appLocalizations.deleteWalletErrorBalance;
              } else if (message == 'deleteWalletErrorDependents') {
                 message = appLocalizations.deleteWalletErrorDependents;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.error,
                ),
              );
              context.read<DashboardBloc>().add(ClearDashboardError());
            } else if (state.successMessage != null) {
              String message = state.successMessage!;
              if (message == 'deleteWalletSuccess') {
                 message = appLocalizations.deleteWalletSuccess;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<DashboardBloc>().add(ClearDashboardError());
            }
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardLoaded) {
            if (state.wallets.isEmpty) {
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
                      appLocalizations.noWallets,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appLocalizations.noWalletsSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.wallets.length,
              itemBuilder: (context, index) {
                final wallet = state.wallets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.getWalletLightColor(wallet.type.name),
                      child: Icon(
                        _getWalletIcon(wallet.type),
                        color: AppColors.getWalletColor(wallet.type.name),
                      ),
                    ),
                    title: Text(wallet.name),
                    subtitle: Text(wallet.type.name.toUpperCase()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${appLocalizations.currencySymbol}${wallet.balance.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(appLocalizations.delete),
                                content: Text(appLocalizations.deleteWalletConfirm),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(appLocalizations.cancel),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.read<DashboardBloc>().add(
                                        DeleteWalletRequested(
                                          walletId: wallet.id,
                                          currentBalance: wallet.balance,
                                        ),
                                      );
                                    },
                                    style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                                    child: Text(appLocalizations.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddWalletPage(wallet: wallet),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
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

  IconData _getWalletIcon(WalletType type) {
    switch (type) {
      case WalletType.cash: return Icons.money;
      case WalletType.bkash: return Icons.phone_android;
      case WalletType.nagad: return Icons.phone_android;
      case WalletType.bank: return Icons.account_balance;
      case WalletType.other: return Icons.wallet;
    }
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

    final name = _nameController.text;
    final balance = double.tryParse(_balanceController.text) ?? 0.0;
    
    // Get color based on type
    final color = AppColors.getWalletColor(_selectedType.name).value.toRadixString(16);

    final newWallet = Wallet(
      id: widget.wallet?.id ?? '',
      name: name,
      type: _selectedType,
      balance: balance,
      color: '#$color', // Basic hex string
      isArchived: widget.wallet?.isArchived ?? false,
    );

    final result = widget.wallet == null
        ? await sl<WalletRepository>().addWallet(newWallet)
        : await sl<WalletRepository>().updateWallet(newWallet);

    setState(() => _isLoading = false);

    if (mounted) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.wallet == null
                  ? 'Wallet added successfully'
                  : 'Wallet updated successfully'),
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
