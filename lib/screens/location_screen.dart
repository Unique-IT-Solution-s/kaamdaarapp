
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../routes/app_routes.dart';

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

  Future<void> _openHome({Position? position, String? address}) async {
    if (!mounted) return;

    // TODO: Yahan apni backend API mein location save karo.
    // GPS coordinates: position?.latitude, position?.longitude
    // Manual address: address

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  Future<void> _allowLocation() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        final openSettings = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Location is turned off'),
            content: const Text(
              'Please turn on your device location and try again.',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, true),
                child: const Text('Settings'),
              ),
            ],
          ),
        );

        if (openSettings == true) {
          await Geolocator.openLocationSettings();
        }
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage('Location permission is required.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          'Please allow location permission in app settings.',
        );
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await _openHome(position: position);
    } catch (e) {
      _showMessage('Unable to get location. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _enterManually() async {
    final controller = TextEditingController();

    try {
      final location = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Enter your location'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Enter city or area',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (!mounted || location == null || location.trim().isEmpty) {
        return;
      }

      await _openHome(address: location.trim());
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.055),

                      const Text(
                        'Allow Location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Allow us to Access your Location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: grey,
                          fontSize: 13,
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Image.asset(
                            'assets/images/location.png',
                            width: 230,
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.location_on,
                                color: blue,
                                size: height * 0.20,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const _BenefitRow(
                        icon: Icons.location_searching,
                        text: 'Find nearby professionals.',
                      ),

                      const SizedBox(height: 16),

                      const _BenefitRow(
                        icon: Icons.access_time,
                        text: 'Faster booking',
                      ),

                      const SizedBox(height: 16),

                      const _BenefitRow(
                        icon: Icons.assistant_navigation,
                        text: 'Better Service Experience',
                      ),

                      const Spacer(flex: 2),

                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _loading ? null : _allowLocation,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: blue,
                            side: const BorderSide(color: blue),
                            shape: const StadiumBorder(),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Allow Location',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: FilledButton(
                          onPressed:
                              _loading ? null : _enterManually,
                          style: FilledButton.styleFrom(
                            backgroundColor: lightBlue,
                            foregroundColor: blue,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Enter Manually',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.035),
                    ],
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

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF756D7A),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
