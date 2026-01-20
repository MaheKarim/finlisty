import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/languages/app_localizations.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/theme_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/transaction/presentation/pages/transactions_page.dart';
import 'features/analytics/presentation/pages/analytics_page.dart';
import 'features/loan/presentation/pages/loans_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

/// Main app wrapper with providers and bottom navigation
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsPage(),
    const AnalyticsPage(),
    const LoansPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          final locale = Locale(languageProvider.languageCode);
          final appLocalizations = AppLocalizations(locale);

          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: appLocalizations.navHome,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.receipt_long_outlined),
                activeIcon: const Icon(Icons.receipt_long),
                label: appLocalizations.navTransactions,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.insert_chart_outlined),
                activeIcon: const Icon(Icons.insert_chart),
                label: appLocalizations.navAnalytics,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                activeIcon: const Icon(Icons.account_balance_wallet),
                label: appLocalizations.navLoans,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: appLocalizations.navSettings,
              ),
            ],
          );
        },
      ),
    );
  }
}
