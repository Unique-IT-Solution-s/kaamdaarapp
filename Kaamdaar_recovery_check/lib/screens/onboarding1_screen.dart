
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

  static const List<String> _images = [
    'assets/images/onboarding_booking.png',
    'assets/images/onboarding_voice.png',
    'assets/images/onboarding_trusted.png',
  ];

  static const List<String> _titles = [
    'Har Kaam Turant\nBook Kare',
    'Voice se\nBook Kare',
    'Trusted &\nSecure',
  ];

  @override
  Widget build(BuildContext context) {
    final page = currentPage.clamp(0, 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return ColoredBox(
          color: Colors.white,
          child: Stack(
            children: [
              // Background glow
              Positioned(
                top: h * 0.09,
                left: w * 0.06,
                right: w * 0.06,
                height: h * 0.37,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFFE6C7),
                        Color(0xFFFFF5E9),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),

              // Orange curves at the top corners
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _CornerPainter(),
                  ),
                ),
              ),

              // Main layout: image, text, indicators and buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.085),
                child: Column(
                  children: [
                    // Illustration
                    Expanded(
                      flex: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: w * 0.07,
                            right: w * 0.07,
                            top: h * 0.16,
                            bottom: h * 0.04,
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: _CirclePainter(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: h * 0.035,
                              bottom: h * 0.015,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: Image.asset(
                                _images[page],
                                key: ValueKey(_images[page]),
                                width: w * 0.94,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    'Onboarding image error: $error',
                                  );
                                  return const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 45,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Heading and description
                    Expanded(
                      flex: 25,
                      child: Align(
                        alignment: const Alignment(0, -0.18),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: KaamdarColors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      _titles[page],
                                      key: ValueKey('title_$page'),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Color(0xFF17649F),
                                        fontSize: 25,
                                        height: 1.22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Plumbing, Electrical, Cleaning\n'
                                  'AC Repair, Painting aur kai aur Services.',
                                  style: TextStyle(
                                    color: Color(0xFF77717C),
                                    fontSize: 17,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Page indicator
                    SizedBox(
                      height: h * 0.055,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(left: 3),
                              width: page == index ? 17 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: page == index
                                    ? KaamdarColors.blue
                                    : const Color(0xFFD7D7D7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    // Navigation controls
                    SizedBox(
                      height: h * 0.105,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            _navButton(
                              Icons.chevron_left,
                              onBack,
                            ),
                            const SizedBox(width: 10),
                            _navButton(
                              Icons.chevron_right,
                              onNext,
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: onSkip,
                              child: Text(
                                page == 2 ? 'Finish' : 'Skip',
                                style: const TextStyle(
                                  color: KaamdarColors.orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
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
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF7900)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 3; i++) {
      final left = Path()
        ..moveTo(0, size.height * (0.04 + i * 0.018))
        ..cubicTo(
          size.width * 0.15,
          size.height * (0.05 + i * 0.018),
          size.width * 0.10,
          size.height * 0.11,
          0,
          size.height * 0.14,
        );
      canvas.drawPath(left, paint);

      final right = Path()
        ..moveTo(size.width * (0.88 + i * 0.025), 0)
        ..cubicTo(
          size.width * 0.86,
          size.height * 0.07,
          size.width * 0.96,
          size.height * 0.08,
          size.width,
          size.height * 0.12,
        );
      canvas.drawPath(right, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}

class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF7900)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);

    for (final rotation in [-0.18, 0.12, 0.28]) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * 0.93,
          height: size.height * 0.84,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) => false;
}
