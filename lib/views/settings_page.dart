// views/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const double _headerAspectRatio = 393 / 290;
  static const double _avatarSize = 140;

  @override
  Widget build(BuildContext context) {
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
                        child: _AvatarRing(
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
                  const _SettingTile(icon: Icons.person_outline_rounded, label: 'Account Information'),
                  const SizedBox(height: 12),
                  const _SettingTile(icon: Icons.lock_outline_rounded, label: 'Password'),
                  const SizedBox(height: 12),
                  const _SettingTile(icon: Icons.notifications_none_rounded, label: 'Notification'),
                  const SizedBox(height: 12),
                  const _SettingTile(icon: Icons.language_rounded, label: 'Language'),
                  const SizedBox(height: 12),
                  const _SettingTile(icon: Icons.help_outline_outlined, label: 'Help'),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    isDestructive: true,
                    onTap: () => _confirmLogout(context, auth),
                  ),
                  const SizedBox(height: 120),
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

/// Foto profil bulat dengan cincin gradient oranye→biru dibuat langsung
/// di kode (tidak lagi bergantung ke asset gambar seperti group 12852.png).
/// Foto diambil dari `employee.foto` (kolom database). Kalau foto kosong,
/// otomatis fallback ke inisial nama.
class _AvatarRing extends StatelessWidget {
  final double size;
  final String? fotoUrl;
  final String? nama;

  const _AvatarRing({required this.size, this.fotoUrl, this.nama});

  String get _initial {
    final n = nama?.trim();
    if (n == null || n.isEmpty) return '?';
    return n[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // Ketebalan cincin gradient
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Container(
        // Jarak putih tipis antara cincin gradient dan foto
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: ClipOval(
          child: fotoUrl != null && fotoUrl!.isNotEmpty
              ? Image.network(
                  fotoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _fallback(),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.surface,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    );
                  },
                )
              : _fallback(),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.primarySoft,
      alignment: Alignment.center,
      child: Text(
        _initial,
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
      ),
    );
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