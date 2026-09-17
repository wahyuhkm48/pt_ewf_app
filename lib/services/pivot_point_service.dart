// services/pivot_point_service.dart
import '../core/api_client.dart';
import '../models/pivot_point_model.dart';

class PivotPointService {
  final ApiClient _client;
  PivotPointService(this._client);

    Future<PivotPointModel> hitung({
    required String asset,
    required DateTime tanggal,
  }) async {
    final tanggalStr =
        '${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}';

    // Harga open sekarang diambil backend secara real-time dari live-quotes,
    // jadi tidak perlu dikirim manual dari sini lagi.
    final res = await _client.post('/pivot-point/hitung', {
      'asset': asset,
      'tanggal': tanggalStr,
    });
    return PivotPointModel.fromJson(res['data'] ?? res);
  }

  Future<List<PivotPointModel>> riwayat() async {
    final res = await _client.get('/pivot-point');
    final list = (res['data'] ?? res) as List;
    return list.map<PivotPointModel>((e) => PivotPointModel.fromJson(e)).toList();
  }
}