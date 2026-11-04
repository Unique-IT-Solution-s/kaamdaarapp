
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_api_service.dart';

import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ==========================================
  // KAAMDAAR BRAND COLORS
  // ==========================================

  static const Color navy = Color(0xFF0B1F3A);
  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);
  static const Color orange = Color(0xFFFF7A00);

  final TextEditingController _phone = TextEditingController();

  bool _isLoading = false;

  // ==========================================
  // INITIALIZATION
  // ==========================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arg = ModalRoute.of(context)?.settings.arguments;

    if (arg is String && _phone.text.isEmpty) {
      _phone.text = arg;
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  // ==========================================
  // SNACKBAR
  // ==========================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================
  // FIREBASE PHONE AUTHENTICATION
  // =========================================
  
Future<void> _continue() async {
  if (_isLoading) return;

  final phone = _phone.text.trim();

  if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone)) {
    _showMessage('Enter a valid 10-digit mobile number.');
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() => _isLoading = true);

  try {
    final result = await AuthApiService.requestOtp(
      phone: '+91$phone',
    );

    if (result['status'] != true) {
      throw Exception(
        result['message'] ?? 'Could not send OTP.',
      );
    }

    final sessionInfo = result['sessionInfo']?.toString() ?? '';

    if (sessionInfo.isEmpty) {
      throw Exception('Session information missing from server.');
    }

    if (!mounted) return;

    Navigator.of(context).pushNamed(
      AppRoutes.otp,
      arguments: {
        'phone': phone,
        'sessionInfo': sessionInfo,
      },
    );
  } catch (e) {
    debugPrint('OTP request error: $e');

    _showMessage(
      e.toString().replaceFirst('Exception: ', ''),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}


    

  // ==========================================
  // KAAMDAAR LOGO
  // ==========================================

  Widget _logo(double height) {
    return Center(
      child: Image.asset(
        'assets/images/kaamdar_primarylogo.png',
        height: height,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('KaamDaar logo error: $error');
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ==========================================
  // LOGIN HEADING
  // ==========================================

  Widget _heading(bool compact) {
    return Column(
      children: [
        Text(
          'Log in or Sign up',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blue,
            fontSize: compact ? 25 : 32,
            height: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: compact ? 9 : 13),

        Text(
          'Welcome!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF777777),
            fontSize: compact ? 15 : 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // MOBILE NUMBER TEXT FIELD
  // ==========================================

  Widget _phoneField() {
    return SizedBox(
      height: 66,
      child: TextField(
        controller: _phone,

        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,

        maxLength: 10,
        enabled: !_isLoading,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],

        onSubmitted: (_) => _continue(),

        style: const TextStyle(
          fontSize: 17,
          color: navy,
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          counterText: '',

          hintText: 'Enter your Mobile Number',

          hintStyle: const TextStyle(
            color: Color(0xFF858585),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),

          // COUNTRY CODE + DIVIDER

          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: 82,
          ),

          prefixIcon: SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Row(
                children: [
                  const Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 17),

                  Container(
                    height: 32,
                    width: 1.4,
                    color: const Color(0xFFBDBDBD),
                  ),

                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 18,
          ),

          filled: true,
          fillColor: Colors.white,

          // NORMAL BORDER

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: blue,
              width: 1.8,
            ),
          ),

          // FOCUSED BORDER

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: blue,
              width: 2.2,
            ),
          ),

          // DISABLED BORDER

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: lightBlue,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // HOME ILLUSTRATION WITH BLUE BACKGROUND
  // ==========================================

  Widget _loginIllustration() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final circleSize = width < height * 0.95
            ? width * 0.92
            : height * 0.78;

        return Stack(
          alignment: Alignment.center,
          children: [
            // SOFT BLUE CIRCLE BEHIND HOUSE

            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD1E9FF),
                    Color(0xFFEAF5FF),
                    Color(0xFFF8FCFF),
                  ],
                ),
              ),
            ),

            // MAIN TRANSPARENT ILLUSTRATION

            Image.asset(
              'assets/images/kaamdaar_loginscreen.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              alignment: Alignment.center,

              errorBuilder: (context, error, stackTrace) {
                debugPrint('Login illustration error: $error');

                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // CONTINUE BUTTON
  // ==========================================

  Widget _continueButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: FilledButton(
        onPressed: _isLoading ? null : _continue,

        style: FilledButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,

          disabledBackgroundColor: blue,
          disabledForegroundColor: Colors.white,

          elevation: 0,

          shape: const StadiumBorder(),
        ),

        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ==========================================
  // MAIN SCREEN
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          // BACKGROUND WAVES

          Positioned.fill(
            child: CustomPaint(
              painter: LoginBackgroundPainter(),
            ),
          ),

          // MAIN CONTENT

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight;

                final isCompact = h < 650;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 480,
                    ),

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: h < 500 ? 20 : 24,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,

                        children: [
                          // TOP SPACING

                          SizedBox(
                            height: h * (
                              isCompact ? 0.02 : 0.035
                            ),
                          ),

                          // LOGO

                          _logo(
                            h * (
                              isCompact ? 0.12 : 0.145
                            ),
                          ),

                          SizedBox(
                            height: h * (
                              isCompact ? 0.018 : 0.025
                            ),
                          ),

                          // HEADING

                          _heading(isCompact),

                          SizedBox(
                            height: h * (
                              isCompact ? 0.025 : 0.04
                            ),
                          ),

                          // PHONE FIELD

                          _phoneField(),

                          // HOUSE + TOOLBOX IMAGE

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: h * 0.015,
                                horizontal: 0,
                              ),
                              child: _loginIllustration(),
                            ),
                          ),

                          // CONTINUE BUTTON

                          _continueButton(),

                          SizedBox(
                            height: h * (
                              isCompact ? 0.02 : 0.035
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================
// CUSTOM BACKGROUND WAVES
// ==============================================

class LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // ==========================================
    // TOP RIGHT BLUE CURVE
    // ==========================================

    final topPath = Path()
      ..moveTo(size.width * 0.84, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.22)
      ..cubicTo(
        size.width * 0.90,
        size.height * 0.20,
        size.width * 0.87,
        size.height * 0.09,
        size.width * 0.84,
        0,
      )
      ..close();

    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB9DEFF),
          Color(0xFFEAF5FF),
          Colors.white,
        ],
      ).createShader(
        Rect.fromLTWH(
          size.width * 0.80,
          0,
          size.width * 0.20,
          size.height * 0.23,
        ),
      );

    canvas.drawPath(topPath, topPaint);

    // ==========================================
    // BOTTOM LEFT BLUE WAVE
    // ==========================================

    final bottomPath = Path()
      ..moveTo(0, size.height * 0.80)
      ..cubicTo(
        size.width * 0.17,
        size.height * 0.78,
        size.width * 0.24,
        size.height * 0.85,
        size.width * 0.40,
        size.height * 0.87,
      )
      ..cubicTo(
        size.width * 0.51,
        size.height * 0.89,
        size.width * 0.54,
        size.height * 0.92,
        size.width * 0.66,
        size.height * 0.93,
      )
      ..lineTo(size.width * 0.66, size.height)
      ..lineTo(0, size.height)
      ..close();

    final bottomPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFD9EDFF),
          Color(0xFFEAF5FF),
          Colors.white,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          size.height * 0.78,
          size.width * 0.70,
          size.height * 0.22,
        ),
      );

    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(
    covariant LoginBackgroundPainter oldDelegate,
  ) {
    return false;
  }
}
