
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/create_account_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/location_screen.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const createAccount = '/create-account';
  static const login = '/login';
  static const otp = '/otp';
  static const location = '/location';
  static const home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        createAccount: (_) => const LoginScreen(),
        login: (_) => const LoginScreen(),

        otp: (context) {
          final phone =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';

          return OtpScreen(phone: phone);
        },

        location: (_) => const LocationScreen(),
        home: (_) => const HomeScreen(),
      };
}
