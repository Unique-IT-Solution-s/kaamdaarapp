
import 'package:flutter/material.dart';
import '../app_theme.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedTab = 0;

  static const List<_Booking> _bookings = [
    _Booking(
      name: 'Home Cleaning',
      id: 'KAAM3869001',
      date: '20 Oct 2026',
      status: 'Completed',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF1261A0),
      completed: true,
    ),
    _Booking(
      name: 'Plumbing Service',
      id: 'KAAM3869002',
      date: '20 Oct 2026',
      status: 'Completed',
      icon: Icons.plumbing_rounded,
      color: Color(0xFF1261A0),
      completed: true,
    ),
    _Booking(
      name: 'AC Installation',
      id: 'KAAM3869003',
      date: '20 Oct 2026',
      status: 'Completed',
      icon: Icons.ac_unit_rounded,
      color: Color(0xFF1261A0),
      completed: true,
    ),
  ];

  List<_Booking> get _filteredBookings {
    if (_selectedTab == 1) {
      return _bookings
          .where((booking) => !booking.completed)
          .toList();
    }

    return _bookings;
  }

  // BOOKING DETAILS
  void _showDetails(_Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1F3A),
                ),
              ),

              const SizedBox(height: 20),

              _detailRow('Service', booking.name),
              _detailRow('Booking ID', booking.id),
              _detailRow('Booking Date', booking.date),
              _detailRow('Status', booking.status),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: KaamdarColors.blue,
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B1F3A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOOK AGAIN
  void _bookAgain(_Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${booking.name} again'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double s =
        (MediaQuery.sizeOf(context).width / 390)
            .clamp(0.85, 1.2)
            .toDouble();

    return Scaffold(
      backgroundColor: KaamdarColors.offWhite,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ==================================
            // BLUE HEADER
            // ==================================

            Container(
              height: 72 * s,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16 * s,
              ),
              color: KaamdarColors.blue,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 38 * s,
                      height: 38 * s,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: KaamdarColors.blue,
                        size: 19 * s,
                      ),
                    ),
                  ),

                  SizedBox(width: 13 * s),

                  Text(
                    'MY Bookings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19 * s,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================
            // ALL / CURRENT TABS
            // ==================================

            Padding(
              padding: EdgeInsets.fromLTRB(
                18 * s,
                17 * s,
                18 * s,
                14 * s,
              ),
              child: Container(
                height: 42 * s,
                padding: EdgeInsets.all(3 * s),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFDCE6F0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _filterButton(
                        'All',
                        0,
                        s,
                      ),
                    ),
                    Expanded(
                      child: _filterButton(
                        'Current',
                        1,
                        s,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================
            // BOOKING LIST
            // ==================================

            Expanded(
              child: _filteredBookings.isEmpty
                  ? _emptyBookings(s)
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        16 * s,
                        0,
                        16 * s,
                        18 * s,
                      ),
                      itemCount: _filteredBookings.length,
                      itemBuilder: (context, index) {
                        return _bookingCard(
                          _filteredBookings[index],
                          s,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ==================================
      // BOTTOM NAVIGATION
      // ==================================

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 55 * s,
          color: KaamdarColors.blue,
          child: Row(
            children: [
              Expanded(
                child: _navItem(
                  Icons.home_rounded,
                  'Home',
                  false,
                  s,
                  () => Navigator.pop(context),
                ),
              ),

              Expanded(
                child: _navItem(
                  Icons.receipt_long_rounded,
                  'Booking',
                  true,
                  s,
                  () {},
                ),
              ),

              Expanded(
                child: _navItem(
                  Icons.person_outline_rounded,
                  'Profile',
                  false,
                  s,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile screen'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================
  // FILTER BUTTON
  // ==================================

  Widget _filterButton(
    String title,
    int index,
    double s,
  ) {
    final bool selected = _selectedTab == index;

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? KaamdarColors.blue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12 * s,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : KaamdarColors.blue,
          ),
        ),
      ),
    );
  }

  // ==================================
  // BOOKING CARD
  // ==================================

  Widget _bookingCard(_Booking booking, double s) {
    return Container(
      margin: EdgeInsets.only(bottom: 12 * s),
      padding: EdgeInsets.all(9 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(
          color: const Color(0xFFDCE5EE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 5 * s,
            offset: Offset(0, 2 * s),
          ),
        ],
      ),
      child: Column(
        children: [
          // BOOKING INFORMATION

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58 * s,
                height: 58 * s,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2F9),
                  borderRadius: BorderRadius.circular(7 * s),
                ),
                child: Icon(
                  booking.icon,
                  size: 30 * s,
                  color: booking.color,
                ),
              ),

              SizedBox(width: 10 * s),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12 * s,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF263238),
                      ),
                    ),

                    SizedBox(height: 3 * s),

                    Text(
                      'Booking ID: ${booking.id}',
                      style: TextStyle(
                        fontSize: 8 * s,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(height: 3 * s),

                    Text(
                      booking.date,
                      style: TextStyle(
                        fontSize: 9 * s,
                        color: const Color(0xFF263238),
                      ),
                    ),

                    SizedBox(height: 4 * s),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * s,
                        vertical: 3 * s,
                      ),
                      decoration: BoxDecoration(
                        color: booking.completed
                            ? const Color(0xFF43C66B)
                            : const Color(0xFFFFB74D),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        booking.status,
                        style: TextStyle(
                          fontSize: 8 * s,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 9 * s),

          // ACTION BUTTONS

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 29 * s,
                  child: OutlinedButton(
                    onPressed: () => _showDetails(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: KaamdarColors.blue,
                      side: BorderSide(
                        color: KaamdarColors.blue,
                        width: 1,
                      ),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 9 * s,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 7 * s),

              Expanded(
                child: SizedBox(
                  height: 29 * s,
                  child: FilledButton(
                    onPressed: () => _bookAgain(booking),
                    style: FilledButton.styleFrom(
                      backgroundColor: KaamdarColors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Book Again',
                      style: TextStyle(
                        fontSize: 9 * s,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================================
  // EMPTY CURRENT BOOKINGS
  // ==================================

  Widget _emptyBookings(double s) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25 * s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 55 * s,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12 * s),
            Text(
              'No Current Bookings',
              style: TextStyle(
                fontSize: 16 * s,
                fontWeight: FontWeight.w700,
                color: KaamdarColors.navy,
              ),
            ),
            SizedBox(height: 6 * s),
            Text(
              'Your active bookings will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12 * s,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================
  // BOTTOM NAV ITEM
  // ==================================

  Widget _navItem(
    IconData icon,
    String label,
    bool selected,
    double s,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 21 * s,
            color: selected
                ? const Color(0xFF00E5FF)
                : Colors.white,
          ),
          SizedBox(height: 3 * s),
          Text(
            label,
            style: TextStyle(
              fontSize: 11 * s,
              color: selected
                  ? const Color(0xFF00E5FF)
                  : Colors.white,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// BOOKING MODEL
// ==========================================

class _Booking {
  final String name;
  final String id;
  final String date;
  final String status;
  final IconData icon;
  final Color color;
  final bool completed;

  const _Booking({
    required this.name,
    required this.id,
    required this.date,
    required this.status,
    required this.icon,
    required this.color,
    required this.completed,
  });
}
