// viewmodels/histori_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/histori_service.dart';
import '../models/histori_data_model.dart';

class HistoriViewModel extends ChangeNotifier {
  final HistoriService _service;
  HistoriViewModel(this._service);

  final Map<int, List<HistoriDataModel>> _cache = {};
  bool isLoading = false;
  String? errorMessage;

  List<HistoriDataModel> forTab(int index) => _cache[index] ?? [];
  bool hasData(int index) => _cache.containsKey(index);

  Future<void> loadTab(int index, {bool forceRefresh = false}) async {
    if (_cache.containsKey(index) && !forceRefresh) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      switch (index) {
        case 0:
          _cache[0] = await _service.gold();
          break;
        case 1:
          _cache[1] = await _service.nikkei();
          break;
        case 2:
          _cache[2] = await _service.hangseng();
          break;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}