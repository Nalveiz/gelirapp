import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      themeMode: ThemeMode.dark, // Her zaman karanlık modda
      darkTheme: AppTheme.theme,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: Lottie.asset('assets/cash.json'),
      splashIconSize: 350,
      nextScreen: const LoginScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Color(0xFF242424),
    );
  }
}
