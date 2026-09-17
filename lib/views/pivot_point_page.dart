// views/pivot_point_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/pivot_point_viewmodel.dart';
import '../models/pivot_point_model.dart';

class PivotPointPage extends StatefulWidget {
  const PivotPointPage({super.key});

  @override
  State<PivotPointPage> createState() => _PivotPointPageState();
}

class _PivotPointPageState extends State<PivotPointPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedAsset = 'gold'; // gold | nikkei | hangseng

  static const _assetLabels = {'gold': 'Gold', 'nikkei': 'JPK', 'hangseng': 'HKK'};
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

  @override
  void initState() {
    super.initState();
    // Karena PivotPointViewModel di-share di level root app, hasil hitung
    // terakhir akan tetap "nempel" walau halaman ini ditutup-buka lagi.
    // Reset di sini supaya halaman selalu mulai dari state kosong/fresh.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PivotPointViewModel>().reset();
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final tanggal = '${date.day} ${_months[date.month - 1]} ${date.year}';
    return isToday ? 'Hari ini, $tanggal' : tanggal;
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

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
    final vm = context.read<PivotPointViewModel>();
    vm.hitung(asset: _selectedAsset, tanggal: _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PivotPointViewModel>();
    final result = vm.result;

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
                    const Text('Pivot Point',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Data Pasar (Input)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 4),
              const Text('Pilih tanggal & aset',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 16),

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
                  onPressed: vm.isLoading ? null : _hitung,
                  icon: vm.isLoading
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

              if (vm.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(vm.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                ),

              if (result != null) ...[
                const SizedBox(height: 28),
                const Text('Hasil Pivot Point',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 12),

                // Ringkasan Open/High/Low/Close
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      _MiniStat(label: 'Open', value: result.open != null ? _formatNumber(result.open!) : '-'),
                      _MiniStat(label: 'High', value: _formatNumber(result.high)),
                      _MiniStat(label: 'Low', value: _formatNumber(result.low)),
                      _MiniStat(label: 'Close', value: _formatNumber(result.close)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Daftar level R4..S4 + midpoint di antaranya
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(children: _buildLevelRows(result)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLevelRows(PivotPointModel result) {
    final labels = ['R4', 'R3', 'R2', 'R1', 'PP', 'S1', 'S2', 'S3', 'S4'];
    final values = result.levelsTopToBottom;
    final rows = <Widget>[];

    for (var i = 0; i < labels.length; i++) {
      final isPP = labels[i] == 'PP';
      final isResistance = labels[i].startsWith('R');
      final dotColor = isPP ? AppColors.primary : (isResistance ? AppColors.danger : AppColors.success);

      rows.add(_LevelRow(
        label: isPP ? 'Pivot Point (PP)' : '${isResistance ? 'Resistance' : 'Support'} ${labels[i].substring(1)} (${labels[i]})',
        value: _formatNumber(values[i]),
        dotColor: dotColor,
        isFirst: i == 0,
      ));

      if (i < labels.length - 1) {
        final mid = (values[i] + values[i + 1]) / 2;
        rows.add(_LevelRow(
          label: 'Midpoint (${labels[i]}-${labels[i + 1]})',
          value: _formatNumber(mid),
          dotColor: AppColors.textSecondary,
          isMidpoint: true,
        ));
      }
    }
    return rows;
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final bool isMidpoint;
  final bool isFirst;

  const _LevelRow({
    required this.label,
    required this.value,
    required this.dotColor,
    this.isMidpoint = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: isFirst ? null : const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isMidpoint ? 12 : 14,
                fontWeight: isMidpoint ? FontWeight.w400 : FontWeight.w600,
                color: isMidpoint ? AppColors.textSecondary : AppColors.textPrimary,
                fontStyle: isMidpoint ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isMidpoint ? 13 : 15,
              fontWeight: FontWeight.bold,
              color: isMidpoint ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}