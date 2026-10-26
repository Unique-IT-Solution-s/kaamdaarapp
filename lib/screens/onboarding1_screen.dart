import 'package:flutter/material.dart';
import '../app_theme.dart';

class Onboarding1Screen extends StatelessWidget {
  final int currentPage;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const Onboarding1Screen({
    super.key,
    required this.currentPage,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final panelTop = h * 0.405;

        return ClipRect(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: ColoredBox(color: KaamdarColors.blue),
              ),
              Positioned.fill(
                child: CustomPaint(painter: _WavePainter()),
              ),

              // White bottom panel
              Positioned(
                top: panelTop,
                left: 0,
                right: 0,
                bottom: 0,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                ),
              ),

              // Illustration overlaps the blue and white areas, like the reference.
              Positioned(
                top: h * 0.008,
                left: w * 0.025,
                right: w * 0.025,
                height: h * 0.49,
                child: Image.asset(
                  'assets/images/onboarding_booking.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stack) {
                    debugPrint('Onboarding image error: $error');
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Text and controls stay inside the screen; no vertical scrolling.
              Positioned(
                top: panelTop + h * 0.075,
                left: 0,
                right: 0,
                bottom: h * 0.012,
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.115,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Har kaam\\nTurant Book karein',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF102A43),
                              fontSize: 23,
                              height: 1.24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.012),

                    SizedBox(
                      height: h * 0.125,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Plumbing, Electrical, Cleaning,\\n'
                            'AC Repair, Painting aur\\n'
                            'kai aur services.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF343434),
                              fontSize: 17,
                              height: 1.38,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Active page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? KaamdarColors.orange
                                : const Color(0xFFD7D7D7),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
                      child: Row(
                        children: [
                          _navButton(Icons.arrow_back_rounded, onBack),
                          const SizedBox(width: 10),
                          _navButton(Icons.arrow_forward_rounded, onNext),
                          const Spacer(),
                          SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: onSkip,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: KaamdarColors.orange,
                                side: const BorderSide(
                                  color: KaamdarColors.orange,
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                currentPage == 2 ? 'Finish' : 'Skip',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _navButton(IconData icon, VoidCallback? callback) {
    return Material(
      color: callback == null
          ? KaamdarColors.orange.withOpacity(0.45)
          : KaamdarColors.orange,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: callback,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: Colors.white, size: 27),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final path = Path()
      ..moveTo(0, size.height * 0.40)
      ..cubicTo(
        size.width * 0.06,
        size.height * 0.28,
        size.width * 0.10,
        size.height * 0.17,
        size.width * 0.23,
        size.height * 0.13,
      )
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.08,
        size.width * 0.42,
        size.height * 0.10,
        size.width * 0.50,
        size.height * 0.19,
      )
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.26,
        size.width * 0.49,
        size.height * 0.29,
        size.width * 0.58,
        size.height * 0.31,
      )
      ..cubicTo(
        size.width * 0.71,
        size.height * 0.32,
        size.width * 0.79,
        size.height * 0.20,
        size.width * 0.87,
        size.height * 0.11,
      )
      ..cubicTo(
        size.width * 0.92,
        size.height * 0.06,
        size.width * 0.96,
        size.height * 0.07,
        size.width,
        size.height * 0.055,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
