
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/provider_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryGreen = Color(0xFF16A376);
  static const Color backgroundColor = Color(0xFFF1FAF6);

  bool isOnline = true;
  int selectedIndex = 0;

  // Navigate to My Bookings
  void _openBookings() {
    Navigator.pushNamed(
      context,
      AppRoutes.bookings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7F1E8),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: primaryGreen,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning, Rahul Kumar',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF252525),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Malviya Nagar, Jaipur',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isOnline
                                      ? primaryGreen
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                height: 23,
                                child: Switch(
                                  value: isOnline,
                                  onChanged: (value) {
                                    setState(() {
                                      isOnline = value;
                                    });
                                  },
                                  activeColor: Colors.white,
                                  activeTrackColor: primaryGreen,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    // TODAY'S EARNING CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's Earning",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '₹2,310.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Your earnings are looking good!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // STATS
                    Row(
                      children: [
                        _buildStatCard(
                          title: 'Today',
                          value: '3',
                          subtitle: 'Jobs',
                          icon: Icons.work_outline,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          title: 'Ratings',
                          value: '4.8',
                          subtitle: '★★★★★',
                          icon: Icons.star_outline,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          title: 'Wallet',
                          value: '₹1,213',
                          subtitle: 'Available',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // NEW SERVICE REQUEST
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Service Request',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF252525),
                          ),
                        ),
                        TextButton(
                          onPressed: _openBookings,
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),

                    _buildJobCard(
                      icon: Icons.cleaning_services_outlined,
                      title: 'Mushroom Cleaning',
                      price: '₹349',
                      location: 'Mansarovar, Jaipur, 2.0 km',
                      time: 'Today, 11:00 AM - 12:00 PM',
                      isNew: true,
                    ),

                    const SizedBox(height: 17),

                    // ONGOING JOB
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ongoing Jobs',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF252525),
                          ),
                        ),
                        TextButton(
                          onPressed: _openBookings,
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),

                    _buildJobCard(
                      icon: Icons.ac_unit,
                      title: 'AC Maintenance',
                      price: '₹450',
                      location: 'Vaishali Nagar, Jaipur, 2.2 km',
                      time: 'Today, 02:00 PM - 03:00 PM',
                      isNew: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      
bottomNavigationBar: ProviderBottomNav(
  currentIndex: 0,
  onTap: (index) {
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.bookings);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.profile);
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Earnings screen coming soon'),
        ),
      );
    }
  },
),
  
    );
  }

  // STAT CARD
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        height: 83,
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Icon(
                  icon,
                  size: 14,
                  color: primaryGreen,
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252525),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: title == 'Ratings'
                    ? Colors.orange
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // JOB CARD
  Widget _buildJobCard({
    required IconData icon,
    required String title,
    required String price,
    required String location,
    required String time,
    required bool isNew,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F6EF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: primaryGreen,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                price,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF252525),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
                size: 13,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              ),
              if (isNew)
                const Text(
                  'New',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F6EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'In Progress',
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 9,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // BOTTOM NAV ITEM
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (index == 1) {
            // Navigate to Bookings Screen
            _openBookings();
          } else if (index == 0) {
            setState(() {
              selectedIndex = 0;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label screen will be added next.'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? Colors.white
                  : Colors.white70,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: selected
                    ? Colors.white
                    : Colors.white70,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
