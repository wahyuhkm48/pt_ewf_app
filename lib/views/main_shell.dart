// views/main_shell.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/recent_history_viewmodel.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'chart_page.dart';
import 'settings_page.dart';
import 'konsep_transaksi_page.dart';
import 'emas_fisik_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Dinaikkan setiap kali user selesai menghitung sesuatu, supaya tab History
  // dibuat ulang (initState jalan lagi) dan datanya ikut ter-refresh.
  int _historyVersion = 0;

  /// Buka halaman kalkulator, lalu refresh riwayat begitu user kembali.
  Future<void> _openCalculator(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    if (!mounted) return;
    setState(() => _historyVersion++);
    context.read<RecentHistoryViewModel>().load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onViewAllHistory: () => setState(() => _currentIndex = 1)),
      HistoryPage(key: ValueKey(_historyVersion)),
      const ChartPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              calculatorActions: [
                SpeedDialAction(
                  iconAsset: 'assets/images/icons/pivot_point.png',
                  label: 'Pivot Point',
                  onTap: () => _openCalculator(const KonsepTransaksiPage()),
                ),
                SpeedDialAction(
                  iconAsset: 'assets/images/icons/emas_fisik.png',
                  label: 'Emas Fisik',
                  onTap: () {
                    debugPrint('>>> onTap Emas Fisik jalan, context mounted: $mounted');
                    _openCalculator(const EmasFisikPage());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}