// views/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';
import 'account_information_page.dart';
import 'password_page.dart';
import 'notification_page.dart';
import 'language_page.dart';
import 'help_page.dart';
import 'about_page.dart';
import '../widgets/avatar_ring.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const double _headerAspectRatio = 393 / 290;
  static const double _avatarSize = 140;

  @override
  Widget build(BuildContext context) {
    debugPrint('>>>>> SETTINGS PAGE KEBANGUN <<<<<');
    final auth = context.watch<AuthViewModel>();
    final employee = auth.employee;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final headerHeight = width / _headerAspectRatio;
                final double avatarOverlapUp = _avatarSize / 1.1;
                final double avatarBelowHeader = _avatarSize - avatarOverlapUp;

                return SizedBox(
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
                        child: AvatarRing(
                          size: _avatarSize,
                          fotoUrl: employee?.foto,
                          nama: employee?.namaLengkap,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              employee?.namaLengkap ?? 'Pengguna',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              employee?.role ?? '-',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _SettingTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Account Information',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AccountInformationPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Password',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PasswordPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notification',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguagePage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.help_outline_outlined,
                    label: 'Help',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About Me',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    isDestructive: true,
                    onTap: () => _confirmLogout(context, auth),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthViewModel auth) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin mau keluar dari akun ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
        ],
      ),
    );

    if (yakin == true && context.mounted) {
      await auth.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _SettingTile({required this.icon, required this.label, this.isDestructive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDestructive ? AppColors.dangerBg : AppColors.secondarySoft;
    final fgColor = isDestructive ? AppColors.danger : AppColors.textPrimary;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: fgColor, size: 20),
              const SizedBox(width: 14),
              Text(label, style: TextStyle(color: fgColor, fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}