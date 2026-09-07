import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Rasio asli asset
  static const double _headerAspectRatio = 393 / 290; // Rectangle_1351.png
  static const double _avatarSize = 180; // ukuran tampil avatar (persegi)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            LayoutBuilder(
                builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final headerHeight = width / _headerAspectRatio;

                    // Satu sumber kebenaran: seberapa banyak avatar nongol
                    // di BAWAH garis bawah header (bukan lagi hardcode di 2 tempat)
                    final double avatarOverlapUp = _avatarSize / 1.1; // seberapa avatar ditarik naik
                    final double avatarBelowHeader = _avatarSize - avatarOverlapUp; // sisa yg nongol di bawah

                    return SizedBox(
                    // Tinggi total = tinggi header + bagian avatar yang nongol ke bawah
                    height: headerHeight + avatarBelowHeader,
                    child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                        Image.asset(
                            'assets/images/rectangle 1351.png',
                            width: width,
                            height: headerHeight,
                            fit: BoxFit.fill,
                        ),
                        Positioned(
                            top: headerHeight - avatarOverlapUp,
                            left: (width - _avatarSize) / 2,
                            child: Image.asset(
                            'assets/images/group 12852.png',
                            width: _avatarSize,
                            height: _avatarSize,
                            ),
                        ),
                        ],
                    ),
                    );
                },
            ),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    children: [
                    _SettingTile(icon: Icons.person_outline_rounded, label: 'Account Information'),
                    const SizedBox(height: 12),
                    _SettingTile(icon: Icons.lock_outline_rounded, label: 'Password'),
                    const SizedBox(height: 12),
                    _SettingTile(icon: Icons.notifications_none_rounded, label: 'Notification'),
                    const SizedBox(height: 12),
                    _SettingTile(icon: Icons.language_rounded, label: 'Language'),
                    const SizedBox(height: 12),
                    _SettingTile(icon: Icons.help_outline_outlined, label: 'Help'),
                    const SizedBox(height: 12),
                    _SettingTile(
                        icon: Icons.logout_rounded,
                        label: 'Logout',
                        isDestructive: true,
                    ),
                    const SizedBox(height: 24),
                    ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool isDestructive;

  const _SettingTile({required this.icon, required this.label, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDestructive ? const Color(0xFFFBD9D9) : const Color(0xFFBBD6FB);
    final fgColor = isDestructive ? const Color(0xFFD64545) : AppColors.textPrimary;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: fgColor, size: 20),
                const SizedBox(width: 14),
              ],
              Text(
                label,
                style: TextStyle(color: fgColor, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
