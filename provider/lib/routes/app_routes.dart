
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/language_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/home_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/job_details_screen.dart';
import '../screens/get_otp_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String bookings = '/bookings';
  static const String jobDetails = '/job-details';
  static const String getOtp = '/get-otp';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case language:
        return MaterialPageRoute(
          builder: (_) => const LanguageScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case otp:
        final mobileNumber = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            mobileNumber: mobileNumber,
          ),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case bookings:
        return MaterialPageRoute(
          builder: (_) => const BookingsScreen(),
        );
        case jobDetails:
  return MaterialPageRoute(
    builder: (_) => const JobDetailsScreen(),
  );
  case getOtp:
  return MaterialPageRoute(
    builder: (_) => const GetOtpScreen(),
  );
  case profile:
  return MaterialPageRoute(
    builder: (_) => const ProfileScreen(),
  );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
        );
    }
  }
}
