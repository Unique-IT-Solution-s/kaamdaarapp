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
  static const int otpLength = 4;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  bool get _isComplete => _otpController.text.length == otpLength;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_refresh);
    _otpFocus.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _otpController.removeListener(_refresh);
    _otpFocus.removeListener(_refresh);
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _focusOtp() {
    if (!_otpFocus.hasFocus) {
      _otpFocus.requestFocus();
    }
  }

  void _verify() {
    if (!_isComplete) {
      _focusOtp();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit OTP.')),
      );
      return;
    }

    // Demo navigation only. Connect Firebase phone verification here.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.location,
      (route) => false,
    );
  }

  Widget _otpBoxes() {
    return SizedBox(
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Visual OTP boxes.
          Row(
            children: List.generate(otpLength, (index) {
              final value = _otpController.text;
              final hasDigit = index < value.length;
              final activeIndex = value.length.clamp(0, otpLength - 1);
              final isActive = _otpFocus.hasFocus && index == activeIndex;

              return Expanded(
                child: Container(
                  height: 54,
                  margin: EdgeInsets.only(
                    right: index == otpLength - 1 ? 0 : 12,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive ? blue : Colors.transparent,
                      width: 1.6,
                    ),
                  ),
                  child: Text(
                    hasDigit ? value[index] : '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),

          // This full-size transparent field receives taps and opens
          // the numeric keyboard; the custom boxes remain visible below it.
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
              autofillHints: const [AutofillHints.oneTimeCode],
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
              onSubmitted: (_) => _verify(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final compact = height < 650;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: height * (compact ? 0.035 : 0.065)),

                      Text(
                        'Verify your OTP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blue,
                          fontSize: compact ? 22 : 26,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: height * 0.018),

                      Text(
                        'We have sent a $otpLength-digit code to\n+91 ${widget.phone}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF756D7A),
                          fontSize: compact ? 13 : 16,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: height * 0.028),

                      _otpBoxes(),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.018,
                            horizontal: 8,
                          ),
                          child: Image.asset(
                            'assets/images/otp_screen.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('OTP illustration error: $error');
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isComplete ? _verify : _focusOtp,
                          style: FilledButton.styleFrom(
                            backgroundColor: lightBlue,
                            foregroundColor: blue,
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

                      SizedBox(height: height * (compact ? 0.02 : 0.035)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
