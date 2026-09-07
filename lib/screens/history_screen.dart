import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My History',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.divider, height: 32),
            Expanded(
              child: Center(
                child: EmptyState(
                  icon: Icons.folder_open_rounded,
                  iconSize: 48,
                  title: 'Belum ada riwayat perhitungan',
                  subtitle: 'Semua hasil perhitungan pivot\nakan tersimpan di sini',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}