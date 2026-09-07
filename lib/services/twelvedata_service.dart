import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/price_candle.dart';

class TwelveDataService {
  static const String _baseUrl = 'https://api.twelvedata.com/time_series';

  Future<Map<String, List<PriceCandle>>> fetchMultipleCandles({
    required List<String> symbols,
    String interval = '1day',
    int outputSize = 30,
  }) async {
    final apiKey = dotenv.env['TWELVEDATA_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('TWELVEDATA_API_KEY tidak ditemukan di file .env');
    }

    final symbolParam = symbols.join(',');
    final uri = Uri.parse(
      '$_baseUrl?symbol=$symbolParam&interval=$interval&outputsize=$outputSize&apikey=$apiKey',
    );

    debugPrint('📡 TwelveData request: $uri');

    final response = await http.get(uri);
    debugPrint('📡 TwelveData status: ${response.statusCode}');
    debugPrint('📡 TwelveData body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal fetch TwelveData (status: ${response.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final Map<String, List<PriceCandle>> result = {};

    if (symbols.length == 1 && data.containsKey('values')) {
      final symbol = symbols.first;
      result[symbol] = (data['values'] as List)
          .map((e) => PriceCandle.fromTwelveData(e))
          .toList();
      return result;
    }

    for (final symbol in symbols) {
      final entry = data[symbol];
      if (entry == null) {
        debugPrint('⚠️ Simbol $symbol tidak ada di respons');
        continue;
      }
      if (entry['status'] == 'error') {
        debugPrint('⚠️ Error untuk $symbol: ${entry['message']}');
        continue;
      }
      final values = entry['values'] as List?;
      if (values == null) continue;

      result[symbol] = values.map((e) => PriceCandle.fromTwelveData(e)).toList();
    }

    return result;
  }

  /// Ambil harga TERKINI (bukan historical candle) untuk beberapa simbol
  /// sekaligus dalam 1 request — dipakai buat kalkulator Emas Fisik
  /// (Gold spot + kurs USD/IDR sekaligus, multi-ticker).
  Future<Map<String, double>> fetchLatestPrices(List<String> symbols) async {
    final apiKey = dotenv.env['TWELVEDATA_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('TWELVEDATA_API_KEY tidak ditemukan di file .env');
    }

    final symbolParam = symbols.join(',');
    final uri = Uri.parse(
      'https://api.twelvedata.com/price?symbol=$symbolParam&apikey=$apiKey',
    );

    debugPrint('📡 TwelveData /price request: $uri');

    final response = await http.get(uri);
    debugPrint('📡 TwelveData /price body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil harga terkini (status: ${response.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final result = <String, double>{};

    if (symbols.length == 1 && data.containsKey('price')) {
      // Kalau cuma 1 simbol, respons formatnya beda: {"price": "..."} langsung
      result[symbols.first] = double.parse(data['price']);
      return result;
    }

    for (final symbol in symbols) {
      final entry = data[symbol];
      if (entry == null || entry['price'] == null) {
        debugPrint('⚠️ Harga untuk $symbol tidak ditemukan');
        continue;
      }
      result[symbol] = double.parse(entry['price']);
    }

    return result;
  }
}