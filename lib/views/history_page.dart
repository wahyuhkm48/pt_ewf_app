// views/history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../services/pivot_point_service.dart';
import '../services/emas_fisik_service.dart';
import '../models/pivot_point_model.dart';
import '../models/emas_fisik_model.dart';
import '../core/api_client.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _tab = 0; // 0 = Pivot Point, 1 = Emas Fisik

  bool _loading = true;
  String? _error;
  List<PivotPointModel> _pivotHistory = [];
  List<EmasFisikModel> _emasHistory = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final client = context.read<ApiClient>();
    try {
      final pivotRiwayat = await PivotPointService(client).riwayat();
      final emasRiwayat = await EmasFisikService(client).riwayat();
      setState(() {
        _pivotHistory = pivotRiwayat;
        _emasHistory = emasRiwayat;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

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
            const SizedBox(height: 12),
            _buildTabSwitcher(),
            const Divider(color: AppColors.divider, height: 32),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Row(
      children: [
        _TabChip(label: 'Pivot Point', selected: _tab == 0, onTap: () => setState(() => _tab = 0)),
        const SizedBox(width: 10),
        _TabChip(label: 'Emas Fisik', selected: _tab == 1, onTap: () => setState(() => _tab = 1)),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          iconSize: 48,
          title: 'Gagal memuat riwayat',
          subtitle: _error,
        ),
      );
    }

    if (_tab == 0) {
      if (_pivotHistory.isEmpty) {
        return const Center(
          child: EmptyState(
            icon: Icons.folder_open_rounded,
            iconSize: 48,
            title: 'Belum ada riwayat perhitungan',
            subtitle: 'Semua hasil perhitungan pivot\nakan tersimpan di sini',
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          itemCount: _pivotHistory.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _PivotHistoryTile(item: _pivotHistory[i]),
        ),
      );
    } else {
      if (_emasHistory.isEmpty) {
        return const Center(
          child: EmptyState(
            icon: Icons.folder_open_rounded,
            iconSize: 48,
            title: 'Belum ada riwayat perhitungan',
            subtitle: 'Semua hasil perhitungan emas fisik\nakan tersimpan di sini',
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          itemCount: _emasHistory.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _EmasHistoryTile(item: _emasHistory[i]),
        ),
      );
    }
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _PivotHistoryTile extends StatelessWidget {
  final PivotPointModel item;
  const _PivotHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final tanggal = item.tanggal;
    final tanggalStr = tanggal != null
        ? '${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}'
        : '-';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: const BoxDecoration(color: AppColors.secondarySoft, shape: BoxShape.circle),
            child: const Icon(Icons.trending_up_rounded, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pivot Point: ${item.pivotPoint.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(tanggalStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmasHistoryTile extends StatelessWidget {
  final EmasFisikModel item;
  const _EmasHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final tanggal = item.tanggal;
    final tanggalStr = tanggal != null
        ? '${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}'
        : '-';
    final untung = item.profit >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: untung ? AppColors.successBg : AppColors.dangerBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              untung ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: untung ? AppColors.success : AppColors.danger,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profit: ${item.profit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14,
                      color: untung ? AppColors.success : AppColors.danger,
                    )),
                const SizedBox(height: 2),
                Text('${item.beratGram.toStringAsFixed(2)} gram • $tanggalStr',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}