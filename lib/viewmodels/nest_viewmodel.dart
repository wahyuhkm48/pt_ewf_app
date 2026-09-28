// viewmodels/nest_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/nest_service.dart';
import '../models/nest_model.dart';

class NestViewModel extends ChangeNotifier {
  final NestService _service;
  NestViewModel(this._service);

  bool isLoading = false;
  String? errorMessage;
  NestModel? result;

  void reset() {
    result = null;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> hitung({
    required String asset,
    required DateTime tanggal,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      result = await _service.hitung(asset: asset, tanggal: tanggal);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}