import 'package:flutter/foundation.dart';
import 'twelvedata_service.dart';
import 'yahoo_index_service.dart';
import '../models/price_candle.dart';

class ChartRepository extends ChangeNotifier {
  ChartRepository._internal();
  static final ChartRepository instance = ChartRepository._internal();

  final TwelveDataService _twelveDataService = TwelveDataService();
  final YahooIndexService _yahooService = YahooIndexService();

  Map<String, List<PriceCandle>>? _data;
  bool _isLoading = false;
  Object? _error;

  Map<String, List<PriceCandle>>? get data => _data;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  // Key internal tetap dipakai buat mapping tab, tapi sumbernya beda-beda
  static const List<String> symbols = ['XAU/USD', 'N225', 'HSI'];

  Future<void> loadAll({bool forceRefresh = false}) async {
    if (_data != null && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = <String, List<PriceCandle>>{};

      final goldData = await _twelveDataService.fetchMultipleCandles(symbols: ['XAU/USD']);

      // Gold (XAU/USD) diperdagangkan OTC hampir 24/5 seperti forex,
      // beda dengan index saham yang benar-benar tutup total di weekend.
      // Makanya TwelveData kadang masih punya candle Sabtu/Minggu untuk
      // Gold. Dibuang di sini, SEBELUM masuk ke logic commonLatest di
      // bawah, supaya tanggal weekend itu tidak ikut memengaruhi
      // perhitungan tanggal penyelarasan antar simbol.
      goldData.updateAll((key, candles) {
        return candles
            .where((c) =>
                c.date.weekday != DateTime.saturday &&
                c.date.weekday != DateTime.sunday)
            .toList();
      });

      result.addAll(goldData);

      final yahooResults = await Future.wait([
        _yahooService.fetchCandles(symbol: '^N225'),
        _yahooService.fetchCandles(symbol: '^HSI'),
      ]);
      result['N225'] = yahooResults[0];
      result['HSI'] = yahooResults[1];

      // Bandingkan HANYA tanggal kalender (tahun-bulan-tanggal), abaikan
      // jam. TwelveData dan Yahoo punya jam yang beda-beda di data
      // mereka, jadi kalau dibandingkan pakai DateTime lengkap (isBefore/
      // isAfter), urutan "simbol mana yang lebih baru" bisa salah walau
      // sebenarnya sama-sama hari yang sama, atau selisihnya cuma
      // beberapa jam padahal seharusnya dianggap beda hari kalender.
      int dayKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

      // Cari tanggal PALING BARU yang tersedia di SEMUA simbol
      // (yang paling "ketinggalan" dibanding yang lain).
      // .first dipakai karena urutan datanya terbaru duluan.
      final latestDates = result.values
          .where((list) => list.isNotEmpty)
          .map((list) => list.first.date)
          .toList();

      if (latestDates.isNotEmpty) {
        // Ambil yang PALING AWAL di antara tanggal-tanggal terbaru itu
        // (dalam kasus kamu: Gold=5 Sep, JPK/HKK=4 Sep -> hasilnya 4 Sep)
        final commonLatestKey =
            latestDates.map(dayKey).reduce((a, b) => a < b ? a : b);

        // Buang candle yang LEBIH BARU dari batas itu di semua simbol
        result.updateAll((key, candles) {
          return candles.where((c) => dayKey(c.date) <= commonLatestKey).toList();
        });
      }

      _data = result;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<PriceCandle> forTab(int tabIndex) {
    final symbol = symbols[tabIndex];
    return _data?[symbol] ?? [];
  }
}