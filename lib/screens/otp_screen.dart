
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_api_service.dart';

import '../routes/app_routes.dart';


class OtpScreen extends StatefulWidget {
  final String phone;
  final String sessionInfo;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.sessionInfo,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}


class _OtpScreenState extends State<OtpScreen> {
  // KAAMDAAR BRAND COLORS
  static const Color navy = Color(0xFF0B1F3A);
  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);
  static const Color orange = Color(0xFFFF7A00);

  static const int otpLength = 6;

  final TextEditingController _otpController =
      TextEditingController();

  final FocusNode _otpFocus = FocusNode();

  bool _isVerifying = false;

  bool get _isComplete =>
      _otpController.text.length == otpLength;

  @override
  void initState() {
    super.initState();

    _otpController.addListener(_refresh);
    _otpFocus.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _otpController.removeListener(_refresh);
    _otpFocus.removeListener(_refresh);

    _otpController.dispose();
    _otpFocus.dispose();

    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _focusOtp() {
    if (!_otpFocus.hasFocus) {
      _otpFocus.requestFocus();
    }
  }

  // ==========================================
  // FIREBASE OTP VERIFICATION
  // ==========================================

  
Future<void> _verify() async {
  if (_isVerifying) return;

  if (!_isComplete) {
    _focusOtp();
    _showMessage('Please enter the complete 6-digit OTP.');
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() => _isVerifying = true);

  try {
    final result = await AuthApiService.verifyOtp(
      phone: '+91${widget.phone}',
      sessionInfo: widget.sessionInfo,
      code: _otpController.text.trim(),
    );

    if (result['status'] != true) {
      throw Exception(
        result['message'] ?? 'OTP verification failed.',
      );
    }

    final data = result['data'];

    if (data is! Map) {
      throw Exception('Invalid login data received.');
    }

    final nextStep = data['next_step']?.toString() ?? '';
    final user = data['user'];

    if (user is! Map) {
      throw Exception('User information missing.');
    }

    // Successful login
    if (!mounted) return;

    if (nextStep == 'HOME') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.location,
        (route) => false,
      );
    }
  } catch (e) {
    debugPrint('OTP verification error: $e');

    _showMessage(
      e.toString().replaceFirst('Exception: ', ''),
    );
  } finally {
    if (mounted) {
      setState(() => _isVerifying = false);
    }
  }
}


  // ==========================================
  // TOP BACK BUTTON
  // ==========================================

  Widget _backButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: navy,
          size: 23,
        ),
      ),
    );
  }

  // ==========================================
  // SHIELD ICON
  // ==========================================

  Widget _securityIcon(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEAF4FF),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.13),
            blurRadius: 25,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.verified_user_rounded,
        color: Color(0xFF087BE5),
        size: 90,
      ),
    );
  }

  // ==========================================
  // OTP HEADING
  // ==========================================

  Widget _heading(bool compact) {
    return Column(
      children: [
        _securityIcon(compact ? 64 : 76),

        SizedBox(height: compact ? 13 : 20),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: compact ? 25 : 32,
              fontWeight: FontWeight.w800,
              color: navy,
              height: 1.2,
            ),
            children: const [
              TextSpan(text: 'Verify your '),
              TextSpan(
                text: 'OTP',
                style: TextStyle(
                  color: Color(0xFF0759D5),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // BLUE + ORANGE UNDERLINE

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 7,
              width: 75,
              decoration: const BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
            ),
            Container(
              height: 7,
              width: 50,
              decoration: const BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // PHONE NUMBER TEXT
  // ==========================================

  Widget _phoneText(bool compact) {
    return Column(
      children: [
        Text(
          'We have sent a 6-digit code to',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF5F6071),
            fontSize: compact ? 15 : 18,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          '+91 ${widget.phone}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF0759D5),
            fontSize: compact ? 20 : 25,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SIX OTP BOXES
  // ==========================================

  Widget _otpBoxes() {
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: List.generate(otpLength, (index) {
              final value = _otpController.text;

              final hasDigit = index < value.length;

              final activeIndex =
                  value.length.clamp(0, otpLength - 1);

              final isActive =
                  _otpFocus.hasFocus &&
                  index == activeIndex;

              return Expanded(
                child: Container(
                  height: 58,
                  margin: EdgeInsets.only(
                    right: index == otpLength - 1 ? 0 : 8,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3FC),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isActive
                          ? blue
                          : const Color(0xFFB7D7F4),
                      width: isActive ? 2 : 1.5,
                    ),
                  ),
                  child: Text(
                    hasDigit ? value[index] : '',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                ),
              );
            }),
          ),

          // HIDDEN TEXT FIELD FOR OTP INPUT

          Positioned.fill(
            child: TextField(
              controller: _otpController,
              focusNode: _otpFocus,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              maxLength: otpLength,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(otpLength),
              ],
              autofillHints: const [
                AutofillHints.oneTimeCode,
              ],
              style: const TextStyle(
                color: Colors.transparent,
                fontSize: 1,
              ),
              cursorColor: Colors.transparent,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
              onSubmitted: (_) {
                if (_isComplete) {
                  _verify();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // OTP ILLUSTRATION
  // ==========================================

  Widget _otpIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // SOFT BLUE BACKGROUND CIRCLE

        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEAF5FF),
          ),
        ),

        // MAIN OTP PHONE IMAGE

        Image.asset(
          'assets/images/otp_screen.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('OTP image error: $error');

            return const Icon(
              Icons.phone_android_rounded,
              size: 120,
              color: blue,
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // CONTINUE BUTTON
  // ==========================================

  Widget _continueButton() {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: FilledButton(
        onPressed: (_isVerifying || !_isComplete)
            ? null
            : _verify,

        style: FilledButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,

          disabledBackgroundColor: lightBlue,
          disabledForegroundColor:
              blue.withValues(alpha: 0.55),

          elevation: 0,

          shape: const StadiumBorder(),
        ),

        child: _isVerifying
            ? const SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: blue,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(width: 15),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 25,
                  ),
                ],
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
          // TOP RIGHT SOFT BLUE DECORATION

          Positioned(
            top: -75,
            right: -85,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // BOTTOM LEFT SOFT BLUE DECORATION

          Positioned(
            bottom: -100,
            left: -110,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;

                final compact = height < 700;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 480,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),

                      child: Column(
                        children: [
                          // BACK BUTTON

                          _backButton(),

                          SizedBox(
                            height: compact ? 5 : height * 0.025,
                          ),

                          // HEADING

                          _heading(compact),

                          SizedBox(
                            height: compact ? 15 : height * 0.025,
                          ),

                          // PHONE NUMBER

                          _phoneText(compact),

                          SizedBox(
                            height: compact ? 20 : height * 0.035,
                          ),

                          // OTP INPUT BOXES

                          _otpBoxes(),

                          // ILLUSTRATION AREA

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: compact ? 8 : 20,
                                horizontal: 12,
                              ),
                              child: _otpIllustration(),
                            ),
                          ),

                          // CONTINUE BUTTON

                          _continueButton(),

                          SizedBox(
                            height: compact ? 12 : 25,
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
