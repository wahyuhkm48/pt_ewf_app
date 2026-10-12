import 'package:flutter/material.dart';

/// Kumpulan warna utama aplikasi, diambil dari desain (nuansa oranye/peach).
class AppColors {
  AppColors._();

  // Tint sangat lembut (latar ikon/kartu)
  static const Color primaryTint = Color(0xFFFFF1E6);
  static const Color secondaryTint = Color(0xFFDCEBFF);

  static const Color darkButtonTop = Color(0xFF1B1F2A);
  static const Color darkButtonBottom = Color(0xFF0D0F14);

  // Primary — oranye
  static const Color primary = Color(0xFFEC7013);
  static const Color primaryLight = Color(0xFFFF8D46);
  static const Color primaryDeep = Color(0xFFC25800);
  static const Color primaryDark = Color(0xFFB85510);
  static const Color primarySoft = Color(0xFFFBD9BE); // tint lembut untuk banner

  // Secondary — biru
  static const Color secondary = Color(0xFF138EEC);
  static const Color secondarySoft = Color(0xFFBBD6FB);

  // Tertiary — hijau
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

  // Ilustrasi (globe di halaman Bahasa)
  static const Color globeLight = Color(0xFF64C7F0);
  static const Color globeDark = Color(0xFF4389D8);

  // Brand sumber berita (kartu berita cadangan)
  static const Color brandBloomberg = Color(0xFF1A1A1A);
  static const Color brandCnbc = Color(0xFF0A1E42);
  static const Color brandReuters = Color(0xFFFF6600);
  static const Color brandDefault = Color(0xFF37474F);

  // Overlay gelap di atas foto berita (sama dengan Colors.black87)
  static const Color overlayDark = Color(0xDD000000);
}