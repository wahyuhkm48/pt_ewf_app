// views/emas_fisik_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/emas_fisik_viewmodel.dart';

class EmasFisikPage extends StatefulWidget {
  const EmasFisikPage({super.key});

  @override
  State<EmasFisikPage> createState() => _EmasFisikPageState();
}

class _EmasFisikPageState extends State<EmasFisikPage> {
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _kursController = TextEditingController();
  final _modalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<EmasFisikViewModel>();
      await vm.muatHargaAwal();
      if (vm.kursAwal != null) {
        _kursController.text = vm.kursAwal!.toStringAsFixed(0);
      }
    });
  }

  @override
  void dispose() {
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _kursController.dispose();
    _modalController.dispose();
    super.dispose();
  }

  double _parseNumber(String text) {
    final cleaned = text.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }

  String _formatNumber(double value) {
    final rounded = value.round();
    final str = rounded.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  String _formatDecimal(double value, {int decimals = 2}) {
    return value.toStringAsFixed(decimals).replaceAll('.', ',');
  }

  void _hitung() {
    final vm = context.read<EmasFisikViewModel>();
    vm.hitung(
      hb: _parseNumber(_hargaBeliController.text),
      hj: _parseNumber(_hargaJualController.text),
      kurs: _parseNumber(_kursController.text),
      modal: _parseNumber(_modalController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmasFisikViewModel>();
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/icons/emas_fisik.png', width: 28, height: 28),
                        const SizedBox(width: 10),
                        const Text('Emas Fisik',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Input Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 12),

              if (vm.isLoadingHarga)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text('Memuat kurs terkini...', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              if (vm.errorHarga != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(vm.errorHarga!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              _InputField(label: 'Harga Beli (USD / toz)', controller: _hargaBeliController, hint: 'Contoh: 2.500'),
              const SizedBox(height: 14),
              _InputField(label: 'Harga Jual (USD / toz)', controller: _hargaJualController, hint: 'Contoh: 2.510'),
              const SizedBox(height: 14),
              _InputField(
                label: 'Kurs (USD ke IDR)',
                controller: _kursController,
                readOnly: false,
                hint: vm.isLoadingHarga ? 'Memuat...' : null,
              ),
              const SizedBox(height: 14),
              _InputField(label: 'Modal (Rupiah)', controller: _modalController, hint: 'Contoh: 10.000.000'),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _hitung,
                  icon: const Icon(Icons.calculate_rounded, color: Colors.white),
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
                  child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),

              if (result != null) ...[
                const SizedBox(height: 28),
                const Text('Hasil Perhitungan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 12),
                _ResultCard(number: 1, title: 'HHB (Harga Hitung Beli)', formula: 'HB × Kurs ÷ 31,1',
                    value: 'Rp ${_formatNumber(result.hhb)}', valueColor: AppColors.primary),
                const SizedBox(height: 12),
                _ResultCard(number: 2, title: 'HHJ (Harga Hitung Jual)', formula: 'HJ × Kurs ÷ 31,1',
                    value: 'Rp ${_formatNumber(result.hhj)}', valueColor: AppColors.primary),
                const SizedBox(height: 12),
                _ResultCard(number: 3, title: 'Selisih (HHJ - HHB)', formula: 'HHJ - HHB',
                    value: '${result.selisih >= 0 ? '+' : ''}Rp ${_formatNumber(result.selisih)}',
                    valueColor: result.selisih >= 0 ? AppColors.success : Colors.red),
                const SizedBox(height: 12),
                _ResultCard(number: 4, title: 'Berat Emas (Gram)', formula: 'Modal ÷ HHB',
                    value: '${_formatDecimal(result.beratGram)} gram', valueColor: AppColors.primary),
                const SizedBox(height: 12),
                _ResultCard(number: 5, title: 'Keuntungan', formula: 'Selisih × Gram',
                    value: '${result.profit >= 0 ? '+' : ''}Rp ${_formatNumber(result.profit)}',
                    valueColor: result.profit >= 0 ? AppColors.success : Colors.red),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;

  const _InputField({required this.label, required this.controller, this.hint, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: readOnly ? AppColors.divider.withValues(alpha: 0.3) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          SizedBox(
            width: 130,
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: readOnly ? AppColors.textSecondary : AppColors.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final int number;
  final String title;
  final String formula;
  final String value;
  final Color valueColor;

  const _ResultCard({required this.number, required this.title, required this.formula, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.primary,
              child: Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(formula, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: valueColor)),
        ],
      ),
    );
  }
}