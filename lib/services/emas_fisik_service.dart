// services/emas_fisik_service.dart
import '../core/api_client.dart';
import '../models/emas_fisik_model.dart';

class EmasFisikService {
  final ApiClient _client;
  EmasFisikService(this._client);

  Future<EmasFisikModel> hitung({
    required double hb,
    required double hj,
    required double kurs,
    required double modal,
  }) async {
    final res = await _client.post('/emas-fisik/hitung', {
      'hb': hb,
      'hj': hj,
      'kurs': kurs,
      'modal': modal,
    });
    return EmasFisikModel.fromJson(res['data'] ?? res);
  }

  Future<List<EmasFisikModel>> riwayat() async {
    final res = await _client.get('/emas-fisik');
    final list = (res['data'] ?? res) as List;
    return list.map<EmasFisikModel>((e) => EmasFisikModel.fromJson(e)).toList();
  }
}