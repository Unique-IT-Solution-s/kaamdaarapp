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
              Positioned.fill(child: ColoredBox(color: KaamdarColors.blue)),
              Positioned.fill(child: CustomPaint(painter: _WavePainter())),
              Positioned(
                top: panelTop,
                left: 0,
                right: 0,
                bottom: 0,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                ),
              ),
              Positioned(
                top: h * 0.008,
                left: w * 0.035,
                right: w * 0.035,
                height: h * 0.465,
                child: Image.asset(
                  'assets/images/onboarding_booking.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stack) => const SizedBox.shrink(),
                ),
              ),
              Positioned(
                top: panelTop + h * 0.105,
                left: 0,
                right: 0,
                bottom: h * 0.012,
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.105,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            'Har kaam\nTurant Book karein',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF102A43),
                              fontSize: 18,
                              height: 1.22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    SizedBox(
                      height: h * 0.095,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Text(
                            'Plumbing, Electrical, cleaning,\nAC Repair, painting aur\nkai aur services.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 9),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == index
                              ? KaamdarColors.orange
                              : const Color(0xFFD7D7D7),
                        ),
                      )),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
                      child: Row(
                        children: [
                          _navButton(Icons.arrow_back_rounded, onBack),
                          const SizedBox(width: 9),
                          _navButton(Icons.arrow_forward_rounded, onNext),
                          const Spacer(),
                          SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: onSkip,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: KaamdarColors.orange,
                                side: const BorderSide(
                                  color: KaamdarColors.orange, width: 1.4),
                                padding: const EdgeInsets.symmetric(horizontal: 23),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                false ? 'Finish' : 'Skip',
                                style: const TextStyle(fontSize: 14),
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

  Widget _navButton(IconData icon, VoidCallback? callback) => Material(
    color: callback == null
        ? KaamdarColors.orange.withOpacity(.45)
        : KaamdarColors.orange,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: callback,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    ),
  );
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    final path = Path()
      ..moveTo(0, size.height * .40)
      ..cubicTo(size.width * .06, size.height * .28,
          size.width * .10, size.height * .17,
          size.width * .23, size.height * .13)
      ..cubicTo(size.width * .35, size.height * .08,
          size.width * .42, size.height * .10,
          size.width * .50, size.height * .19)
      ..cubicTo(size.width * .56, size.height * .26,
          size.width * .49, size.height * .29,
          size.width * .58, size.height * .31)
      ..cubicTo(size.width * .71, size.height * .32,
          size.width * .79, size.height * .20,
          size.width * .87, size.height * .11)
      ..cubicTo(size.width * .92, size.height * .06,
          size.width * .96, size.height * .07,
          size.width, size.height * .055);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
