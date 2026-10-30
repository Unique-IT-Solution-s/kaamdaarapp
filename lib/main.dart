import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_theme.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const KaamdarApp());
}

class KaamdarApp extends StatelessWidget {
  const KaamdarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaamDaar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: KaamdarColors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: KaamdarColors.blue,
          primary: KaamdarColors.blue,
          secondary: KaamdarColors.orange,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}