// models/nest_model.dart
class NestModel {
  final int id;
  final String asset;
  final double? open;
  final double close;
  final String action; // 'buy' | 'sell' | 'netral'
  final DateTime? tanggal;

  NestModel({
    required this.id,
    required this.asset,
    this.open,
    required this.close,
    required this.action,
    this.tanggal,
  });

  factory NestModel.fromJson(Map<String, dynamic> json) => NestModel(
        id: json['id'],
        asset: json['asset'],
        open: json['open'] != null ? (json['open'] as num).toDouble() : null,
        close: (json['close'] as num).toDouble(),
        action: json['action'],
        tanggal: json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
      );
}