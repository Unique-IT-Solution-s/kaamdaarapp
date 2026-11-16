import 'package:flutter/material.dart';
import '../app_theme.dart';

class KaamdarBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const KaamdarBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(Icons.home_rounded, 'Home'),
    _NavItem(Icons.receipt_long_rounded, 'Booking'),
    _NavItem(Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final s = (MediaQuery.sizeOf(context).width / 390)
        .clamp(0.85, 1.2).toDouble();

    return Container(
      color: KaamdarColors.blue,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60 * s,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = currentIndex == index;
              final color = selected
                  ? const Color(0xFF00E5FF)
                  : Colors.white;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 25 * s, color: color),
                      SizedBox(height: 3 * s),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12 * s,
                          color: color,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
