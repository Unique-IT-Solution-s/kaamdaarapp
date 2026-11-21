import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color navy = Color(0xFF0B1F3A);
  static const Color blue = Color(0xFF1261A0);
  static const Color orange = Color(0xFFFF7A00);
  static const Color page = Color(0xFFF7F9FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: page,
      appBar: AppBar(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Setting',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 22),
        children: [
          const _GroupTitle('Account'),
          const SizedBox(height: 7),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.notifications_active_rounded,
                iconColor: orange,
                iconBackground: const Color(0xFFFFE9D3),
                title: 'Edit Profile',
                subtitle: 'Update your Name, phone number and details.',
                onTap: () => _showMessage(context, 'Edit Profile'),
              ),
              _SettingsItem(
                icon: Icons.calendar_month_rounded,
                iconColor: const Color(0xFF1680F5),
                iconBackground: const Color(0xFFE1F0FF),
                title: 'Manage Addresses',
                subtitle: 'Home, work and other Addresses.',
                onTap: () => _showMessage(context, 'Manage Addresses'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _GroupTitle('Preferences'),
          const SizedBox(height: 7),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.notifications_active_rounded,
                iconColor: orange,
                iconBackground: const Color(0xFFFFE9D3),
                title: 'Notification Preferences',
                subtitle: 'Choose What notification you want.',
                onTap: () => _showMessage(context, 'Notification Preferences'),
              ),
              _SettingsItem(
                icon: Icons.star_rounded,
                iconColor: const Color(0xFF8B5CF6),
                iconBackground: const Color(0xFFF0E8FF),
                title: 'Language',
                subtitle: 'English',
                onTap: () => _showLanguageDialog(context),
              ),
              _SettingsItem(
                icon: Icons.sell_rounded,
                iconColor: const Color(0xFFE84D73),
                iconBackground: const Color(0xFFFFE7ED),
                title: 'App Theme',
                subtitle: 'Light (Default)',
                onTap: () => _showThemeDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _GroupTitle('Support'),
          const SizedBox(height: 7),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.support_agent_rounded,
                iconColor: orange,
                iconBackground: const Color(0xFFFFE9D3),
                title: 'Help and Support',
                subtitle: 'Get help with your bookings and account.',
                onTap: () => _showMessage(context, 'Help and Support'),
              ),
              _SettingsItem(
                icon: Icons.info_outline_rounded,
                iconColor: blue,
                iconBackground: const Color(0xFFE1F0FF),
                title: 'About KaamDaar',
                subtitle: 'App information and version.',
                onTap: () => _showMessage(context, 'About KaamDaar'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFD94343),
                iconBackground: const Color(0xFFFFE8E8),
                title: 'Logout',
                subtitle: 'Sign out from your account.',
                onTap: () => _showMessage(context, 'Logout'),
                showChevron: false,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: blue,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 58,
            child: Row(
              children: const [
                _BottomItem(icon: Icons.home_rounded, label: 'Home'),
                _BottomItem(icon: Icons.receipt_long_rounded, label: 'Booking'),
                _BottomItem(icon: Icons.person_outline_rounded, label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title will be connected later.')),
    );
  }

  static Future<void> _showLanguageDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Language'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('English'), trailing: Icon(Icons.check, color: blue)),
            ListTile(title: Text('हिन्दी')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showThemeDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('App Theme'),
        content: const Text('Light theme is currently selected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String title;
  const _GroupTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          color: SettingsScreen.navy,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      );
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE3E8EE)),
        boxShadow: [
          BoxShadow(
            color: SettingsScreen.navy.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1)
              const Divider(
                height: 1,
                indent: 58,
                endIndent: 12,
                color: Color(0xFFEDF1F5),
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showChevron;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: SettingsScreen.navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF748091),
                      fontSize: 10,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                color: SettingsScreen.navy,
                size: 19,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 21),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

