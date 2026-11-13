import 'package:flutter/material.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _services = [
    (Icons.plumbing_rounded, 'Plumbing', Color(0xFF1261A0)),
    (Icons.electrical_services_rounded, 'Electrical', Color(0xFFFF7A00)),
    (Icons.cleaning_services_rounded, 'Cleaning', Color(0xFF36A88B)),
    (Icons.ac_unit_rounded, 'AC Repair', Color(0xFF1261A0)),
    (Icons.format_paint_rounded, 'Painting', Color(0xFFFF7A00)),
    (Icons.handyman_rounded, 'Carpentry', Color(0xFF0B1F3A)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications will be connected here.'),
              ),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final service = _services[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
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
                    border: Border.all(color: const Color(0xFFE6EBF1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(service.$1, color: service.$3, size: 32),
                      const SizedBox(height: 10),
                      Text(
                        service.$2,
                        style: const TextStyle(fontWeight: FontWeight.w700),
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
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }
}
