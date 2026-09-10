// services/market_data_service.dart
import '../core/api_client.dart';

class MarketDataService {
  final ApiClient _client;
  MarketDataService(this._client);

  Future<Map<String, double>> hargaTerkini(List<String> symbols) async {
    final query = symbols.join(',');
    final res = await _client.get('/market/harga?symbols=$query');
    final map = (res['data'] ?? res) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}