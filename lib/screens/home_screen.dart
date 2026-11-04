import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'booking_screen.dart';
import '../app_theme.dart';
import '../routes/app_routes.dart';
import 'service_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastBackPress;
  String _location = 'Getting your location...';
  String _searchQuery = '';

  // Service images: put PNGs in assets/images/services/ and add the folder
  // under `assets:` in pubspec.yaml. If an image is missing, a soft blob with
  // the icon is shown instead, so nothing breaks.
  static const List<_Service> _services = [
    _Service('Plumbing', '₹299', Icons.plumbing_rounded, Color(0xFF1261A0), 'assets/images/services/plumbing.png'),
    _Service('Painting', '₹299', Icons.format_paint_rounded, Color(0xFFFF7A00), 'assets/images/services/painting.png'),
    _Service('Gardening', '₹299', Icons.yard_rounded, Color(0xFF36A88B), 'assets/images/services/gardening.png'),
    _Service('AC Cleaning', '₹299', Icons.ac_unit_rounded, Color(0xFF1261A0), 'assets/images/services/ac_cleaning.png'),
    _Service('Salon', '₹299', Icons.content_cut_rounded, Color(0xFFFF7A00), 'assets/images/services/salon.png'),
    _Service('Dish washing', '₹299', Icons.local_dining_rounded, Color(0xFF36A88B), 'assets/images/services/dish_washing.png'),
    _Service('Electrician', '₹299', Icons.electrical_services_rounded, Color(0xFFFF7A00), 'assets/images/services/electrician.png'),
    _Service('Home Cleaning', '₹399', Icons.cleaning_services_rounded, Color(0xFF1261A0), 'assets/images/services/home_cleaning.png'),
    _Service('Carpenter', '₹299', Icons.handyman_rounded, Color(0xFF36A88B), 'assets/images/services/carpenter.png'),
    _Service('Pest Control', '₹499', Icons.pest_control_rounded, Color(0xFFFF7A00), 'assets/images/services/pest_control.png'),
    _Service('Appliance Repair', '₹399', Icons.home_repair_service_rounded, Color(0xFF1261A0), 'assets/images/services/appliance_repair.png'),
    _Service('Water Purifier', '₹299', Icons.water_drop_rounded, Color(0xFF36A88B), 'assets/images/services/water_purifier.png'),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  // ───────────── LOCATION ─────────────
  Future<void> _loadCurrentLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        if (mounted) setState(() => _location = 'Location is turned off');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _location = 'Select your location');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Geocoding 5.x API
      final geocoding = Geocoding();

      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;

        final parts = <String?>[
          place.subLocality,
          place.locality,
          place.postalCode,
          place.administrativeArea,
        ]
            .whereType<String>()
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList();

        setState(() {
          _location = parts.isEmpty ? 'Location detected' : parts.join(', ');
        });
      }
    } catch (e) {
      debugPrint('Location error: $e');
      if (mounted) setState(() => _location = 'Tap to set location');
    }
  }

  // ───────────── BACK BUTTON ─────────────
  void _handleBack() {
    final now = DateTime.now();

    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
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

  // ───────────── LOGOUT ─────────────
  Future<void> _logout() async {
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

    if (confirm != true || !mounted) return;

    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  // ───────────── BOOK SERVICE ─────────────
  void _bookService(String name) {
  // Banner button: user ko service select karne do.
  if (name == 'General') {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a Service',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                ..._services.map((service) {
                  return ListTile(
                    leading: Icon(
                      service.icon,
                      color: service.color,
                    ),
                    title: Text(service.name),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _openServiceDetail(service);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
    return;
  }

  final service = _services.firstWhere(
    (item) => item.name == name,
  );

  _openServiceDetail(service);
}

// OPEN SERVICE DETAIL SCREEN
void _openServiceDetail(_Service service) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ServiceDetailScreen(
        serviceName: service.name,
        serviceIcon: service.icon,
        serviceColor: service.color,
      ),
    ),
  );
}

  // ───────────── BUILD ─────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double s = (size.width / 390).clamp(0.85, 1.2);

    final query = _searchQuery.trim().toLowerCase();
    final filtered =
        _services.where((e) => e.name.toLowerCase().contains(query)).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _header(s),
            Expanded(
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(child: _banner(s)),
                  SliverToBoxAdapter(child: _searchBar(s)),

                  // Section title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(20 * s, 26 * s, 20 * s, 12 * s),
                      child: Text(
                        'Our Services',
                        style: TextStyle(
                          fontSize: 19 * s,
                          fontWeight: FontWeight.w700,
                          color: KaamdarColors.navy,
                        ),
                      ),
                    ),
                  ),

                  if (filtered.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(30 * s),
                        child: const Center(child: Text('No services found.')),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16 * s, 0, 16 * s, 24 * s),
                      sliver: SliverGrid(
                        // Fixed height per card => no bottom overflow.
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12 * s,
                          crossAxisSpacing: 10 * s,
                          mainAxisExtent: 172 * s,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _serviceCard(filtered[i], s),
                          childCount: filtered.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNav(s),
      ),
    );
  }

  // ───────────── HEADER ─────────────
  Widget _header(double s) {
    return Container(
      width: double.infinity,
      color: KaamdarColors.blue,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 76 * s,
          padding: EdgeInsets.symmetric(horizontal: 16 * s),
          child: Row(
            children: [
              InkWell(
                onTap: _loadCurrentLocation,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: 21 * s,
                  backgroundColor: const Color(0xFF315EAE),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 26 * s,
                  ),
                ),
              ),
              SizedBox(width: 12 * s),
              Expanded(
                child: InkWell(
                  onTap: _loadCurrentLocation,
                  child: Text(
                    _location,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5 * s,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8 * s),
              PopupMenuButton<String>(
                tooltip: 'Profile options',
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'logout') _logout();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'profile', child: Text('My Profile')),
                  PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
                child: CircleAvatar(
                  radius: 21 * s,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    color: KaamdarColors.blue,
                    size: 27 * s,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────── BANNER ─────────────
  Widget _banner(double s) {
    return Container(
      height: 150 * s,
      margin: EdgeInsets.fromLTRB(16 * s, 12 * s, 16 * s, 0),
      padding: EdgeInsets.fromLTRB(4 * s, 8 * s, 8 * s, 8 * s),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Ghar ka har kaam\nTurant karo with\n',
                        style: TextStyle(
                          color: const Color(0xFF1261A0),
                          fontSize: 18 * s,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'kaamdaar',
                        style: TextStyle(
                          color: const Color(0xFFFF7A00),
                          fontSize: 18 * s,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10 * s),
                SizedBox(
                  height: 32 * s,
                  child: FilledButton(
                    onPressed: () => _bookService('General'),
                    style: FilledButton.styleFrom(
                      backgroundColor: KaamdarColors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16 * s),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20 * s),
                      ),
                    ),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 12 * s,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Image.asset(
              'assets/images/home_banner.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.engineering_rounded,
                color: KaamdarColors.orange,
                size: 80 * s,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────── SEARCH BAR ─────────────
  Widget _searchBar(double s) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18 * s, 14 * s, 18 * s, 0),
      child: Container(
        height: 50 * s,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30 * s),
          border: Border.all(color: KaamdarColors.orange, width: 1.5),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          textInputAction: TextInputAction.search,
          style: TextStyle(fontSize: 15 * s, color: KaamdarColors.navy),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15 * s),
            prefixIcon: Icon(Icons.search, size: 23 * s, color: Colors.grey.shade600),
            suffixIcon: Icon(Icons.mic_none_rounded, size: 23 * s, color: Colors.grey.shade600),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14 * s),
          ),
        ),
      ),
    );
  }

  // ───────────── SERVICE CARD ─────────────
  Widget _serviceCard(_Service service, double s) {
    // Clamp text scale so large system fonts can't cause overflow.
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: media.textScaler.clamp(maxScaleFactor: 1.0),
      ),
      child: InkWell(
        onTap: () => _bookService(service.name),
        borderRadius: BorderRadius.circular(12 * s),
        child: Container(
          padding: EdgeInsets.fromLTRB(8 * s, 8 * s, 8 * s, 8 * s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * s),
            border: Border.all(color: const Color(0xFFE0E8F1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6 * s,
                offset: Offset(0, 2 * s),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area takes whatever height is left
              Expanded(
                child: Center(child: _serviceImage(service, s)),
              ),

              SizedBox(height: 4 * s),

              Text(
                service.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5 * s,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF263238),
                ),
              ),

              Text(
                service.price,
                style: TextStyle(
                  color: KaamdarColors.blue,
                  fontSize: 15 * s,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: const Color(0xFFFFB000), size: 12 * s),
                  SizedBox(width: 2 * s),
                  Expanded(
                    child: Text(
                      '(4.3k reviews)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8 * s, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6 * s),

              SizedBox(
                width: double.infinity,
                height: 26 * s,
                child: FilledButton(
                  onPressed: () => _bookService(service.name),
                  style: FilledButton.styleFrom(
                    backgroundColor: KaamdarColors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20 * s),
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 10 * s,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Image with soft-blob fallback (matches Figma placeholder look)
  Widget _serviceImage(_Service service, double s) {
    Widget fallback() => Container(
          width: 56 * s,
          height: 50 * s,
          decoration: BoxDecoration(
            color: const Color(0xFFD5E1EE),
            borderRadius: BorderRadius.circular(26 * s),
          ),
          child: Icon(service.icon, color: service.color, size: 26 * s),
        );

    return Image.asset(
      service.image,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => fallback(),
    );
  }

  // ───────────── BOTTOM NAV ─────────────
  Widget _bottomNav(double s) {
    return Container(
      color: KaamdarColors.blue,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60 * s,
          child: Row(
            children: [
              Expanded(
                child: _navItem(Icons.home_rounded, 'Home', true, s, () {}),
              ),
              Expanded(
  child: _navItem(
    Icons.receipt_long_outlined,
    'Booking',
    false,
    s,
    () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BookingScreen(),
        ),
      );
    },
  ),
),
              Expanded(
                child: _navItem(Icons.person_outline_rounded, 'Profile', false, s, () {
                  // Connect your profile screen route here.
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool selected,
    double s,
    VoidCallback onTap,
  ) {
    final color = selected ? const Color(0xFF00E5FF) : Colors.white;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25 * s, color: color),
          SizedBox(height: 3 * s),
          Text(
            label,
            style: TextStyle(
              fontSize: 12 * s,
              color: color,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────── MODEL ─────────────
class _Service {
  final String name;
  final String price;
  final IconData icon;
  final Color color;
  final String image;

  const _Service(this.name, this.price, this.icon, this.color, this.image);
}