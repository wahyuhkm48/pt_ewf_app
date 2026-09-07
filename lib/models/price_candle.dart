class PriceCandle {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  PriceCandle({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory PriceCandle.fromTwelveData(Map<String, dynamic> json) {
    return PriceCandle(
      date: DateTime.parse(json['datetime']),
      open: double.parse(json['open']),
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      close: double.parse(json['close']),
    );
  }
}