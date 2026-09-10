// viewmodels/emas_fisik_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/emas_fisik_service.dart';
import '../services/market_data_service.dart';
import '../models/emas_fisik_model.dart';

class EmasFisikViewModel extends ChangeNotifier {
  final EmasFisikService _service;
  final MarketDataService _marketService;
  EmasFisikViewModel(this._service, this._marketService);

  bool isLoadingHarga = true;
  String? errorHarga;
  double? kursAwal;

  bool isLoading = false;
  String? errorMessage;
  EmasFisikModel? result;

  Future<void> muatHargaAwal() async {
    isLoadingHarga = true;
    errorHarga = null;
    notifyListeners();
    try {
      final harga = await _marketService.hargaTerkini(['USD/IDR']);
      kursAwal = harga['USD/IDR'];
    } catch (e) {
      errorHarga = 'Gagal memuat kurs terkini: $e';
    } finally {
      isLoadingHarga = false;
      notifyListeners();
    }
  }

  Future<void> hitung({
    required double hb,
    required double hj,
    required double kurs,
    required double modal,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      result = await _service.hitung(hb: hb, hj: hj, kurs: kurs, modal: modal);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}