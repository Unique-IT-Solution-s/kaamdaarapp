
import 'package:flutter/material.dart';

class OnboardingPageView extends StatelessWidget {
  final int pageIndex;
  final String title;
  final String description;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLast;

  const OnboardingPageView({
    super.key,
    required this.pageIndex,
    required this.title,
    required this.description,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
    required this.isLast,
  });

  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);
  static const Color textGrey = Color(0xFF756D7A);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return SizedBox(
          width: width,
          height: height,
          child: ColoredBox(
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Only this upper text changes between pages.
                Positioned(
                  top: height * 0.105,
                  left: width * 0.06,
                  right: width * 0.06,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        style: TextStyle(
                          color: blue,
                          fontSize: (width * 0.060)
                              .clamp(22.0, 29.0),
                          height: 1.22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: height * 0.022),
                      Text(
                        description,
                        style: TextStyle(
                          color: textGrey,
                          fontSize: (width * 0.043)
                              .clamp(16.0, 20.0),
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Fixed bottom buttons.
                Positioned(
                  left: width * 0.055,
                  right: width * 0.055,
                  bottom: height * 0.035,
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Material(
                            color: blue,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: onBack,
                              customBorder: const CircleBorder(),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 34,
                                color: onBack == null
                                    ? Colors.white54
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: onNext,
                              style: FilledButton.styleFrom(
                                backgroundColor: lightBlue,
                                foregroundColor: blue,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                isLast ? 'Finish' : 'Continue',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
        );
      },
    );
  }
}
