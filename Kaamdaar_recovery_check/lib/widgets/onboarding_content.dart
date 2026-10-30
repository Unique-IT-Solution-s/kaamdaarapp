import 'package:flutter/material.dart';
import '../app_theme.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;
      final panelTop = h * 0.405;

      return ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
                child: ColoredBox(color: KaamdarColors.blue)),
            Positioned.fill(child: CustomPaint(painter: _WavePainter())),
            Positioned(
              top: panelTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
              ),
            ),

            // Sticker overlaps the blue/white boundary like the Figma design.
            Positioned(
              top: h * 0.008,
              left: w * 0.025,
              right: w * 0.025,
              height: h * 0.555,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Onboarding asset failed ($image): $error');
                  return const Center(
                    child: Icon(Icons.broken_image_outlined,
                        color: Colors.white70, size: 40),
                  );
                },
              ),
            ),

            Positioned(
              top: h * 0.585,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF102A43),
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              top: h * 0.695,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF424242),
                    fontSize: 16,
                    height: 1.32,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
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
