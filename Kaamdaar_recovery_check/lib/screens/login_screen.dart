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
            final h = constraints.maxHeight;
            final isCompact = h < 650;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: h < 500 ? 20 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: h * (isCompact ? 0.025 : 0.045)),

                      // Large centered KaamDaar logo, matching the reference.
                      Center(
                        child: Image.asset(
                          'assets/images/kaamdar_primarylogo.png',
                          height: h * (isCompact ? 0.105 : 0.145),
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('KaamDaar logo error: $error');
                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                      SizedBox(height: h * (isCompact ? 0.018 : 0.026)),

                      const Text(
                        'Log in or Sign up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blue,
                          fontSize: 22,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: h * 0.012),

                      const Text(
                        'Welcome!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8A8490),
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: h * (isCompact ? 0.018 : 0.028)),

                      // +91 mobile number field.
                      SizedBox(
                        height: 48,
                        child: TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onSubmitted: (_) => _continue(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Enter your Mobile Number',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8A8A8A),
                              fontSize: 12,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 14, right: 10),
                              child: Center(
                                widthFactor: 1,
                                child: Text(
                                  '+91',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Color(0xFF9A929F),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: blue,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // The login illustration sits in the large middle space.
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: h * 0.018,
                            horizontal: 2,
                          ),
                          child: Image.asset(
                            'assets/images/kaamdaar_loginscreen.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                'Login illustration error: $error',
                              );
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),

                      // Keep Continue anchored near the bottom.
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

                      SizedBox(height: h * (isCompact ? 0.018 : 0.035)),
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
