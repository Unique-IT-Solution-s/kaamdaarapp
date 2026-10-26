import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);
  static const Color textGrey = Color(0xFF4A4A4A);

  int _currentPage = 0;

  static const List<Map<String, String>> _pages = [
    {
      'title': 'Har Kaam Turant Book Kare',
      'description':
          'Plumbing, Electrical, Cleaning\nAC Repair, Painting aur kai aur Services.',
    },
    {
      'title': 'Voice se Book kare',
      'description':
          'Plumbing, Electrical, Cleaning\nAC Repair, Painting aur kai aur Services.',
    },
    {
      'title': 'Trusted and Secure',
      'description':
          'Plumbing, Electrical, Cleaning\nAC Repair, Painting aur kai aur Services.',
    },
  ];

  bool get _isLast => _currentPage == _pages.length - 1;

  void _finish() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.createAccount);
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      setState(() => _currentPage++);
    }
  }

  void _back() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Web par bahut wide na ho, phone jaisa rahe
    final w = size.width > 480 ? 480.0 : size.width;
    final h = size.height;
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.10),

                  // Sirf ye hissa change hota hai
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      layoutBuilder: (current, previous) => Stack(
                        alignment: Alignment.topLeft,
                        children: [...previous, if (current != null) current],
                      ),
                      child: Column(
                        key: ValueKey(_currentPage),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            page['title']!,
                            style: TextStyle(
                              color: blue,
                              fontSize: (w * 0.048).clamp(18.0, 24.0),
                              height: 1.25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            page['description']!,
                            style: TextStyle(
                              color: textGrey,
                              fontSize: (w * 0.036).clamp(13.0, 16.0),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Fixed bottom buttons
                  Row(
                    children: [
                      // Back button sirf pehle page ke baad dikhega
                      if (_currentPage > 0) ...[
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Material(
                            color: blue,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: _back,
                              customBorder: const CircleBorder(),
                              child: const Icon(
                                Icons.chevron_left_rounded,
                                size: 34,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: _next,
                            style: FilledButton.styleFrom(
                              backgroundColor: lightBlue,
                              foregroundColor: blue,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              _isLast ? 'Finish' : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.035),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}