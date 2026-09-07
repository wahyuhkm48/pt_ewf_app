import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Kumpulan gaya teks sesuai design system: Geist untuk Headline & Label,
/// Inter untuk Body.
class AppTextStyles {
  AppTextStyles._();

  // Headline — Geist
  static TextStyle headline({double size = 22, Color? color, FontWeight weight = FontWeight.bold}) {
    return GoogleFonts.geist(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
    );
  }

  // Label — Geist
  static TextStyle label({double size = 13, Color? color, FontWeight weight = FontWeight.w600}) {
    return GoogleFonts.geist(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
    );
  }

  // Body — Inter
  static TextStyle body({double size = 14, Color? color, FontWeight weight = FontWeight.normal}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textSecondary,
    );
  }
}