// views/chart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/tradingview_chart.dart';
import '../viewmodels/histori_viewmodel.dart';
import '../models/histori_data_model.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int _selectedTab = 0; // 0 = Gold, 1 = JPK, 2 = HKK
  final List<String> _tabs = const ['Gold', 'JPK', 'HKK'];
  final List<String> _tvSymbols = const ['Saxo:XAUUSD', 'Vantage:NIKKEI225', 'IG:HANGSENG'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoriViewModel>().loadTab(_selectedTab);
    });
  }

  void _pindahTab(int index) {
    setState(() => _selectedTab = index);
    context.read<HistoriViewModel>().loadTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoriViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chart', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildTabs(),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 400,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.divider)),
              child: TradingViewChart(
                key: ValueKey(_tvSymbols[_selectedTab]),
                symbol: _tvSymbols[_selectedTab],
                interval: 'D',
                height: 400,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Data Historis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.file_download_outlined, size: 16, color: AppColors.success),
                      SizedBox(width: 6),
                      Text('Excel', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(border: Border.all(color: AppColors.divider), borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 2, child: Text('TANGGAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(child: Text('OPEN', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(child: Text('HIGH', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(child: Text('LOW', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Expanded(child: Text('CLOSE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    if (vm.isLoading && !vm.hasData(_selectedTab)) {
                      return const Padding(padding: EdgeInsets.symmetric(vertical: 28), child: Center(child: CircularProgressIndicator()));
                    }
                    if (vm.errorMessage != null && !vm.hasData(_selectedTab)) {
                      return GestureDetector(
                        onTap: () => context.read<HistoriViewModel>().loadTab(_selectedTab, forceRefresh: true),
                        child: const EmptyState(
                          icon: Icons.error_outline_rounded,
                          iconSize: 30,
                          title: 'Gagal memuat data (tap untuk coba lagi)',
                          padding: EdgeInsets.symmetric(vertical: 28),
                        ),
                      );
                    }
                    final data = vm.forTab(_selectedTab);
                    if (data.isEmpty) {
                      return const EmptyState(
                        icon: Icons.table_chart_outlined,
                        iconSize: 30,
                        title: 'Belum ada data historis',
                        padding: EdgeInsets.symmetric(vertical: 28),
                      );
                    }
                    return Column(children: data.map((d) => _HistoryRow(data: d)).toList());
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final selected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _pindahTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(26)),
                alignment: Alignment.center,
                child: Text(_tabs[index],
                    style: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final HistoriDataModel data;
  const _HistoryRow({required this.data});

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.divider, width: 0.5))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(_formatDate(data.tanggal), style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
          Expanded(child: Text(data.open.toStringAsFixed(2), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
          SizedBox(width: 5), 
          Expanded(child: Text(data.high.toStringAsFixed(2), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
          SizedBox(width: 5), 
          Expanded(child: Text(data.low.toStringAsFixed(2), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
          SizedBox(width: 5), 
          Expanded(child: Text(data.close.toStringAsFixed(2), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}