import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// App localization class for multi-language support
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // ========================
  // Common
  // ========================
  String get appName => _localizedValues[locale.languageCode]!['appName']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;

  // ========================
  // Navigation
  // ========================
  String get navHome => _localizedValues[locale.languageCode]!['navHome']!;
  String get navTransactions => _localizedValues[locale.languageCode]!['navTransactions']!;
  String get navAnalytics => _localizedValues[locale.languageCode]!['navAnalytics']!;
  String get navLoans => _localizedValues[locale.languageCode]!['navLoans']!;
  String get navSettings => _localizedValues[locale.languageCode]!['navSettings']!;

  // ========================
  // Dashboard
  // ========================
  String get dashboardTitle => _localizedValues[locale.languageCode]!['dashboardTitle']!;
  String get totalBalance => _localizedValues[locale.languageCode]!['totalBalance']!;
  String get totalIncome => _localizedValues[locale.languageCode]!['totalIncome']!;
  String get totalExpense => _localizedValues[locale.languageCode]!['totalExpense']!;
  String get netBalance => _localizedValues[locale.languageCode]!['netBalance']!;
  String get wallets => _localizedValues[locale.languageCode]!['wallets']!;
  String get recentTransactions => _localizedValues[locale.languageCode]!['recentTransactions']!;
  String get addTransaction => _localizedValues[locale.languageCode]!['addTransaction']!;
  String get addWallet => _localizedValues[locale.languageCode]!['addWallet']!;
  String get outstandingLoan => _localizedValues[locale.languageCode]!['outstandingLoan']!;
  String get outstandingDebt => _localizedValues[locale.languageCode]!['outstandingDebt']!;

  // ========================
  // Transaction
  // ========================
  String get transactionType => _localizedValues[locale.languageCode]!['transactionType']!;
  String get income => _localizedValues[locale.languageCode]!['income']!;
  String get expense => _localizedValues[locale.languageCode]!['expense']!;
  String get transfer => _localizedValues[locale.languageCode]!['transfer']!;
  String get amount => _localizedValues[locale.languageCode]!['amount']!;
  String get category => _localizedValues[locale.languageCode]!['category']!;
  String get fromWallet => _localizedValues[locale.languageCode]!['fromWallet']!;
  String get toWallet => _localizedValues[locale.languageCode]!['toWallet']!;
  String get date => _localizedValues[locale.languageCode]!['date']!;
  String get note => _localizedValues[locale.languageCode]!['note']!;
  String get noteOptional => _localizedValues[locale.languageCode]!['noteOptional']!;
  String get selectCategory => _localizedValues[locale.languageCode]!['selectCategory']!;
  String get selectWallet => _localizedValues[locale.languageCode]!['selectWallet']!;

  // ========================
  // Wallet
  // ========================
  String get walletName => _localizedValues[locale.languageCode]!['walletName']!;
  String get walletType => _localizedValues[locale.languageCode]!['walletType']!;
  String get walletTypeCash => _localizedValues[locale.languageCode]!['walletTypeCash']!;
  String get walletTypeBkash => _localizedValues[locale.languageCode]!['walletTypeBkash']!;
  String get walletTypeNagad => _localizedValues[locale.languageCode]!['walletTypeNagad']!;
  String get walletTypeBank => _localizedValues[locale.languageCode]!['walletTypeBank']!;
  String get walletTypeOther => _localizedValues[locale.languageCode]!['walletTypeOther']!;
  String get initialBalance => _localizedValues[locale.languageCode]!['initialBalance']!;
  String get addWalletTitle => _localizedValues[locale.languageCode]!['addWalletTitle']!;
  String get editWalletTitle => _localizedValues[locale.languageCode]!['editWalletTitle']!;
  String get deleteWalletConfirm => _localizedValues[locale.languageCode]!['deleteWalletConfirm']!;
  String get deleteWalletSuccess => _localizedValues[locale.languageCode]!['deleteWalletSuccess']!;
  String get deleteWalletErrorBalance => _localizedValues[locale.languageCode]!['deleteWalletErrorBalance']!;
  String get deleteWalletErrorDependents => _localizedValues[locale.languageCode]!['deleteWalletErrorDependents']!;
  String get noWallets => _localizedValues[locale.languageCode]!['noWallets']!;
  String get noWalletsSubtitle => _localizedValues[locale.languageCode]!['noWalletsSubtitle']!;
  String get noTransactions => _localizedValues[locale.languageCode]!['noTransactions']!;
  String get noTransactionsSubtitle => _localizedValues[locale.languageCode]!['noTransactionsSubtitle']!;

  // ========================
  // Category
  // ========================
  String get categoryFood => _localizedValues[locale.languageCode]!['categoryFood']!;
  String get categoryTransport => _localizedValues[locale.languageCode]!['categoryTransport']!;
  String get categoryRent => _localizedValues[locale.languageCode]!['categoryRent']!;
  String get categoryBill => _localizedValues[locale.languageCode]!['categoryBill']!;
  String get categoryShopping => _localizedValues[locale.languageCode]!['categoryShopping']!;
  String get categoryHealth => _localizedValues[locale.languageCode]!['categoryHealth']!;
  String get categoryOthers => _localizedValues[locale.languageCode]!['categoryOthers']!;

  // ========================
  // Loan
  // ========================
  String get loans => _localizedValues[locale.languageCode]!['loans']!;
  String get loanGiven => _localizedValues[locale.languageCode]!['loanGiven']!;
  String get loanTaken => _localizedValues[locale.languageCode]!['loanTaken']!;
  String get personName => _localizedValues[locale.languageCode]!['personName']!;
  String get principalAmount => _localizedValues[locale.languageCode]!['principalAmount']!;
  String get outstandingAmount => _localizedValues[locale.languageCode]!['outstandingAmount']!;
  String get interestRate => _localizedValues[locale.languageCode]!['interestRate']!;
  String get startDate => _localizedValues[locale.languageCode]!['startDate']!;
  String get dueDate => _localizedValues[locale.languageCode]!['dueDate']!;
  String get dueDateOptional => _localizedValues[locale.languageCode]!['dueDateOptional']!;
  String addLoanTitle(String type) => _localizedValues[locale.languageCode]!['addLoanTitle']!.replaceAll('{type}', type);
  String get repay => _localizedValues[locale.languageCode]!['repay']!;
  String get settle => _localizedValues[locale.languageCode]!['settle']!;
  String get repaymentAmount => _localizedValues[locale.languageCode]!['repaymentAmount']!;
  String get activeLoans => _localizedValues[locale.languageCode]!['activeLoans']!;
  String get closedLoans => _localizedValues[locale.languageCode]!['closedLoans']!;

  // ========================
  // Recurring Bill
  // ========================
  String get recurringBills => _localizedValues[locale.languageCode]!['recurringBills']!;
  String get addBill => _localizedValues[locale.languageCode]!['addBill']!;
  String get billName => _localizedValues[locale.languageCode]!['billName']!;
  String get frequency => _localizedValues[locale.languageCode]!['frequency']!;
  String get frequencyWeekly => _localizedValues[locale.languageCode]!['frequencyWeekly']!;
  String get frequencyMonthly => _localizedValues[locale.languageCode]!['frequencyMonthly']!;
  String get nextDueDate => _localizedValues[locale.languageCode]!['nextDueDate']!;
  String get markAsPaid => _localizedValues[locale.languageCode]!['markAsPaid']!;
  String get overdue => _localizedValues[locale.languageCode]!['overdue']!;
  String get dueInDays => _localizedValues[locale.languageCode]!['dueInDays']!;
  String get dueToday => _localizedValues[locale.languageCode]!['dueToday']!;

  // ========================
  // Analytics
  // ========================
  String get analyticsTitle => _localizedValues[locale.languageCode]!['analyticsTitle']!;
  String get monthlySummary => _localizedValues[locale.languageCode]!['monthlySummary']!;
  String get categoryWiseExpense => _localizedValues[locale.languageCode]!['categoryWiseExpense']!;
  String get topCategories => _localizedValues[locale.languageCode]!['topCategories']!;
  String get loanSnapshot => _localizedValues[locale.languageCode]!['loanSnapshot']!;
  String get monthlyRepayment => _localizedValues[locale.languageCode]!['monthlyRepayment']!;

  // ========================
  // Settings
  // ========================
  String get settingsTitle => _localizedValues[locale.languageCode]!['settingsTitle']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get lightMode => _localizedValues[locale.languageCode]!['lightMode']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get systemMode => _localizedValues[locale.languageCode]!['systemMode']!;
  String get security => _localizedValues[locale.languageCode]!['security']!;
  String get pinLock => _localizedValues[locale.languageCode]!['pinLock']!;
  String get biometricLock => _localizedValues[locale.languageCode]!['biometricLock']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get signOut => _localizedValues[locale.languageCode]!['signOut']!;

  // ========================
  // Currency
  // ========================
  String get currencySymbol => _localizedValues[locale.languageCode]!['currencySymbol']!;

  // ========================
  // Localization Values
  // ========================
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'appName': 'Finlisty',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'loading': 'Loading...',
      'error': 'Error',
      'noData': 'No data available',
      'retry': 'Retry',

      // Navigation
      'navHome': 'Home',
      'navTransactions': 'Transactions',
      'navAnalytics': 'Analytics',
      'navLoans': 'Loans',
      'navSettings': 'Settings',

      // Dashboard
      'dashboardTitle': 'Dashboard',
      'totalBalance': 'Total Balance',
      'totalIncome': 'Total Income',
      'totalExpense': 'Total Expense',
      'netBalance': 'Net Balance',
      'wallets': 'Wallets',
      'recentTransactions': 'Recent Transactions',
      'addTransaction': 'Add Transaction',
      'addWallet': 'Add Wallet',
      'outstandingLoan': 'Outstanding Loan',
      'outstandingDebt': 'Outstanding Debt',

      // Transaction
      'transactionType': 'Transaction Type',
      'income': 'Income',
      'expense': 'Expense',
      'transfer': 'Transfer',
      'amount': 'Amount',
      'category': 'Category',
      'fromWallet': 'From Wallet',
      'toWallet': 'To Wallet',
      'date': 'Date',
      'note': 'Note',
      'noteOptional': 'Note (Optional)',
      'selectCategory': 'Select Category',
      'selectWallet': 'Select Wallet',

      // Wallet
      'walletName': 'Wallet Name',
      'walletType': 'Wallet Type',
      'walletTypeCash': 'Cash',
      'walletTypeBkash': 'bKash',
      'walletTypeNagad': 'Nagad',
      'walletTypeBank': 'Bank',
      'walletTypeOther': 'Other',
      'initialBalance': 'Initial Balance',
      'addWalletTitle': 'Add Wallet',
      'editWalletTitle': 'Edit Wallet',
      'deleteWalletConfirm': 'Are you sure you want to delete this wallet?',
      'deleteWalletSuccess': 'Wallet deleted successfully',
      'deleteWalletErrorBalance': 'Cannot delete wallet with non-zero balance',
      'deleteWalletErrorDependents': 'Cannot delete wallet with linked transactions or active loans',
      'noWallets': 'No wallets found',
      'noWalletsSubtitle': 'Add your first Cash, bKash, or Bank wallet',
      'noTransactions': 'No transactions yet',
      'noTransactionsSubtitle': 'Add your first income or expense to get started',

      // Category
      'categoryFood': 'Food',
      'categoryTransport': 'Transport',
      'categoryRent': 'Rent',
      'categoryBill': 'Bill',
      'categoryShopping': 'Shopping',
      'categoryHealth': 'Health',
      'categoryOthers': 'Others',

      // Loan
      'loans': 'Loans',
      'loanGiven': 'Loan Given',
      'loanTaken': 'Loan Taken',
      'personName': 'Person Name',
      'principalAmount': 'Principal Amount',
      'outstandingAmount': 'Outstanding Amount',
      'interestRate': 'Interest Rate',
      'startDate': 'Start Date',
      'dueDate': 'Due Date',
      'dueDateOptional': 'Due Date (Optional)',
      'addLoanTitle': 'Add {type}',
      'repay': 'Repay',
      'settle': 'Settle',
      'repaymentAmount': 'Repayment Amount',
      'activeLoans': 'Active Loans',
      'closedLoans': 'Closed Loans',

      // Recurring Bill
      'recurringBills': 'Recurring Bills',
      'addBill': 'Add Bill',
      'billName': 'Bill Name',
      'frequency': 'Frequency',
      'frequencyWeekly': 'Weekly',
      'frequencyMonthly': 'Monthly',
      'nextDueDate': 'Next Due Date',
      'markAsPaid': 'Mark as Paid',
      'overdue': 'Overdue',
      'dueInDays': 'Due in {days} days',
      'dueToday': 'Due Today',

      // Analytics
      'analyticsTitle': 'Analytics',
      'monthlySummary': 'Monthly Summary',
      'categoryWiseExpense': 'Category-wise Expense',
      'topCategories': 'Top Categories',
      'loanSnapshot': 'Loan Snapshot',
      'monthlyRepayment': 'Monthly Repayment',

      // Settings
      'settingsTitle': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'lightMode': 'Light',
      'darkMode': 'Dark',
      'systemMode': 'System',
      'security': 'Security',
      'pinLock': 'PIN Lock',
      'biometricLock': 'Biometric Lock',
      'about': 'About',
      'version': 'Version',
      'signOut': 'Sign Out',

      // Currency
      'currencySymbol': '৳',
    },
    'bn': {
      // Common
      'appName': 'ফিনলিস্টি',
      'ok': 'ঠিক আছে',
      'cancel': 'বাতিল',
      'save': 'সংরক্ষণ',
      'delete': 'মুছে ফেলুন',
      'edit': 'সম্পাদনা',
      'add': 'যোগ করুন',
      'search': 'অনুসন্ধান',
      'loading': 'লোড হচ্ছে...',
      'error': 'ত্রুটি',
      'noData': 'কোন তথ্য নেই',
      'retry': 'পুনরায় চেষ্টা করুন',

      // Navigation
      'navHome': 'হোম',
      'navTransactions': 'লেনদেন',
      'navAnalytics': 'বিশ্লেষণ',
      'navLoans': 'ঋণ',
      'navSettings': 'সেটিংস',

      // Dashboard
      'dashboardTitle': 'ড্যাশবোর্ড',
      'totalBalance': 'মোট ব্যালেন্স',
      'totalIncome': 'মোট আয়',
      'totalExpense': 'মোট ব্যয়',
      'netBalance': 'নিট ব্যালেন্স',
      'wallets': 'ওয়ালেট',
      'recentTransactions': 'সাম্প্রতিক লেনদেন',
      'addTransaction': 'লেনদেন যোগ করুন',
      'addWallet': 'ওয়ালেট যোগ করুন',
      'outstandingLoan': 'বকেয়া ঋণ',
      'outstandingDebt': 'বকেয়া ঋণ',

      // Transaction
      'transactionType': 'লেনদেনের ধরন',
      'income': 'আয়',
      'expense': 'ব্যয়',
      'transfer': 'স্থানান্তর',
      'amount': 'পরিমাণ',
      'category': 'বিভাগ',
      'fromWallet': 'ওয়ালেট থেকে',
      'toWallet': 'ওয়ালেটে',
      'date': 'তারিখ',
      'note': 'নোট',
      'noteOptional': 'নোট (ঐচ্ছিক)',
      'selectCategory': 'বিভাগ নির্বাচন করুন',
      'selectWallet': 'ওয়ালেট নির্বাচন করুন',

      // Wallet
      'walletName': 'ওয়ালেটের নাম',
      'walletType': 'ওয়ালেটের ধরন',
      'walletTypeCash': 'নগদ',
      'walletTypeBkash': 'বিকাশ',
      'walletTypeNagad': 'নগদ',
      'walletTypeBank': 'ব্যাংক',
      'walletTypeOther': 'অন্যান্য',
      'initialBalance': 'প্রাথমিক ব্যালেন্স',
      'addWalletTitle': 'ওয়ালেট যোগ করুন',
      'editWalletTitle': 'ওয়ালেট সম্পাদনা করুন',
      'deleteWalletConfirm': 'আপনি কি নিশ্চিত যে আপনি এই ওয়ালেটটি মুছে ফেলতে চান?',
      'deleteWalletSuccess': 'ওয়ালেট সফলভাবে মুছে ফেলা হয়েছে',
      'deleteWalletErrorBalance': 'ব্যালেন্স সহ ওয়ালেট মুছে ফেলা যাবে না',
      'deleteWalletErrorDependents': 'লেনদেন বা সক্রিয় ঋণের সাথে যুক্ত ওয়ালেট মুছে ফেলা যাবে না',
      'noWallets': 'কোন ওয়ালেট পাওয়া যায়নি',
      'noWalletsSubtitle': 'আপনার প্রথম নগদ, বিকাশ বা ব্যাংক ওয়ালেট যোগ করুন',
      'noTransactions': 'এখনও কোন লেনদেন নেই',
      'noTransactionsSubtitle': 'শুরু করতে আপনার প্রথম আয় বা ব্যয় যোগ করুন',

      // Category
      'categoryFood': 'খাবার',
      'categoryTransport': 'যাতায়াত',
      'categoryRent': 'ভাড়া',
      'categoryBill': 'বিল',
      'categoryShopping': 'শপিং',
      'categoryHealth': 'স্বাস্থ্য',
      'categoryOthers': 'অন্যান্য',

      // Loan
      'loans': 'ঋণ',
      'loanGiven': 'দেওয়া ঋণ',
      'loanTaken': 'নেওয়া ঋণ',
      'personName': 'ব্যক্তির নাম',
      'principalAmount': 'মূল পরিমাণ',
      'outstandingAmount': 'বকেয়া পরিমাণ',
      'interestRate': 'সুদের হার',
      'startDate': 'শুরুর তারিখ',
      'dueDate': 'শেষ তারিখ',
      'dueDateOptional': 'শেষ তারিখ (ঐচ্ছিক)',
      'addLoanTitle': '{type} যোগ করুন',
      'repay': 'পরিশোধ',
      'settle': 'নিষ্পত্তি',
      'repaymentAmount': 'পরিশোধের পরিমাণ',
      'activeLoans': 'সক্রিয় ঋণ',
      'closedLoans': 'বন্ধ ঋণ',

      // Recurring Bill
      'recurringBills': 'পুনরাবৃত্তি বিল',
      'addBill': 'বিল যোগ করুন',
      'billName': 'বিলের নাম',
      'frequency': 'ফ্রিকোয়েন্সি',
      'frequencyWeekly': 'সাপ্তাহিক',
      'frequencyMonthly': 'মাসিক',
      'nextDueDate': 'পরবর্তী শেষ তারিখ',
      'markAsPaid': 'পরিশোধিত হিসেবে চিহ্নিত করুন',
      'overdue': 'বকেয়া',
      'dueInDays': '{days} দিনের মধ্যে শেষ',
      'dueToday': 'আজ শেষ',

      // Analytics
      'analyticsTitle': 'বিশ্লেষণ',
      'monthlySummary': 'মাসিক সারাংশ',
      'categoryWiseExpense': 'বিভাগ অনুযায়ী ব্যয়',
      'topCategories': 'শীর্ষ বিভাগ',
      'loanSnapshot': 'ঋণের সারাংশ',
      'monthlyRepayment': 'মাসিক পরিশোধ',

      // Settings
      'settingsTitle': 'সেটিংস',
      'language': 'ভাষা',
      'theme': 'থিম',
      'lightMode': 'হালকা',
      'darkMode': 'অন্ধকার',
      'systemMode': 'সিস্টেম',
      'security': 'নিরাপত্তা',
      'pinLock': 'PIN লক',
      'biometricLock': 'বায়োমেট্রিক লক',
      'about': 'সম্পর্কে',
      'version': 'সংস্করণ',
      'signOut': 'সাইন আউট',

      // Currency
      'currencySymbol': '৳',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
