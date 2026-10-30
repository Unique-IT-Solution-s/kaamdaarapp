import 'package:flutter/material.dart';
import '../app_theme.dart';

class OnboardingIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? KaamdarColors.blue
                : (index == 1
                    ? KaamdarColors.orange
                    : const Color(0xFFD7D7D7)),
          ),
        );
      }),
    );
  }
}
