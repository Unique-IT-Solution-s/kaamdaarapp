
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../routes/app_routes.dart';
import '../services/auth_api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color splashColor = Color(0xFF33469A);

  static const Duration maxLoadingTime = Duration(seconds: 5);
  static const Duration minSplashTime = Duration(seconds: 2);

  bool _checking = true;
  bool _hasError = false;
  String _errorMessage = '';

  int _checkId = 0;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // ==========================================
  // CHECK LOGIN SESSION
  // ==========================================

  Future<void> _checkSession() async {
    if (!mounted) return;

    final currentCheckId = ++_checkId;
    final stopwatch = Stopwatch()..start();

    setState(() {
      _checking = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final decision = await _resolveSession().timeout(
        maxLoadingTime,
      );

      // Logo minimum 2 seconds visible rahega.
      final remainingTime =
          minSplashTime - stopwatch.elapsed;

      if (remainingTime > Duration.zero) {
        await Future.delayed(remainingTime);
      }

      if (!mounted || currentCheckId != _checkId) return;

      // Sirf confirmed invalid session par token clear hoga.
      if (decision.clearSession) {
        await AuthApiService.clearSession();
      }

      if (!mounted || currentCheckId != _checkId) return;

      _goTo(
        decision.route,
        arguments: decision.arguments,
      );
    } on TimeoutException {
      if (!mounted || currentCheckId != _checkId) return;

      debugPrint('SPLASH: SESSION CHECK TIMEOUT');

      _showRetryError(
        'Connection is taking too long. Please retry.',
      );
    } catch (e) {
      if (!mounted || currentCheckId != _checkId) return;

      debugPrint('SPLASH SESSION ERROR: $e');

      final error = e.toString().toLowerCase();

      if (_isAuthenticationError(error)) {
        await AuthApiService.clearSession();

        if (!mounted || currentCheckId != _checkId) return;

        _goTo(AppRoutes.onboarding);
        return;
      }

      // Network/server problem: token safe rahega.
      _showRetryError(
        'Internet or server connection problem. Please retry.',
      );
    }
  }

  // ==========================================
  // RESOLVE SESSION DESTINATION
  // ==========================================

  Future<_SplashDecision> _resolveSession() async {
    // STEP 1: CHECK SAVED TOKEN

    final token = await AuthApiService.getAccessToken();

    if (token == null || token.isEmpty) {
      debugPrint('SPLASH: NO SAVED TOKEN');

      return _SplashDecision(
        route: AppRoutes.onboarding,
      );
    }

    debugPrint('SPLASH: SAVED TOKEN FOUND');

    // STEP 2: VERIFY TOKEN WITH BACKEND

    final result = await AuthApiService.getMe();

    final isSuccess =
        result['success'] == true ||
        result['status'] == true;

    if (!isSuccess) {
      final message =
          result['message']?.toString().toLowerCase() ?? '';

      if (_isAuthenticationError(message)) {
        return _SplashDecision(
          route: AppRoutes.onboarding,
          clearSession: true,
        );
      }

      throw Exception('Unable to verify session');
    }

    // STEP 3: GET USER DATA

    final data = result['data'];

    final user = data is Map
        ? (data['user'] is Map ? data['user'] : data)
        : null;

    if (user is! Map) {
      throw Exception('User information not found');
    }

    debugPrint('SPLASH: USER SESSION VERIFIED');

    // STEP 4: CHECK PROFILE COMPLETION

    final profileCompleted =
        user['profile_completed'] == true;

    if (!profileCompleted) {
      return _SplashDecision(
        route: AppRoutes.location,
        arguments: {'isNewUser': true},
      );
    }

    // STEP 5: CHECK LOCATION PERMISSION

    bool permissionGranted = false;
    bool gpsEnabled = false;

    try {
      final permission =
          await Geolocator.checkPermission();

      permissionGranted =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      gpsEnabled =
          await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('LOCATION CHECK ERROR: $e');
    }

    if (permissionGranted && gpsEnabled) {
      debugPrint('SPLASH: OPENING HOME');

      return _SplashDecision(
        route: AppRoutes.home,
      );
    }

    debugPrint('SPLASH: LOCATION REQUIRED');

    return _SplashDecision(
      route: AppRoutes.location,
      arguments: {'isNewUser': false},
    );
  }

  // ==========================================
  // AUTHENTICATION ERROR CHECK
  // ==========================================

  bool _isAuthenticationError(String message) {
    return message.contains('401') ||
        message.contains('403') ||
        message.contains('unauthorized') ||
        message.contains('token expired') ||
        message.contains('invalid token') ||
        message.contains('jwt expired') ||
        message.contains('login session expired');
  }

  // ==========================================
  // RETRY ERROR
  // ==========================================

  void _showRetryError(String message) {
    if (!mounted) return;

    setState(() {
      _checking = false;
      _hasError = true;
      _errorMessage = message;
    });
  }

  // ==========================================
  // NAVIGATION
  // ==========================================

  void _goTo(
    String route, {
    Object? arguments,
  }) {
    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  @override
  void dispose() {
    _checkId++;
    super.dispose();
  }

  // ==========================================
  // SPLASH UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashColor,
      body: SizedBox.expand(
        child: ColoredBox(
          color: splashColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // KAAMDAAR LOGO

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Image.asset(
                  'assets/images/kaamdar_splash.png',
                  width:
                      MediaQuery.sizeOf(context).width * 0.88,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint(
                      'Splash logo loading error: $error',
                    );

                    return const Text(
                      'KaamDaar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // LOADING ANIMATION UNDER LOGO

              if (_checking)
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),

              // ERROR ONLY WHEN CONNECTION FAILS

              if (_hasError)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    25,
                    10,
                    25,
                    0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      FilledButton(
                        onPressed: _checkSession,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: splashColor,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SPLASH NAVIGATION DECISION
// ==========================================

class _SplashDecision {
  final String route;
  final Object? arguments;
  final bool clearSession;

  const _SplashDecision({
    required this.route,
    this.arguments,
    this.clearSession = false,
  });
}
