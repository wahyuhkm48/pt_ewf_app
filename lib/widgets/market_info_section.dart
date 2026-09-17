import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'tradingview_symbol_info.dart';
import 'tradingview_technical_analysis.dart';

class MarketInfoSection extends StatefulWidget {
  const MarketInfoSection({super.key});

  @override
  State<MarketInfoSection> createState() => _MarketInfoSectionState();
}

class _MarketInfoSectionState extends State<MarketInfoSection> {
  int _selectedTab = 0; // 0 = Gold, 1 = JPK, 2 = HKK
  final List<String> _tabs = const ['Gold', 'JPK', 'HKK'];
  final List<String> _tvSymbols = const ['Saxo:XAUUSD', 'Vantage:NIKKEI225', 'IG:HANGSENG'];

  @override
  Widget build(BuildContext context) {
    final symbol = _tvSymbols[_selectedTab];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Market Info', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        _buildTabs(),
        const SizedBox(height: 16),

        // Container Symbol Info
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: TradingViewSymbolInfo(
            key: ValueKey('symbol-info-$symbol'),
            symbol: symbol,
            height: 190,
          ),
        ),
        const SizedBox(height: 16),

        // Container Technical Analysis
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: TradingViewTechnicalAnalysis(
            key: ValueKey('technical-analysis-$symbol'),
            symbol: symbol,
            height: 450,
          ),
        ),
      ],
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
              onTap: () => setState(() => _selectedTab = index),
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