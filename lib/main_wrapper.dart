import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_colors.dart';
import 'core/languages/app_localizations.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/theme_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/transaction/presentation/pages/transactions_page.dart';
import 'features/analytics/presentation/pages/analytics_page.dart';
import 'features/wallet/presentation/pages/wallets_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'core/providers/navigation_provider.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main app wrapper with providers and bottom navigation
class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.currentIndex;

    final List<Widget> pages = [
      const DashboardPage(),
      const TransactionsPage(),
      const AnalyticsPage(),
      const WalletsPage(),
      const SettingsPage(),
    ];

    return BlocProvider(
      create: (_) => DashboardBloc(
        walletRepository: sl(),
        transactionRepository: sl(),
        loanRepository: sl(),
        deleteWallet: sl(),
        getTransactionCount: sl(),
        getLinkedLoanCount: sl(),
      )..add(SubscribeDashboardData()),
      child: Scaffold(
        body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          final locale = Locale(languageProvider.languageCode);
          final appLocalizations = AppLocalizations(locale);

          return BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => navigationProvider.setIndex(index),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.textSecondary,
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
                label: appLocalizations.wallets, 
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: appLocalizations.navSettings,
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}
