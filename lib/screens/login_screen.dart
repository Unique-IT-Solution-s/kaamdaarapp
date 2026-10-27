
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);

  final TextEditingController _phone = TextEditingController();

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

  void _continue() {
    final phone = _phone.text.trim();

    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid 10-digit mobile number.'),
        ),
      );
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.otp,
      arguments: phone,
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
            final screenHeight = constraints.maxHeight;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: screenHeight * 0.055),

                      // Kaamdar logo
                      Center(
                        child: Image.asset(
                          'assets/images/kaamdar_primarylogo.png',
                          height: screenHeight * 0.13,
                          width: 190,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Login heading
                      const Text(
                        'Log in or Sign up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.035),

                      // Mobile number field
                      TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSubmitted: (_) => _continue(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Enter your Mobile Number',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(
                              left: 18,
                              right: 14,
                            ),
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Fixed Continue button
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _continue,
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

                      SizedBox(height: screenHeight * 0.035),
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
