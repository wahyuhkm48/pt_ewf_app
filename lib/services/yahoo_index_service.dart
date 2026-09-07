import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/price_candle.dart';

/// Khusus untuk JPK (^N225) dan HKK (^HSI) — Twelve Data tidak
/// mendukung data index ("The index unavailable"), jadi pakai
/// endpoint data Yahoo Finance sebagai gantinya.
class YahooIndexService {
  Future<List<PriceCandle>> fetchCandles({
    required String symbol, // '^N225' atau '^HSI'
    String interval = '1d',
    String range = '1mo',
  }) async {
    final uri = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/${Uri.encodeComponent(symbol)}',
    ).replace(queryParameters: {
      'interval': interval,
      'range': range,
    });

    final response = await http.get(uri, headers: {
      'User-Agent': 'Mozilla/5.0',
    });

    debugPrint('📡 Yahoo status ($symbol): ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data $symbol (status: ${response.statusCode})');
    }

    final data = jsonDecode(response.body);
    final result = data['chart']?['result']?[0];
    if (result == null) {
      throw Exception('Data $symbol tidak ditemukan');
    }

    final List<dynamic> timestamps = result['timestamp'] ?? [];
    final quote = result['indicators']['quote'][0];
    final List<dynamic> opens = quote['open'] ?? [];
    final List<dynamic> highs = quote['high'] ?? [];
    final List<dynamic> lows = quote['low'] ?? [];
    final List<dynamic> closes = quote['close'] ?? [];

    final candles = <PriceCandle>[];
    for (var i = 0; i < timestamps.length; i++) {
      if (opens[i] == null || highs[i] == null || lows[i] == null || closes[i] == null) {
        continue;
      }
      candles.add(PriceCandle(
        date: DateTime.fromMillisecondsSinceEpoch((timestamps[i] as int) * 1000),
        open: (opens[i] as num).toDouble(),
        high: (highs[i] as num).toDouble(),
        low: (lows[i] as num).toDouble(),
        close: (closes[i] as num).toDouble(),
      ));
    }

    return candles.reversed.toList(); // terbaru duluan, konsisten sama gaya TwelveData
  }
}