// services/news_service.dart
import '../core/api_client.dart';
import '../models/news_model.dart';

class NewsService {
  final ApiClient _client;
  NewsService(this._client);

  Future<List<NewsModel>> getNews() async {
    final res = await _client.get('/news');
    final list = res is List ? res : (res['results'] ?? []);
    return list.map<NewsModel>((e) => NewsModel.fromJson(e)).toList();
  }
}