import 'dart:async';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
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
      backgroundColor: KaamdarColors.navy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            final h = box.maxHeight;
            return Stack(
              children: [
                Positioned(
                  top: h * .075,
                  left: w * .10,
                  right: w * .10,
                  height: h * .15,
                  child: Image.asset(
                    'assets/images/kaamdar_splash.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text('Kaamdar', style: TextStyle(
                        color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                ),
                Positioned(
                  top: h * .335,
                  left: 0,
                  right: 0,
                  child: Text(
                    'All Your Home Services\nIn our App',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: w * .047, height: 1.25),
                  ),
                ),
                Positioned(
                  top: h * .505,
                  left: 0,
                  right: 0,
                  child: const Center(child: SizedBox(
                    width: 27, height: 27,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )),
                ),
                Positioned(
                  left: w * .025,
                  right: w * .025,
                  bottom: h * .02,
                  height: h * .40,
                  child: Image.asset(
                    'assets/images/kaamdar_workers.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
