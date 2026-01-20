import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';

/// Recurring Bills page
class RecurringBillsPage extends StatelessWidget {
  const RecurringBillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.recurringBills),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
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
          // TODO: Navigate to add bill page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add Bill coming soon')),
          );
        },
        label: Text(appLocalizations.addBill),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
