import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'features/dashboard/presentation/pages/dashboard_page.dart';
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
    return MaterialApp(
      title: 'Finlisty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DashboardPage(), // Direct to Dashboard for demo
    );
  }
}
