import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  static const navy = Color(0xFF0B1F3A);
  static const blue = Color(0xFF1261A0);
  static const orange = Color(0xFFFF7A00);
  static const pale = Color(0xFFEAF3FB);
  static const referralCode = 'KD12345';

  void _copy(BuildContext context, String value, String message) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Refer & Earn',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _hero(),
          const SizedBox(height: 16),
          _codeCard(context),
          const SizedBox(height: 22),
          const Text('Earn Exciting Rewards',
              style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _rewards(),
          const SizedBox(height: 22),
          const Text('How it Works?',
              style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _step('1', Icons.ios_share_rounded, 'Share your referral code',
              'Invite friends through WhatsApp, SMS or social media.'),
          _step('2', Icons.person_add_alt_1_rounded, 'Your friend joins KaamDaar',
              'They sign up and apply your referral code.'),
          _step('3', Icons.account_balance_wallet_rounded, 'Both get rewarded',
              'You receive wallet credit and your friend gets a first-booking discount.'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E9),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFFFD7B3)),
            ),
            child: const Text(
              'Note: ₹50 rewards and referral code are sample UI values. Actual referral and wallet functionality will be connected later.',
              style: TextStyle(color: navy, fontSize: 12, height: 1.45),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: blue,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(children: const [
              _NavItem(Icons.home_rounded, 'Home'),
              _NavItem(Icons.receipt_long_rounded, 'Booking'),
              _NavItem(Icons.person_outline_rounded, 'Profile'),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _hero() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEAF4FF), Color(0xFFFFF4E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD9E9F8)),
        ),
        child: Row(children: [
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Refer Friends & Family',
                  style: TextStyle(color: navy, fontSize: 19, fontWeight: FontWeight.w800)),
              SizedBox(height: 7),
              Text(
                'Invite your friends to KaamDaar and earn rewards when they book a service.',
                style: TextStyle(color: Color(0xFF536579), fontSize: 13, height: 1.45),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.groups_rounded, color: orange, size: 45),
          ),
        ]),
      );

  Widget _codeCard(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: _cardDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your Referral Code',
              style: TextStyle(color: Color(0xFF6B7785), fontSize: 12)),
          const SizedBox(height: 9),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(11)),
                child: Row(children: [
                  const Expanded(
                    child: Text(referralCode,
                        style: TextStyle(color: navy, fontSize: 17,
                            fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                  ),
                  IconButton(
                    onPressed: () => _copy(context, referralCode, 'Referral code copied!'),
                    icon: const Icon(Icons.copy_rounded, color: blue),
                    tooltip: 'Copy code',
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 9),
            FilledButton.icon(
              onPressed: () => _copy(context,
                  'Join me on KaamDaar! Use my referral code $referralCode.',
                  'Referral message copied. Sharing can be connected later.'),
              style: FilledButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              ),
              icon: const Icon(Icons.share_rounded, size: 17),
              label: const Text('Share'),
            ),
          ]),
        ]),
      );

  Widget _rewards() => Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 7),
        decoration: _cardDecoration(),
        child: const Row(children: [
          Expanded(child: _Reward(Icons.account_balance_wallet_rounded, '₹50',
              'You get', 'Wallet credit', blue)),
          _VLine(),
          Expanded(child: _Reward(Icons.card_giftcard_rounded, '₹50',
              'Friend gets', 'First booking off', orange)),
          _VLine(),
          Expanded(child: _Reward(Icons.monetization_on_rounded, 'More',
              'Referrals', 'More rewards', Color(0xFF2D9B72))),
        ]),
      );

  Widget _step(String n, IconData icon, String title, String subtitle) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: _cardDecoration(),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: blue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$n. $title',
                style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(subtitle,
                style: const TextStyle(color: Color(0xFF758292), fontSize: 12, height: 1.35)),
          ])),
        ]),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5ECF3)),
        boxShadow: [BoxShadow(color: navy.withOpacity(.05), blurRadius: 13, offset: const Offset(0, 4))],
      );
}

class _Reward extends StatelessWidget {
  final IconData icon;
  final String amount, title, subtitle;
  final Color color;
  const _Reward(this.icon, this.amount, this.title, this.subtitle, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 7),
        Text(amount, style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(title, textAlign: TextAlign.center,
            style: const TextStyle(color: ReferEarnScreen.navy, fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(subtitle, textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF7B8794), fontSize: 10)),
      ]);
}

class _VLine extends StatelessWidget {
  const _VLine();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 72, color: const Color(0xFFE8EDF2));
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 23),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ]),
      );
}
