
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({
    super.key,
    required this.phone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);
  static const int _otpLength = 4;

  final TextEditingController _otp = TextEditingController();
  final FocusNode _focus = FocusNode();

  bool get _isComplete => _otp.text.length == _otpLength;

  @override
  void initState() {
    super.initState();
    _otp.addListener(_onOtpChanged);
    _focus.addListener(_onFocusChanged);
  }

  void _onOtpChanged() {
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _otp.removeListener(_onOtpChanged);
    _focus.removeListener(_onFocusChanged);
    _otp.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _verify() {
    if (!_isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit OTP.'),
        ),
      );
      return;
    }

    // Navigation test: Firebase OTP verification abhi connect nahi hai.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.location,
      (route) => false,
    );
  }

  Widget _box(int index) {
    final text = _otp.text;
    final hasDigit = index < text.length;
    final isActive = _focus.hasFocus && index == text.length;

    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? blue : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Text(
        hasDigit ? text[index] : '',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: h * 0.12),

                  const Text(
                    'Verify your OTP',
                    style: TextStyle(
                      color: blue,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'We have sent a $_otpLength-digit code to +91 ${widget.phone}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF756D7A),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => _focus.requestFocus(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _otpLength,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: _box(i),
                            ),
                          ),
                        ),

                        Opacity(
                          opacity: 0,
                          child: SizedBox(
                            width: 1,
                            height: 1,
                            child: TextField(
                              controller: _otp,
                              focusNode: _focus,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              maxLength: _otpLength,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _verify(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _isComplete ? _verify : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: lightBlue,
                        foregroundColor: blue,
                        disabledBackgroundColor:
                            lightBlue.withOpacity(0.6),
                        disabledForegroundColor:
                            blue.withOpacity(0.5),
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.035),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
