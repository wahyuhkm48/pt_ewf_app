// models/pivot_point_model.dart
class PivotPointModel {
  final int id;
  final String? asset; // 'gold' | 'nikkei' | 'hangseng' | null (riwayat lama)
  final double? open;
  final double high;
  final double low;
  final double close;
  final double pivotPoint;
  final String? action; // 'buy' | 'sell' | 'netral' | null (riwayat lama)
  final List<double> resistance;
  final List<double> support;
  final List<Map<String, dynamic>>? chartPoints;
  final DateTime? tanggal;
  final DateTime? createdAt;

  PivotPointModel({
    required this.id,
    this.asset,
    this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.pivotPoint,
    this.action,
    required this.resistance,
    required this.support,
    this.chartPoints,
    this.tanggal,
    this.createdAt,
  });

  factory PivotPointModel.fromJson(Map<String, dynamic> json) => PivotPointModel(
        id: json['id'],
        asset: json['asset'],
        open: json['open'] != null ? (json['open'] as num).toDouble() : null,
        high: (json['high'] as num).toDouble(),
        low: (json['low'] as num).toDouble(),
        close: (json['close'] as num).toDouble(),
        pivotPoint: (json['pivot_point'] as num).toDouble(),
        action: json['action'],
        resistance: (json['resistance'] as List).map((e) => (e as num).toDouble()).toList(),
        support: (json['support'] as List).map((e) => (e as num).toDouble()).toList(),
        chartPoints: json['chart_points'] != null
            ? List<Map<String, dynamic>>.from(json['chart_points'])
            : null,
        tanggal: json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      );

  /// Urutan level dari atas ke bawah: R4, R3, R2, R1, PP, S1, S2, S3, S4
  List<double> get levelsTopToBottom => [
        resistance[3], resistance[2], resistance[1], resistance[0],
        pivotPoint,
        support[0], support[1], support[2], support[3],
      ];
}