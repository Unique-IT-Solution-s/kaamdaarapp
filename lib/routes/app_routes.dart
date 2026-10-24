
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/create_account_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const createAccount = '/create-account';
  static const login = '/login';
  static const home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    createAccount: (_) => const CreateAccountScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(),
  };
}
