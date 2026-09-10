// services/pivot_point_service.dart
import '../core/api_client.dart';
import '../models/pivot_point_model.dart';

class PivotPointService {
  final ApiClient _client;
  PivotPointService(this._client);

  Future<PivotPointModel> hitung({
    required String asset,
    required DateTime tanggal,
    double? open,
  }) async {
    final tanggalStr =
        '${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}';

    final res = await _client.post('/pivot-point/hitung', {
      'asset': asset,
      'tanggal': tanggalStr,
      'open': ?open,  // Hanya masuk ke map jika open != null
    });
    return PivotPointModel.fromJson(res['data'] ?? res);
  }

  Future<List<PivotPointModel>> riwayat() async {
    final res = await _client.get('/pivot-point');
    final list = (res['data'] ?? res) as List;
    return list.map<PivotPointModel>((e) => PivotPointModel.fromJson(e)).toList();
  }
}