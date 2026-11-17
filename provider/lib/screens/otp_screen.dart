
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const Color primaryGreen = Color(0xFF16A376);

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  Timer? countdownTimer;

  int remainingSeconds = 144;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {});
        }
      },
    );
  }

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (remainingSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void resendOtp() {
    if (remainingSeconds > 0) return;

    otpController.clear();

    setState(() {
      remainingSeconds = 144;
    });

    startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resend functionality will be connected later.'),
      ),
    );
  }
void verifyOtp() {
  if (otpController.text.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter complete 6-digit OTP'),
      ),
    );
    return;
  }

  Navigator.pushReplacementNamed(
    context,
    AppRoutes.home,
  );
}
  

  @override
  void dispose() {
    countdownTimer?.cancel();
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FAF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 95,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: primaryGreen,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF303030),
                    ),
                  ),
                ],
              ),
            ),

            // OTP Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    Text(
                      'We have send a 6-digit code to\n'
                      '+91 ${widget.mobileNumber}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.6,
                        color: Color(0xFF77717D),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // OTP Boxes
                    GestureDetector(
                      onTap: () {
                        otpFocusNode.requestFocus();
                      },
                      child: SizedBox(
                        height: 46,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                final digits = otpController.text;
                                final digit = index < digits.length
                                    ? digits[index]
                                    : '';

                                return Container(
                                  width: 38,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: primaryGreen,
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    digit,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            // Invisible input field
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0,
                                child: TextField(
                                  controller: otpController,
                                  focusNode: otpFocusNode,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  showCursor: false,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Resend Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (remainingSeconds > 0) ...[
                          const Text(
                            'Resend OTP in ',
                            style: TextStyle(
                              color: Color(0xFF77717D),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Color(0xFF77717D),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else
                          TextButton(
                            onPressed: resendOtp,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
