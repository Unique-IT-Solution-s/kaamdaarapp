
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  static const Color splashColor = Color(0xFF33469A);

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Check whether the user is already logged in.
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.onboarding,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashColor,
      body: SizedBox.expand(
        child: ColoredBox(
          color: splashColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Image.asset(
                'assets/images/kaamdar_splash.png',
                width: MediaQuery.sizeOf(context).width * 0.88,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Splash logo loading error: $error');

                  return const Text(
                    'KaamDaar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
