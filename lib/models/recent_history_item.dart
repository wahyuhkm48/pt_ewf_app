// lib/models/recent_history_item.dart
import 'emas_fisik_model.dart';
import 'nest_model.dart';
import 'pivot_point_model.dart';

final DateTime _epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

sealed class RecentHistoryItem {
  const RecentHistoryItem();
  DateTime get sortKey;
}

class RecentPivot extends RecentHistoryItem {
  final PivotPointModel data;
  const RecentPivot(this.data);

  @override
  DateTime get sortKey => data.createdAt ?? data.tanggal ?? _epoch;
}

class RecentNest extends RecentHistoryItem {
  final NestModel data;
  const RecentNest(this.data);

  @override
  DateTime get sortKey => data.createdAt ?? data.tanggal ?? _epoch;
}

class RecentEmas extends RecentHistoryItem {
  final EmasFisikModel data;
  const RecentEmas(this.data);

  @override
  DateTime get sortKey => data.tanggal ?? _epoch;
}