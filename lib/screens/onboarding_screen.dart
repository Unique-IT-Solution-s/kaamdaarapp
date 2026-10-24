import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _PageData('assets/images/onboarding_booking.png',
        'Har kaam\nTurant Book karein'),
    _PageData('assets/images/onboarding_voice.png',
        'Voice se\nBook Karein'),
    _PageData('assets/images/onboarding_trusted.png',
        'Trusted & Secure'),
  ];

  void _goToPage(int index) {
    if (index < 0 || index >= _pages.length || !_controller.hasClients) return;
    _controller.animateToPage(index,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOutCubic);
  }

  void _finish() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.createAccount);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaamdarColors.blue,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final h = constraints.maxHeight;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              PageView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => OnboardingContent(
                  image: _pages[index].image,
                  title: _pages[index].title,
                  description:
                      'Plumbing, Electrical, cleaning,\nAC Repair, painting aur\nkai aur services.',
                ),
              ),

              // Fixed indicator: outside PageView, so it never slides sideways.
              Positioned(
                left: 0,
                right: 0,
                bottom: h * 0.105,
                child: IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final active = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        width: active ? 11 : 10,
                        height: active ? 11 : 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? KaamdarColors.orange
                              : const Color(0xFFD7D7D7),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Fixed navigation row: only the page content moves.
              Positioned(
                left: 22,
                right: 22,
                bottom: 10,
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Icons.arrow_back_rounded,
                      enabled: _currentPage > 0,
                      onTap: _currentPage > 0
                          ? () => _goToPage(_currentPage - 1)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    _CircleButton(
                      icon: Icons.arrow_forward_rounded,
                      enabled: true,
                      onTap: _currentPage < _pages.length - 1
                          ? () => _goToPage(_currentPage + 1)
                          : _finish,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: _finish,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: KaamdarColors.orange,
                          side: const BorderSide(
                              color: KaamdarColors.orange, width: 1.6),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Finish' : 'Skip',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _PageData {
  final String image;
  final String title;
  const _PageData(this.image, this.title);
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? KaamdarColors.orange
          : KaamdarColors.orange.withOpacity(0.45),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 27),
        ),
      ),
    );
  }
}
