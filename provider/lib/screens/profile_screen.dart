
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/provider_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                    'Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),

            // PROFILE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // PROFILE INFORMATION CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          // PROFILE ICON
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

                          const SizedBox(width: 10),

                          // NAME AND MOBILE
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ramesh Kumar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),

                                SizedBox(height: 3),

                                Text(
                                  '+91 95847 85465',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // VERIFIED BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryGreen,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 9,
                                color: primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 9),

                    // SERVICE PROFESSIONAL CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service Professional',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 3),

                          const Text(
                            'Plumbing - Drainage',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD54F),
                                size: 12,
                              ),

                              const SizedBox(width: 3),

                              const Text(
                                '4.4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),

                              const SizedBox(width: 7),

                              const Text(
                                '|',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),

                              const SizedBox(width: 7),

                              const Text(
                                '12 Jobs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            '5 years+ experience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 9),

                    // HELP AND SUPPORT
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Help and Support will be added later.',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        width: double.infinity,
                        height: 34,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Color(0xFF1688DB),
                              size: 15,
                            ),

                            const SizedBox(width: 7),

                            const Text(
                              'Help and Support',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF555555),
                              ),
                            ),

                            const Spacer(),

                            Icon(
                              Icons.arrow_forward_ios,
                              size: 11,
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 9),

                    // LOG OUT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Logout functionality will be added later.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.logout,
                          size: 13,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: primaryGreen,
                          ),
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

      // COMMON BOTTOM NAVIGATION
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.bookings,
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Earnings screen will be added next.',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
