import 'package:flutter/material.dart';

/// Kumpulan animasi transisi halaman yang dipakai berulang di seluruh app,
/// supaya konsisten dan tidak perlu copy-paste di tiap screen.
class PageTransitions {
  PageTransitions._();

  /// Slide masuk dari kanan layar (dipakai misal saat "view all" ditekan).
  static Route<T> slideRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Dipakai untuk transisi ke halaman detail yang punya Hero animation
  /// (misal dari card berita ke NewsDetailScreen). Hero tetap "terbang"
  /// otomatis walau pakai route custom ini — yang diatur di sini cuma
  /// fade+scale konten SEKITAR gambar hero, dengan curve easeOut.
  static Route<T> heroDetail<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: child,
        );
      },
    );
  }
}