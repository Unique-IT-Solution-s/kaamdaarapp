
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';
import '../widgets/provider_bottom_nav.dart';

class GetOtpScreen extends StatefulWidget {
  const GetOtpScreen({super.key});

  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> {
  static const Color primaryGreen = Color(0xFF16A376);
  static const Color backgroundColor = Color(0xFFF1FAF6);

  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> otpFocusNodes =
      List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  String get enteredOtp =>
      otpControllers.map((controller) => controller.text).join();

  void verifyOtp() {
    if (enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit OTP'),
        ),
      );
      return;
    }

    // Actual customer OTP verification will be connected later.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP verification will be connected with backend.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              height: 51,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: primaryGreen,
                      size: 19,
                    ),
                  ),

                  const Text(
                    'Get OTP',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),

            // OTP CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    const Text(
                      'You have Arrived',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'To Start the job, please enter the OTP\n'
                      'from the Customer.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Color(0xFF444444),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // FOUR DIGIT OTP INPUT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 43,
                          height: 43,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 7,
                          ),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: TextField(
                            controller: otpControllers[index],
                            focusNode: otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                otpFocusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                otpFocusNodes[index - 1].requestFocus();
                              }

                              if (index == 3 && value.isNotEmpty) {
                                otpFocusNodes[index].unfocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 38),

                    // VERIFY BUTTON
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
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Verify and Start Job',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // COMMON BOTTOM NAVIGATION
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.popUntil(
              context,
              ModalRoute.withName(AppRoutes.bookings),
            );
          }
        },
      ),
    );
  }
}
