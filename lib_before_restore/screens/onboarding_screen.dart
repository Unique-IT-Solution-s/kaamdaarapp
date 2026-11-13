
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'onboarding1_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  void _next() {
    if (_currentPage < 2) {
      setState(() => _currentPage++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  void _finish() {
    // push (replace nahi) taaki login se back karne par onboarding wapas aaye
    Navigator.of(context).pushNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    // System back button: pehle previous onboarding page par jao,
    // sirf page 0 par app se bahar nikalne do.
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Onboarding1Screen(
            currentPage: _currentPage,
            onBack: _currentPage == 0 ? null : _back,
            onNext: _next,
            onSkip: _finish,
          ),
        ),
      ),
    );
  }
}
