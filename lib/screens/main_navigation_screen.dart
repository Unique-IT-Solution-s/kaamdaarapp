import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'booking_screen.dart';
import 'user_profile_screen.dart';

/// Root container for the three customer tabs.
/// Keep this screen as the app's Home route so tab changes do not push routes.
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 2);
  }

  void _selectTab(int index) {
    if (index < 0 || index > 2 || index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: [
        HomeScreen(onTabSelected: _selectTab),
        BookingScreen(onTabSelected: _selectTab),
        UserProfileScreen(onTabSelected: _selectTab),
      ],
    );
  }
}
