
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/provider_bottom_nav.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  static const Color primaryGreen = Color(0xFF16A376);
  static const Color backgroundColor = Color(0xFFF1FAF6);

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
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: primaryGreen,
                      size: 19,
                    ),
                  ),

                  const Text(
                    'Jobs Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),

            // JOB DETAILS CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CUSTOMER DETAILS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryGreen,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: primaryGreen,
                              size: 21,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            'Vijay Sharma',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // SERVICE DETAILS
                    const Text(
                      'Service Details',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF252525),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'B-104, Vaishali Nagar,\n'
                      'Jaipur, Rajasthan - 302021',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.5,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Today, 03 Nov 2026 • 2:00PM-3:00PM',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // MAP
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Map integration will be added later.',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 76,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6D6D6),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Text(
                            'Map',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // ARRIVED BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.getOtp,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryGreen,
                          side: const BorderSide(
                            color: primaryGreen,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Arrived',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // START NAVIGATION BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Navigation integration will be added later.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.navigation,
                          size: 13,
                        ),
                        label: const Text(
                          'Start Navigation',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${ProviderBottomNav.labels[index]} screen will be added next.',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
