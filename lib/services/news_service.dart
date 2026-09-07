import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_article.dart';

/// Ambil berita dari NewsData.io berdasarkan query pencarian.
/// Dipakai bersama oleh HomeScreen & HotNewsScreen lewat NewsRepository.
class NewsService {
  static const String _baseUrl = 'https://newsdata.io/api/1/news';

  Future<List<NewsArticle>> fetchNews({
    required String query,
    String language = 'en',
  }) async {
    final apiKey = dotenv.env['NEWSDATA_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('NEWSDATA_API_KEY tidak ditemukan di file .env');
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'apikey': apiKey,
      'q': query,
      'language': language,
    });

    debugPrint('📡 NewsData request: $uri');

    final response = await http.get(uri);
    debugPrint('📡 NewsData status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil berita (status: ${response.statusCode})',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['status'] != 'success') {
      throw Exception('NewsData API error: ${data['message'] ?? 'unknown error'}');
    }

    final List<dynamic> results = data['results'] ?? [];
    return results.map((e) => NewsArticle.fromJson(e)).toList();
  }
}