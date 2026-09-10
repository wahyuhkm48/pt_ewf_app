// views/main_shell.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'chart_page.dart';
import 'settings_page.dart';
import 'pivot_point_page.dart';
import 'emas_fisik_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    HistoryPage(),
    ChartPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
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
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PivotPointPage()),
                  ),
                ),
                SpeedDialAction(
                  iconAsset: 'assets/images/icons/emas_fisik.png',
                  label: 'Emas Fisik',
                  onTap: () {
                    debugPrint('>>> onTap Emas Fisik jalan, context mounted: $mounted');
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EmasFisikPage()),
                    );
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