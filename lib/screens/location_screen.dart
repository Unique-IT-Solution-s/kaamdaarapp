
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../routes/app_routes.dart';
import 'address_screens.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static const Color blue = Color(0xFF1261A0);
  static const Color lightBlue = Color(0xFFD6E5F2);
  static const Color grey = Color(0xFF756D7A);

  bool _loading = false;

  // ---------------------------------------------------------
  // NAVIGATE TO HOME
  // ---------------------------------------------------------

  void _openHome({Position? position}) {
    if (!mounted) return;

    if (position != null) {
      debugPrint('Latitude: ${position.latitude}');
      debugPrint('Longitude: ${position.longitude}');
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  // ---------------------------------------------------------
  // LOCATION PERMISSION
  // ---------------------------------------------------------

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (!mounted) return false;

    if (permission == LocationPermission.denied) {
      _showMessage(
        'Location permission denied. Please allow permission.',
      );
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Location permission is permanently denied. '
              'Please enable it from app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('Open Settings'),
              ),
            ],
          );
        },
      );

      if (!mounted) return false;

      if (openSettings == true) {
        await Geolocator.openAppSettings();
      }

      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  // ---------------------------------------------------------
  // ALLOW LOCATION
  // ---------------------------------------------------------

  Future<void> _allowLocation() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      final permissionGranted =
          await _checkLocationPermission();

      if (!mounted || !permissionGranted) return;

      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!mounted) return;

      if (!serviceEnabled) {
        final openSettings = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Location is turned off'),
              content: const Text(
                'Please turn on your device location to continue.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Settings'),
                ),
              ],
            );
          },
        );

        if (!mounted) return;

        if (openSettings == true) {
          await Geolocator.openLocationSettings();
        }

        // User must tap Allow Location again after enabling GPS.
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 25),
        ),
      );

      if (!mounted) return;

      _openHome(position: position);
    } on LocationServiceDisabledException {
      _showMessage(
        'Please enable your device location and try again.',
      );
    } on PermissionDeniedException {
      _showMessage(
        'Location permission is required to continue.',
      );
    } catch (e) {
      debugPrint('Location error: $e');

      _showMessage(
        'Unable to get location. Check your GPS and try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ---------------------------------------------------------
  // SNACKBAR
  // ---------------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------------------------------------------------------
  // ENTER MANUALLY
  // ---------------------------------------------------------

  Future<void> _enterManually() async {
    if (_loading) return;

    final result = await Navigator.push<AddressData>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAddressScreen(),
      ),
    );

    if (!mounted || result == null) return;

    // First saved address opens the saved-address screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedAddressesScreen(
          addresses: [result],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            final compact = height < 680;

            final horizontalPadding =
                constraints.maxWidth < 360 ? 20.0 : 24.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: height,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: height *
                                  (compact ? 0.025 : 0.035),
                            ),

                            const Text(
                              'Allow Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: blue,
                                fontSize: 21,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: height * 0.018),

                            const Text(
                              'Allow us to Access your Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: grey,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),

                            SizedBox(
                              height: height *
                                  (compact ? 0.245 : 0.275),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/location.png',
                                  width:
                                      constraints.maxWidth * 0.70,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    debugPrint(
                                      'Location image error: $error',
                                    );

                                    return Icon(
                                      Icons.location_on_rounded,
                                      color: blue,
                                      size: height * 0.15,
                                    );
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.006),

                            const _BenefitRow(
                              icon: Icons.location_searching_rounded,
                              text: 'Find nearby professionals.',
                            ),

                            SizedBox(height: height * 0.018),

                            const _BenefitRow(
                              icon: Icons.access_time_rounded,
                              text: 'Faster booking',
                            ),

                            SizedBox(height: height * 0.018),

                            const _BenefitRow(
                              icon: Icons.navigation_rounded,
                              text: 'Better Service Experience',
                            ),

                            const Spacer(),

                            const SizedBox(height: 22),

                            SizedBox(
                              height: 46,
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed:
                                    _loading ? null : _allowLocation,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: blue,
                                  side: const BorderSide(
                                    color: blue,
                                    width: 1.1,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 19,
                                        height: 19,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Allow Location',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            SizedBox(
                              height: 46,
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _loading
                                    ? null
                                    : _enterManually,
                                style: FilledButton.styleFrom(
                                  backgroundColor: lightBlue,
                                  foregroundColor: blue,
                                  disabledBackgroundColor:
                                      lightBlue,
                                  elevation: 0,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Enter Manually',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: height *
                                  (compact ? 0.025 : 0.035),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// BENEFIT ROW
// ---------------------------------------------------------

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFD6E5F2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1261A0),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF756D7A),
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
