import 'package:flutter/material.dart';

/// Kumpulan warna utama aplikasi, diambil dari desain (nuansa oranye/peach).
class AppColors {
  AppColors._();

  // Primary — oranye
  static const Color primary = Color(0xFFEC7013);
  static const Color primaryDark = Color(0xFFB85510);
  static const Color primarySoft = Color(0xFFFBD9BE); // tint lembut untuk banner

  // Secondary — biru
  static const Color secondary = Color(0xFF138EEC);
  static const Color secondarySoft = Color(0xFFBBD6FB);

  // Tertiary — hijau
  static const Color tertiary = Color(0xFF13EC8E);
  static const Color success = Color(0xFF13A868);
  static const Color successBg = Color(0xFFDCF9EB);

  // Neutral
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF8C8A87);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF2F2F2);
  static const Color navBarBackground = Color(0xFFEDEAE6);
  static const Color divider = Color(0xFFE5E5E5);

  // Danger (untuk tombol Logout dsb, di luar palette resmi tapi umum dipakai)
  static const Color danger = Color(0xFFE53935);
  static const Color dangerBg = Color(0xFFFBD9D9);
}