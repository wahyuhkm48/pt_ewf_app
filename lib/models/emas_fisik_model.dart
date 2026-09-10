// models/emas_fisik_model.dart
class EmasFisikModel {
  final int id;
  final double hhb;
  final double hhj;
  final double selisih;
  final double profit;
  final double beratGram;
  final DateTime? tanggal;

  EmasFisikModel({
    required this.id,
    required this.hhb,
    required this.hhj,
    required this.selisih,
    required this.profit,
    required this.beratGram,
    this.tanggal,
  });

  // Helper: bisa terima int, double, ATAU String dari backend, tetap aman
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  factory EmasFisikModel.fromJson(Map<String, dynamic> json) => EmasFisikModel(
        id: json['id'] is String ? int.parse(json['id']) : json['id'],
        hhb: _toDouble(json['hhb']),
        hhj: _toDouble(json['hhj']),
        selisih: _toDouble(json['selisih']),
        profit: _toDouble(json['profit']),
        beratGram: _toDouble(json['berat_gram']),
        tanggal: json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
      );
}