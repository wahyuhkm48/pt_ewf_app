import 'package:flutter/foundation.dart';
import 'news_service.dart';
import '../models/news_article.dart';

/// Satu sumber data berita yang dipakai bersama oleh HomeScreen dan
/// HotNewsScreen, supaya keduanya selalu menampilkan data yang SAMA
/// dan sinkron satu sama lain.
class NewsRepository extends ChangeNotifier {
  NewsRepository._internal();
  static final NewsRepository instance = NewsRepository._internal();

  final NewsService _service = NewsService();

  List<NewsArticle>? _articles;
  bool _isLoading = false;
  Object? _error;

  List<NewsArticle>? get articles => _articles;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  /// Ambil data. Kalau sudah pernah ada (cache), tidak fetch ulang
  /// kecuali forceRefresh=true.
  Future<void> loadNews(String query, {bool forceRefresh = false}) async {
    if (_articles != null && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _service.fetchNews(query: query);
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners(); // ini yang bikin SEMUA screen yang "dengar" ikut update
    }
  }
}