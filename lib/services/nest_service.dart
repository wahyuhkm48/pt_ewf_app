// services/nest_service.dart
import '../core/api_client.dart';
import '../models/nest_model.dart';

class NestService {
  final ApiClient _client;
  NestService(this._client);

  Future<NestModel> hitung({
    required String asset,
    required DateTime tanggal,
  }) async {
    final tanggalStr =
        '${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}';

    final res = await _client.post('/nest/hitung', {
      'asset': asset,
      'tanggal': tanggalStr,
    });
    return NestModel.fromJson(res['data'] ?? res);
  }

  Future<List<NestModel>> riwayat() async {
    final res = await _client.get('/nest');
    final list = (res['data'] ?? res) as List;
    return list.map<NestModel>((e) => NestModel.fromJson(e)).toList();
  }
}