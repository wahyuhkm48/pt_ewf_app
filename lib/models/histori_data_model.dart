// models/histori_data_model.dart
class HistoriDataModel {
  final DateTime tanggal;
  final double open, high, low, close;

  HistoriDataModel({
    required this.tanggal,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  // dari HistoriDataResource versi 'flutter' -> key x/open/high/low/close
  factory HistoriDataModel.fromJson(Map<String, dynamic> json) => HistoriDataModel(
        tanggal: DateTime.parse(json['x'] ?? json['tanggal']),
        open: (json['open'] as num).toDouble(),
        high: (json['high'] as num).toDouble(),
        low: (json['low'] as num).toDouble(),
        close: (json['close'] as num).toDouble(),
      );
}