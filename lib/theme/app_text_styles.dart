import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Geist untuk Headline & Label, Inter untuk Body.
class AppTextStyles {
  AppTextStyles._();

  // ===== Token baku (skala tipografi) =====
  static TextStyle _geist(double size, FontWeight w, Color? c) =>
      GoogleFonts.geist(fontSize: size, fontWeight: w, color: c ?? AppColors.textPrimary);

  static TextStyle _inter(double size, FontWeight w, Color? c) =>
      GoogleFonts.inter(fontSize: size, fontWeight: w, color: c ?? AppColors.textSecondary);

  static TextStyle labelBase({Color? color}) => _geist(14, FontWeight.w600, color);

  static TextStyle display({Color? color}) => _geist(32, FontWeight.w700, color);

  // Headline: Geist
  static TextStyle h1({Color? color}) => _geist(26, FontWeight.w700, color);
  static TextStyle h2({Color? color}) => _geist(22, FontWeight.w700, color);
  static TextStyle h3({Color? color}) => _geist(18, FontWeight.w700, color);

  // Label: Geist
  static TextStyle labelLg({Color? color}) => _geist(16, FontWeight.w600, color);
  static TextStyle labelMd({Color? color}) => _geist(13, FontWeight.w600, color);
  static TextStyle labelSm({Color? color}) => _geist(12, FontWeight.w600, color);

  // Body: Inter
  static TextStyle bodyLg({Color? color}) => _inter(16, FontWeight.w400, color);
  static TextStyle bodyMd({Color? color}) => _inter(14, FontWeight.w400, color);
  static TextStyle bodySm({Color? color}) => _inter(13, FontWeight.w400, color);
  static TextStyle caption({Color? color}) => _inter(12, FontWeight.w400, color);
  static TextStyle micro({Color? color}) => _inter(11, FontWeight.w400, color);
}