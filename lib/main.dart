import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'core/languages/app_localizations.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/theme_provider.dart';
import 'injection_container.dart' as di;
import 'main_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Auto sign-in anonymously for demo/testing
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    await auth.signInAnonymously();
    debugPrint('Signed in anonymously as: ${auth.currentUser?.uid}');
  }
  
  await di.init();

  runApp(const FinlistyApp());
}

class FinlistyApp extends StatelessWidget {
  const FinlistyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Finlisty',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: Locale(languageProvider.languageCode),
            localizationsDelegates: [
              AppLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('bn'),
            ],
            home: const MainWrapper(),
          );
        },
      ),
    );
  }
}
