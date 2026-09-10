// widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SpeedDialAction {
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  const SpeedDialAction({required this.iconAsset, required this.label, required this.onTap});
}

/// Bar navigasi bawah + tombol kalkulator mengambang.
/// PENTING: widget ini sekarang didesain untuk dipasang di dalam sebuah
/// Stack yang membungkus SELURUH body (bukan lagi di slot bottomNavigationBar
/// Scaffold yang sempit) — supaya tombol speed-dial bisa "melayang" ke atas
/// tanpa perlu area kosong yang di-reserve permanen. Lihat cara pakainya
/// di views/main_shell.dart.
class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<SpeedDialAction> calculatorActions;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.calculatorActions,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  bool _isExpanded = false;

  // Jarak maksimum tombol speed-dial menonjol ke atas pill bar (saat expanded).
  static const double _floatSpace = 92;
  static const double _barHeight = 66;

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
  }

  void _handleActionTap(SpeedDialAction action) {
    debugPrint('>>> Speed dial tapped: ${action.label}');
    setState(() => _isExpanded = false);
    action.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSafe > 0 ? bottomSafe : 12),
      child: SizedBox(
        // Sekarang tingginya mencakup seluruh area menonjol (tidak ada lagi
        // koordinat negatif di luar box ini), supaya hit-test-nya benar.
        height: _floatSpace + _barHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Bar pil — sekarang di top: _floatSpace, bukan top: 0
            Positioned(
              left: 16,
              right: 16,
              top: _floatSpace,
              child: Container(
                height: _barHeight,
                decoration: BoxDecoration(
                  color: AppColors.navBarBackground,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected: widget.currentIndex == 0,
                      onTap: () => widget.onTap(0),
                    ),
                    _NavItem(
                      icon: Icons.assignment_outlined,
                      label: 'History',
                      selected: widget.currentIndex == 1,
                      onTap: () => widget.onTap(1),
                    ),
                    const SizedBox(width: 56),
                    _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Chart',
                      selected: widget.currentIndex == 2,
                      onTap: () => widget.onTap(2),
                    ),
                    _NavItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      selected: widget.currentIndex == 3,
                      onTap: () => widget.onTap(3),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol-tombol mini speed dial
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              top: _isExpanded ? 0 : (_floatSpace - 34),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _isExpanded ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !_isExpanded,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < widget.calculatorActions.length; i++) ...[
                        _MiniActionButton(
                          action: widget.calculatorActions[i],
                          onTap: () => _handleActionTap(widget.calculatorActions[i]),
                        ),
                        if (i != widget.calculatorActions.length - 1) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Tombol kalkulator utama
            Positioned(
              top: _floatSpace - 34,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleExpand,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isExpanded ? Icons.close_rounded : Icons.calculate_rounded,
                      key: ValueKey(_isExpanded),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  final SpeedDialAction action;
  final VoidCallback onTap;

  const _MiniActionButton({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: ClipOval(
          child: Image.asset(
            action.iconAsset,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}