import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && _phone.text.isEmpty) _phone.text = arg;
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(_phone.text.trim()) || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your 10-digit phone number and password.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo login only. Connect Firebase Auth to sign in securely.')),
    );
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: KaamdarColors.ink, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Welcome Back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: KaamdarColors.ink)),
              const SizedBox(height: 8),
              const Text('Log in to continue with Kaamdar.', style: TextStyle(color: KaamdarColors.muted)),
              const SizedBox(height: 30),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(labelText: 'Mobile Number', prefixText: '+91  ', counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(13))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(13))),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _login,
                  style: FilledButton.styleFrom(backgroundColor: KaamdarColors.orange, foregroundColor: Colors.white),
                  child: const Text('Log In'),
                ),
              ),
              const SizedBox(height: 14),
            ]
          ),
        ),
      ),
    );
  }
}
