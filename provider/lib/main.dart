
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderApp());
}

class ProviderApp extends StatelessWidget {
  const ProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KAAMDAAR Provider',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),

      routes: {
        '/home': (context) => const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text('KAAMDAAR Provider'),
          ),
        ),
      },

      home: const SplashScreen(),
    );
  }
}
