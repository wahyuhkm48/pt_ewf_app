// views/splash_page.dart
import 'package:flutter/material.dart';
import 'onboarding_page.dart';

class _BubbleSpec {
  final double xFrac, yFrac, rFrac; // posisi & radius, relatif ke 393x852 (canvas referensi)
  final Color color;
  final double shadowDx, shadowDy, shadowBlur, shadowOpacity;

  const _BubbleSpec({
    required this.xFrac,
    required this.yFrac,
    required this.rFrac,
    required this.color,
    required this.shadowDx,
    required this.shadowDy,
    required this.shadowBlur,
    required this.shadowOpacity,
  });
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _scattered = false;
  bool _showLogo = false;

  static const _darkOrange = Color(0xFFC25800);
  static const _mainOrange = Color(0xFFEC700F);
  static const _lightOrange = Color(0xFFFF8D46);

  // Urutan list = urutan layer (belakang -> depan), sesuai spesifikasi kamu.
  static const List<_BubbleSpec> _bubbles = [
    // 9. kanan bawah, light orange — paling belakang
    _BubbleSpec(xFrac: 383 / 393, yFrac: 761 / 852, rFrac: 92 / 393, color: _lightOrange,
        shadowDx: 6, shadowDy: 8, shadowBlur: 14, shadowOpacity: 0.15),
    // 2. kanan atas, light orange
    _BubbleSpec(xFrac: 371 / 393, yFrac: 11 / 852, rFrac: 124 / 393, color: _lightOrange,
        shadowDx: 6, shadowDy: 8, shadowBlur: 14, shadowOpacity: 0.15),
    // 1. kiri atas, dark orange
    _BubbleSpec(xFrac: 49 / 393, yFrac: 84 / 852, rFrac: 125 / 393, color: _darkOrange,
        shadowDx: 10, shadowDy: 14, shadowBlur: 20, shadowOpacity: 0.30),
    // 8. bawah tengah, main orange
    _BubbleSpec(xFrac: 202 / 393, yFrac: 835 / 852, rFrac: 143 / 393, color: _mainOrange,
        shadowDx: 6, shadowDy: 10, shadowBlur: 16, shadowOpacity: 0.18),
    // 6. kiri bawah/tengah, main orange (di belakang lingkaran utama)
    _BubbleSpec(xFrac: 114 / 393, yFrac: 583 / 852, rFrac: 150 / 393, color: _mainOrange,
        shadowDx: 6, shadowDy: 10, shadowBlur: 16, shadowOpacity: 0.20),
    // 4. kanan tengah-bawah, dark orange (di belakang lingkaran utama)
    _BubbleSpec(xFrac: 382 / 393, yFrac: 379 / 852, rFrac: 124 / 393, color: _darkOrange,
        shadowDx: 6, shadowDy: 10, shadowBlur: 16, shadowOpacity: 0.20),
    // 3. kanan tengah, main orange
    _BubbleSpec(xFrac: 325 / 393, yFrac: 208 / 852, rFrac: 139 / 393, color: _mainOrange,
        shadowDx: 8, shadowDy: 12, shadowBlur: 18, shadowOpacity: 0.22),
    // 7. kiri paling bawah, dark orange (di depan #6)
    _BubbleSpec(xFrac: 17 / 393, yFrac: 765 / 852, rFrac: 140 / 393, color: _darkOrange,
        shadowDx: 8, shadowDy: 12, shadowBlur: 18, shadowOpacity: 0.25),
    // 5. TENGAH — lingkaran utama, paling depan, shadow paling kuat
    _BubbleSpec(xFrac: 199 / 393, yFrac: 426 / 852, rFrac: 150 / 393, color: _mainOrange,
        shadowDx: 10, shadowDy: 14, shadowBlur: 24, shadowOpacity: 0.32),
  ];

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _scattered = true);

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _showLogo = true);

    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, _, _) => const OnboardingPage(),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final cx = w / 2;
          final cy = h / 2;

          return Stack(
            fit: StackFit.expand,
            children: [
              ..._bubbles.map((b) {
                final diameter = b.rFrac * w * 2;
                final startLeft = b.xFrac * w - (diameter / 2);
                final startTop = b.yFrac * h - (diameter / 2);

                final dx = (b.xFrac * w) - cx;
                final dy = (b.yFrac * h) - cy;
                final scatterDx = (dx == 0 && dy == 0) ? w : dx * 1.6;
                final scatterDy = (dx == 0 && dy == 0) ? 0.0 : dy * 1.6;

                final left = _scattered ? startLeft + scatterDx : startLeft;
                final top = _scattered ? startTop + scatterDy : startTop;

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  left: left,
                  top: top,
                  width: diameter,
                  height: diameter,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeIn,
                    opacity: _scattered ? 0 : 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: b.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: b.shadowOpacity),
                            offset: Offset(b.shadowDx, b.shadowDy),
                            blurRadius: b.shadowBlur,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  opacity: _showLogo ? 1 : 0,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    scale: _showLogo ? 1 : 0.7,
                    child: Image.asset(
                      'assets/images/ewf_logo.png',
                      width: 160,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.public, size: 100, color: _mainOrange),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}