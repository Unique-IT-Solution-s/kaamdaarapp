import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KaamdarApp());
}

class KaamdarApp extends StatelessWidget {
  const KaamdarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaamdar',
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
