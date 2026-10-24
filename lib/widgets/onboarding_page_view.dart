import 'package:flutter/material.dart';
import '../app_theme.dart';

class OnboardingPageView extends StatelessWidget {
  final int pageIndex;
  final String imagePath;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLast;

  const OnboardingPageView({
    super.key,
    required this.pageIndex,
    required this.imagePath,
    required this.title,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // White panel starts at ~40%; artwork overlaps it but ends ABOVE the title.
        final panelTop = height * 0.405;
        final artworkTop = height * 0.005;
        final artworkHeight = height * 0.555; // artwork bottom = 0.56h
        final textTop = height * 0.575; // title starts below the artwork

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

              // Illustration overlaps blue and white sections.
              Positioned(
                top: artworkTop,
                left: width * 0.02,
                right: width * 0.02,
                height: artworkHeight,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Onboarding image error ($imagePath): $error');
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white70,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),

              // Text starts below the illustration (no overlap).
              Positioned(
                top: textTop,
                left: 0,
                right: 0,
                bottom: height * 0.012,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.09,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF102A43),
                              fontSize: 20,
                              height: 1.18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.008),
                    SizedBox(
                      height: height * 0.09,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Plumbing, Electrical, cleaning,\n'
                            'AC Repair, painting aur\n'
                            'kai aur services.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 16,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: pageIndex == index
                                ? KaamdarColors.orange
                                : const Color(0xFFD7D7D7),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
                      child: Row(
                        children: [
                          _ArrowButton(
                            icon: Icons.arrow_back_rounded,
                            onPressed: onBack,
                          ),
                          const SizedBox(width: 10),
                          _ArrowButton(
                            icon: Icons.arrow_forward_rounded,
                            onPressed: onNext,
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: onSkip,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: KaamdarColors.orange,
                                side: const BorderSide(
                                  color: KaamdarColors.orange,
                                  width: 1.6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                isLast ? 'Finish' : 'Skip',
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
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _ArrowButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed == null
          ? KaamdarColors.orange.withOpacity(0.45)
          : KaamdarColors.orange,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(icon, color: Colors.white, size: 27),
          ),
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
      ..cubicTo(size.width * 0.06, size.height * 0.29,
          size.width * 0.10, size.height * 0.18,
          size.width * 0.22, size.height * 0.13)
      ..cubicTo(size.width * 0.34, size.height * 0.08,
          size.width * 0.42, size.height * 0.11,
          size.width * 0.50, size.height * 0.19)
      ..cubicTo(size.width * 0.56, size.height * 0.25,
          size.width * 0.49, size.height * 0.29,
          size.width * 0.58, size.height * 0.31)
      ..cubicTo(size.width * 0.70, size.height * 0.32,
          size.width * 0.79, size.height * 0.20,
          size.width * 0.87, size.height * 0.11)
      ..cubicTo(size.width * 0.92, size.height * 0.06,
          size.width * 0.96, size.height * 0.07,
          size.width, size.height * 0.055);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}