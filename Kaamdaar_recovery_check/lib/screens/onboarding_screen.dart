
import 'package:flutter/material.dart';
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
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Onboarding1Screen(
          currentPage: _currentPage,
          onBack: _currentPage == 0 ? null : _back,
          onNext: _next,
          onSkip: _finish,
        ),
      ),
    );
  }
}
