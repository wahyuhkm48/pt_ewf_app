// lib/viewmodels/recent_history_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/recent_history_item.dart';
import '../services/emas_fisik_service.dart';
import '../services/nest_service.dart';
import '../services/pivot_point_service.dart';

class RecentHistoryViewModel extends ChangeNotifier {
  static const int maxItems = 5;

  final PivotPointService _pivot;
  final NestService _nest;
  final EmasFisikService _emas;
  RecentHistoryViewModel(this._pivot, this._nest, this._emas);

  bool isLoading = false;
  String? errorMessage;
  List<RecentHistoryItem> items = const [];

  int _requestId = 0; // response lama tidak boleh menimpa yang baru

  /// silent = true: list lama tetap tampil saat refresh (tanpa spinner).
  Future<void> load({bool silent = false}) async {
    final requestId = ++_requestId;

    if (!silent) {
      isLoading = true;
      items = const []; // supaya data akun sebelumnya tidak sempat tampil
    }
    errorMessage = null;
    notifyListeners();

    try {
      final (pivot, nest, emas) = await (
        _pivot.riwayat(),
        _nest.riwayat(),
        _emas.riwayat(),
      ).wait;

      if (requestId != _requestId) return;

      final merged = <RecentHistoryItem>[
        ...pivot.map(RecentPivot.new),
        ...nest.map(RecentNest.new),
        ...emas.map(RecentEmas.new),
      ]..sort((a, b) => b.sortKey.compareTo(a.sortKey));

      items = merged.take(maxItems).toList();
    } catch (e) {
      if (requestId != _requestId) return;
      errorMessage = e.toString();
    } finally {
      if (requestId == _requestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}