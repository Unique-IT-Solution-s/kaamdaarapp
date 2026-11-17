
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/provider_bottom_nav.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  static const Color primaryGreen = Color(0xFF16A376);
  static const Color backgroundColor = Color(0xFFF1FAF6);

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              height: 51,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: primaryGreen,
                      size: 19,
                    ),
                  ),

                  const Text(
                    'My Bookings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),

            // BOOKING CONTENT
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ONGOING / COMPLETED TABS
                  Container(
                    height: 46,
                    width: 240,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0F0E5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        _buildTab('Ongoing', 0),
                        _buildTab('Completed', 1),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  Expanded(
                    child: selectedTab == 0
                        ? _buildOngoingBookings()
                        : _buildCompletedBookings(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            );
          } else if (index == 1) {
            // Already on Bookings
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Earnings screen will be added next.',
                ),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.profile,
            );
          }
        },
      ),
    );
  }

  // TAB BUTTON
  Widget _buildTab(String title, int index) {
    final bool isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? primaryGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : primaryGreen,
            ),
          ),
        ),
      ),
    );
  }

  // ONGOING BOOKINGS
  Widget _buildOngoingBookings() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      children: [
        _buildBookingCard(
          title: 'AC Cleaning',
          location: 'Mansarovar, Jaipur 3.2 Km',
          status: 'In Progress',
          icon: Icons.ac_unit,
        ),

        const SizedBox(height: 8),

        _buildBookingCard(
          title: 'Washroom Cleaning',
          location: 'Mansarovar, Jaipur 3.2 Km',
          price: '₹349',
          time: 'Today, 11:00AM-12:00PM',
          icon: Icons.cleaning_services_outlined,
        ),
      ],
    );
  }

  // COMPLETED BOOKINGS
  Widget _buildCompletedBookings() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      children: [
        _buildBookingCard(
          title: 'Home Cleaning',
          location: 'Malviya Nagar, Jaipur 2.5 Km',
          price: '₹499',
          time: 'Yesterday, 10:00AM-12:00PM',
          status: 'Completed',
          icon: Icons.home_outlined,
        ),

        const SizedBox(height: 8),

        _buildBookingCard(
          title: 'AC Servicing',
          location: 'Vaishali Nagar, Jaipur 3.0 Km',
          price: '₹599',
          time: 'Yesterday, 02:00PM-03:00PM',
          status: 'Completed',
          icon: Icons.ac_unit,
        ),
      ],
    );
  }

  // BOOKING CARD
  Widget _buildBookingCard({
    required String title,
    required String location,
    required IconData icon,
    String? price,
    String? time,
    String? status,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.jobDetails,
        );
      },
      borderRadius: BorderRadius.circular(8),

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),

        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F2E8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                color: primaryGreen,
                size: 19,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF292929),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),

                  if (time != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ],

                  if (status != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 9,
                        color: status == 'Completed'
                            ? Colors.green
                            : const Color(0xFF1688DB),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (price != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Color(0xFF444444),
            ),
          ],
        ),
      ),
    );
  }
}
