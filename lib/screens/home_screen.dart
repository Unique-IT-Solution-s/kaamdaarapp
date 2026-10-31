
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_theme.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastBackPress;

  static const _services = [
    (Icons.plumbing_rounded, 'Plumbing', Color(0xFF1261A0)),
    (Icons.electrical_services_rounded, 'Electrical', Color(0xFFFF7A00)),
    (Icons.cleaning_services_rounded, 'Cleaning', Color(0xFF36A88B)),
    (Icons.ac_unit_rounded, 'AC Repair', Color(0xFF1261A0)),
    (Icons.format_paint_rounded, 'Painting', Color(0xFFFF7A00)),
    (Icons.handyman_rounded, 'Carpentry', Color(0xFF0B1F3A)),
  ];

  // Double back to exit
  void _handleBack() {
    final now = DateTime.now();

    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) >
            const Duration(seconds: 2)) {
      _lastBackPress = now;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit app'),
            duration: Duration(seconds: 2),
          ),
        );

      return;
    }

    SystemNavigator.pop();
  }

  // Firebase Logout
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: KaamdarColors.offWhite,
        appBar: AppBar(
          backgroundColor: KaamdarColors.blue,
          foregroundColor: KaamdarColors.white,
          title: const Text(
            'KaamDaar',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications will be connected here.'),
                ),
              ),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              tooltip: 'Logout',
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: KaamdarColors.navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Har Kaam Turant',
                    style: TextStyle(
                      color: KaamdarColors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Book trusted home services near you.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'What do you need help with?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: KaamdarColors.navy,
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final service = _services[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () =>
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${service.$2} booking will be connected here.',
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: KaamdarColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE6EBF1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          service.$1,
                          color: service.$3,
                          size: 32,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          service.$2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Book a service',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: KaamdarColors.navy,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () =>
                  ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking flow will be connected here.'),
                ),
              ),
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Book Now'),
              style: FilledButton.styleFrom(
                backgroundColor: KaamdarColors.orange,
                foregroundColor: KaamdarColors.white,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (index) {
            if (index != 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${['Home', 'Bookings', 'Profile'][index]} screen will be connected here.',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
