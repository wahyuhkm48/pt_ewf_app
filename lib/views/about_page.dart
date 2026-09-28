// views/about_page.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _features = <(IconData, String, String)>[
    (Icons.savings_outlined, 'Emas Fisik', 'Hitung estimasi keuntungan jual-beli emas dari harga, kurs, dan modal.'),
    (Icons.stacked_line_chart_rounded, 'Pivot Point', 'Lihat level support dan resistance beserta sinyal buy/sell.'),
    (Icons.insights_rounded, 'Nest', 'Sinyal harian dari perbandingan close kemarin dan open hari ini.'),
    (Icons.history_rounded, 'Histori & Market Data', 'Pantau data historis dan harga pasar Gold, Nikkei, dan Hang Seng.'),
    (Icons.newspaper_rounded, 'Berita', 'Ikuti berita terbaru seputar pasar dan komoditi.'),
  ];

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ===== Konten =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 96,
                      height: 96,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/ewf_logo.png',
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.public, color: AppColors.primary, size: 48),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama
                    Text(
                      'EQUITYWORLD',
                      style: AppTextStyles.label(
                        size: 22,
                        weight: FontWeight.w800,
                        color: AppColors.primary,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Trade with Trust',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 28),

                    // Tentang aplikasi
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tentang Aplikasi',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'EQUITYWORLD adalah aplikasi pendamping perdagangan berjangka komoditi. '
                      'Kami berizin resmi BAPPEBTI sejak 2005 dan berkomitmen menjadi partner '
                      'terpercaya Anda. Aplikasi ini membantu Anda memantau pasar, menghitung '
                      'potensi transaksi, dan memahami sinyal analisis dengan cara yang sederhana.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 13, height: 1.6, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),

                    // Fitur
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fitur Utama',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._features.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FeatureRow(icon: f.$1, title: f.$2, desc: f.$3),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 20),

                    // ===== Copyright =====
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/lowprofile-highprofit.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '© $year EQUITYWORLD.\nAll rights reserved.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 1.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureRow({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 12, height: 1.4, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}