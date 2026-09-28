// views/transaksi_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/pivot_point_viewmodel.dart';
import '../viewmodels/nest_viewmodel.dart';
import '../models/pivot_point_model.dart';
import '../models/nest_model.dart';
import '../widgets/action_badge.dart';
import '../widgets/mini_stat.dart';
import '../widgets/education_sections.dart';
import '../utils/pivot_point_levels.dart';

enum _KalkulatorMode { pivotPoint, nest }

class KonsepTransaksiPage extends StatefulWidget {
  const KonsepTransaksiPage({super.key});

  @override
  State<KonsepTransaksiPage> createState() => _KonsepTransaksiPageState();
}

class _KonsepTransaksiPageState extends State<KonsepTransaksiPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedAsset = 'gold'; // gold | nikkei | hangseng
  _KalkulatorMode _mode = _KalkulatorMode.pivotPoint; // default: Pivot Point

  static const _assetLabels = {'gold': 'Gold', 'nikkei': 'JPK', 'hangseng': 'HKK'};
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PivotPointViewModel>().reset();
      context.read<NestViewModel>().reset();
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final tanggal = '${date.day} ${_months[date.month - 1]} ${date.year}';
    return isToday ? 'Hari ini, $tanggal' : tanggal;
  }

  String _formatNumber(double value) => value.toStringAsFixed(2);

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _hitung() {
    if (_mode == _KalkulatorMode.pivotPoint) {
      context.read<PivotPointViewModel>().hitung(asset: _selectedAsset, tanggal: _selectedDate);
    } else {
      context.read<NestViewModel>().hitung(asset: _selectedAsset, tanggal: _selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pivotVm = context.watch<PivotPointViewModel>();
    final nestVm = context.watch<NestViewModel>();

    final isLoading = _mode == _KalkulatorMode.pivotPoint ? pivotVm.isLoading : nestVm.isLoading;
    final errorMessage = _mode == _KalkulatorMode.pivotPoint ? pivotVm.errorMessage : nestVm.errorMessage;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/icons/pivot_point.png', width: 28, height: 28),
                        const SizedBox(width: 10),
                        const Text('Konsep Transaksi',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Data Pasar (Input)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 4),
              const Text('Pilih mode kalkulasi, tanggal & aset',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 16),

              // Mode: Pivot Point / Nest
              const Text('Mode Kalkulasi',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: _KalkulatorMode.values.map((mode) {
                    final selected = _mode == mode;
                    final label = mode == _KalkulatorMode.pivotPoint ? 'Pivot Point' : 'Nest';
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _mode = mode),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          alignment: Alignment.center,
                          child: Text(label,
                              style: TextStyle(
                                  color: selected ? Colors.white : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              // Penjelasan konsep (berubah sesuai mode)
              _mode == _KalkulatorMode.pivotPoint
                  ? const PivotPointExplainer()
                  : const NestExplainer(),
              const SizedBox(height: 14),

              // Tanggal
              const Text('Tanggal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pilihTanggal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(_selectedDate),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Aset
              const Text('Aset', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: _assetLabels.entries.map((entry) {
                    final selected = _selectedAsset == entry.key;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedAsset = entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          alignment: Alignment.center,
                          child: Text(entry.value,
                              style: TextStyle(
                                  color: selected ? Colors.white : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _hitung,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.calculate_rounded, color: Colors.white),
                  label: const Text('Hitung', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),

              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(errorMessage, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                ),

              if (_mode == _KalkulatorMode.pivotPoint && pivotVm.result != null) ..._buildPivotPointResult(pivotVm.result!),
              if (_mode == _KalkulatorMode.nest && nestVm.result != null) ..._buildNestResult(nestVm.result!),
            ],
          ),
        ),
      ),
    );
  }

  // Indikator: PP > O = buy, PP < O = sell, PP == O = netral
  List<Widget> _buildPivotPointResult(PivotPointModel result) {
    return [
      const SizedBox(height: 28),
      const Text('Hasil Pivot Point',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
      const SizedBox(height: 12),

      if (result.action != null) ...[
        ActionBadge(action: result.action!),
        if (result.open != null) ...[
          const SizedBox(height: 12),
          PivotPointWhyCard(
            action: result.action!,
            pivotPoint: result.pivotPoint,
            open: result.open!,
          ),
        ],
        const SizedBox(height: 16),
      ],

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            MiniStat(label: 'Open', value: result.open != null ? _formatNumber(result.open!) : '-'),
            MiniStat(label: 'High', value: _formatNumber(result.high)),
            MiniStat(label: 'Low', value: _formatNumber(result.low)),
            MiniStat(label: 'Close', value: _formatNumber(result.close)),
          ],
        ),
      ),
      const SizedBox(height: 16),

      Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(children: buildPivotLevelRows(result)),
      ),
    ];
  }

  List<Widget> _buildNestResult(NestModel result) {
    return [
      const SizedBox(height: 28),
      const Text('Hasil Nest',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
      const SizedBox(height: 12),

      ActionBadge(action: result.action),
      if (result.open != null) ...[
        const SizedBox(height: 12),
        NestWhyCard(action: result.action, close: result.close, open: result.open!),
      ],
      const SizedBox(height: 16),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            MiniStat(label: 'Open (Hari ini)', value: result.open != null ? _formatNumber(result.open!) : '-'),
            MiniStat(label: 'Close (Kemarin)', value: _formatNumber(result.close)),
          ],
        ),
      ),
    ];
  }
}
