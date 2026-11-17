
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isEnglishSelected = true;

  static const Color primaryGreen = Color(0xFF16A376);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FAF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              const Text(
                'Choose Your Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 35),

              // Language Illustration
              Image.asset(
                'assets/images/language.png',
                height: 115,
                width: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 35),

              // English Language Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEnglishSelected = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isEnglishSelected
                          ? primaryGreen
                          : Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isEnglishSelected
                            ? primaryGreen
                            : Colors.grey.shade400,
                        size: 21,
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'English',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Continue in English',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.language,
                        color: primaryGreen,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: isEnglishSelected
                      ? () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
