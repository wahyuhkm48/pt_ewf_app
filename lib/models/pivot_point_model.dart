// models/pivot_point_model.dart
class PivotPointModel {
  final int id;
  final double? open;
  final double high;
  final double low;
  final double close;
  final double pivotPoint;
  final List<double> resistance;
  final List<double> support;
  final List<Map<String, dynamic>>? chartPoints;
  final DateTime? tanggal;

  PivotPointModel({
    required this.id,
    this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.pivotPoint,
    required this.resistance,
    required this.support,
    this.chartPoints,
    this.tanggal,
  });

  factory PivotPointModel.fromJson(Map<String, dynamic> json) => PivotPointModel(
        id: json['id'],
        open: json['open'] != null ? (json['open'] as num).toDouble() : null,
        high: (json['high'] as num).toDouble(),
        low: (json['low'] as num).toDouble(),
        close: (json['close'] as num).toDouble(),
        pivotPoint: (json['pivot_point'] as num).toDouble(),
        resistance: (json['resistance'] as List).map((e) => (e as num).toDouble()).toList(),
        support: (json['support'] as List).map((e) => (e as num).toDouble()).toList(),
        chartPoints: json['chart_points'] != null
            ? List<Map<String, dynamic>>.from(json['chart_points'])
            : null,
        tanggal: json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
      );

  /// Urutan level dari atas ke bawah: R4, R3, R2, R1, PP, S1, S2, S3, S4
  List<double> get levelsTopToBottom => [
        resistance[3], resistance[2], resistance[1], resistance[0],
        pivotPoint,
        support[0], support[1], support[2], support[3],
      ];
}