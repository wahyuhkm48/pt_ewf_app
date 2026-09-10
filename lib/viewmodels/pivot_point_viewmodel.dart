// viewmodels/pivot_point_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/pivot_point_service.dart';
import '../models/pivot_point_model.dart';

class PivotPointViewModel extends ChangeNotifier {
  final PivotPointService _service;
  PivotPointViewModel(this._service);

  bool isLoading = false;
  String? errorMessage;
  PivotPointModel? result;

  Future<void> hitung({
    required String asset,
    required DateTime tanggal,
    double? open,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      result = await _service.hitung(asset: asset, tanggal: tanggal, open: open);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}