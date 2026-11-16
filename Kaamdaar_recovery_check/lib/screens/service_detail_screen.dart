
import 'package:flutter/material.dart';
import '../app_theme.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final IconData serviceIcon;
  final Color serviceColor;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.serviceIcon,
    required this.serviceColor,
  });

  Future<void> _bookInstant(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Book Service'),
        content: Text(
          'Do you want to book $serviceName service?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Booking request UI is ready. Backend connection is pending.',
          ),
        ),
      );
    }
  }

  Future<void> _scheduleLater(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
    );

    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${date.day}/${date.month}/${date.year} '
          'at ${time.format(context)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: KaamdarColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          'Service',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // SERVICE IMAGE AREA
          Container(
            height: 220,
            width: double.infinity,
            color: const Color(0xFFD9D9D9),
            child: Center(
              child: Icon(
                serviceIcon,
                size: 100,
                color: serviceColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16, 14, 16, 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SERVICE NAME
                Text(
                  '$serviceName Service and Repair',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202020),
                  ),
                ),

                const SizedBox(height: 5),

                // RATING
                Row(
                  children: const [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 17,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '4.8 (2.8k reviews)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // SERVICE FEATURES
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [
                    _FeatureItem(
                      icon: Icons.cleaning_services_rounded,
                      label: 'Cleaning',
                    ),
                    _FeatureItem(
                      icon: Icons.local_gas_station_rounded,
                      label: 'Gas Refill',
                    ),
                    _FeatureItem(
                      icon: Icons.build_rounded,
                      label: 'Repair',
                    ),
                    _FeatureItem(
                      icon: Icons.install_desktop_rounded,
                      label: 'Installation',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ABOUT SERVICE
                const Text(
                  'About this Service',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Keep your ${serviceName.toLowerCase()} service '
                  'and repair needs covered with professional '
                  'and reliable experts. Get quality service '
                  'at your doorstep.',
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 22),

                // PRICE AND INSTANT BOOKING
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹499',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Starting Price',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    FilledButton(
                      onPressed: () => _bookInstant(context),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFDCEAF7),
                        foregroundColor:
                            KaamdarColors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Book Instant',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 13),

                // SCHEDULE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 43,
                  child: FilledButton(
                    onPressed: () => _scheduleLater(context),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFDCEAF7),
                      foregroundColor:
                          KaamdarColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Schedule for later',
                      style: TextStyle(
                        fontSize: 13,
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

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        height: 62,
        color: KaamdarColors.blue,
        child: Row(
          children: [
            _BottomItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: false,
              onTap: () => Navigator.pop(context),
            ),
            _BottomItem(
              icon: Icons.receipt_long_rounded,
              label: 'Booking',
              selected: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking screen coming soon.'),
                  ),
                );
              },
            ),
            _BottomItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              selected: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile screen coming soon.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// FEATURE ITEM
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFDCEAF7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: KaamdarColors.blue,
            size: 19,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// BOTTOM NAV ITEM
class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? Colors.cyanAccent
                  : Colors.white,
              size: 21,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.cyanAccent
                    : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
