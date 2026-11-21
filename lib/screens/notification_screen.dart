import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color navy = Color(0xFF0B1F3A);
  static const Color blue = Color(0xFF1261A0);
  static const Color orange = Color(0xFFFF7A00);
  static const Color page = Color(0xFFF7F9FC);

  static const List<_Notice> todayNotices = [
    _Notice(
      icon: Icons.notifications_active_rounded,
      color: orange,
      background: Color(0xFFFFE9D3),
      title: 'Professional Arrived',
      time: '10:00 AM',
      message: 'Your AC service booking has been confirmed for 30 Oct, 10:00 AM.',
      unread: true,
    ),
    _Notice(
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF1680F5),
      background: Color(0xFFE1F0FF),
      title: 'Booking Confirmed',
      time: '10:00 AM',
      message: 'Your AC service booking has been confirmed for 30 Oct, 10:00 AM.',
    ),
    _Notice(
      icon: Icons.local_shipping_rounded,
      color: Color(0xFF20B99A),
      background: Color(0xFFDDF8F0),
      title: 'Professional on the Way',
      time: '10:00 AM',
      message: 'Your professional is on the way to your location.',
    ),
  ];

  static const List<_Notice> yesterdayNotices = [
    _Notice(
      icon: Icons.notifications_active_rounded,
      color: orange,
      background: Color(0xFFFFE9D3),
      title: 'Special Offer',
      time: '10:00 AM',
      message: 'Get 150 off on your next cleaning service. Use code CLEAN150.',
    ),
    _Notice(
      icon: Icons.star_rounded,
      color: Color(0xFF8B5CF6),
      background: Color(0xFFF0E8FF),
      title: 'Rate Your Service',
      time: '10:00 AM',
      message: 'Your AC service booking has been confirmed for 30 Oct, 10:00 AM.',
    ),
    _Notice(
      icon: Icons.local_offer_rounded,
      color: Color(0xFF1680F5),
      background: Color(0xFFE1F0FF),
      title: 'New Service Available',
      time: '10:00 AM',
      message: 'Explore new services available in your area.',
    ),
  ];

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
          'Notification',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        children: [
          const _SectionLabel('Today'),
          const SizedBox(height: 8),
          _NoticeGroup(notices: todayNotices),
          const SizedBox(height: 16),
          const _SectionLabel('Yesterday'),
          const SizedBox(height: 8),
          _NoticeGroup(notices: yesterdayNotices),
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
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: NotificationScreen.navy,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      );
}

class _NoticeGroup extends StatelessWidget {
  final List<_Notice> notices;
  const _NoticeGroup({required this.notices});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE3E8EE)),
        boxShadow: [
          BoxShadow(
            color: NotificationScreen.navy.withOpacity(.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < notices.length; i++) ...[
            _NoticeTile(notice: notices[i]),
            if (i != notices.length - 1)
              const Divider(height: 1, indent: 62, endIndent: 12, color: Color(0xFFF0F2F5)),
          ],
        ],
      ),
    );
  }
}

class _Notice {
  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String time;
  final String message;
  final bool unread;

  const _Notice({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.time,
    required this.message,
    this.unread = false,
  });
}

class _NoticeTile extends StatelessWidget {
  final _Notice notice;
  const _NoticeTile({required this.notice});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(notice.title)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: notice.background,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(notice.icon, color: notice.color, size: 20),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notice.title,
                          style: const TextStyle(
                            color: NotificationScreen.navy,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        notice.time,
                        style: const TextStyle(
                          color: Color(0xFF657386),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notice.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF667383),
                      fontSize: 10,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Padding(
              padding: EdgeInsets.only(top: 9),
              child: Icon(Icons.chevron_right_rounded, color: NotificationScreen.navy, size: 18),
            ),
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
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}
