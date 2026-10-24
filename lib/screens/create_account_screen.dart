import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../routes/app_routes.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushNamed(AppRoutes.login, arguments: _phone.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: KaamdarColors.ink, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset('assets/images/kaamdar_primarylogo.png', height: 76, fit: BoxFit.contain)),
                const SizedBox(height: 38),
                const Text('Create an Account', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: KaamdarColors.ink)),
                const SizedBox(height: 8),
                const Text('Enter your mobile number to continue.', style: TextStyle(color: KaamdarColors.muted)),
                const SizedBox(height: 30),
                const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 9),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: '',
                    prefixText: '+91  ',
                    hintText: 'Enter 10-digit number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                  validator: (value) => value != null && RegExp(r'^[6-9][0-9]{9}$').hasMatch(value.trim())
                      ? null : 'Enter a valid 10-digit Indian mobile number',
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _continue,
                    style: FilledButton.styleFrom(backgroundColor: KaamdarColors.orange, foregroundColor: Colors.white),
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
                  child: const Text('Already have an account? Log in'),
                )),
                const SizedBox(height: 14),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
