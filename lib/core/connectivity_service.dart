// core/connectivity_service.dart
import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class ConnectivityService extends ChangeNotifier with WidgetsBindingObserver {
  static const _host = 'pt-ewf-backend.vercel.app';

  bool _isOnline = true; // optimistis: dianggap online sampai terbukti sebaliknya
  bool _justReconnected = false;
  bool _checking = false;

  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _debounce;
  Timer? _retryTimer;
  Timer? _bannerTimer;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  /// true selama 3 detik setelah koneksi kembali (untuk strip hijau).
  bool get justReconnected => _justReconnected;

  Future<void> start() async {
    WidgetsBinding.instance.addObserver(this);
    _sub = Connectivity().onConnectivityChanged.listen((_) => _jadwalkanCek());
    await check();
  }

  // Event dari plugin tidak dijamin unik dan kadang berisik (terutama iOS),
  // jadi tunggu sebentar lalu cek sekali saja.
  void _jadwalkanCek() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), check);
  }

  /// Cek koneksi sungguhan: ada jaringan DAN server bisa dijangkau.
  Future<bool> check() async {
    if (_checking) return _isOnline;
    _checking = true;
    try {
      final adaJaringan = await _adaJaringan();
      final online = adaJaringan && await _serverTerjangkau();
      _setOnline(online);
    } finally {
      _checking = false;
    }
    return _isOnline;
  }

  Future<bool> _adaJaringan() async {
    try {
      final r = await Connectivity().checkConnectivity();
      return r.isNotEmpty && !r.every((e) => e == ConnectivityResult.none);
    } catch (_) {
      return true; // plugin gagal: jangan memblokir user, biar cek DNS yang menentukan
    }
  }

  Future<bool> _serverTerjangkau() async {
    try {
      final r = await InternetAddress.lookup(_host).timeout(const Duration(seconds: 4));
      return r.isNotEmpty && r.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _setOnline(bool value) {
    if (value == _isOnline) {
      if (!value) _mulaiCobaUlang();
      return;
    }

    _isOnline = value;
    if (value) {
      _retryTimer?.cancel();
      _retryTimer = null;
      _justReconnected = true;
      _bannerTimer?.cancel();
      _bannerTimer = Timer(const Duration(seconds: 3), () {
        _justReconnected = false;
        notifyListeners();
      });
    } else {
      _justReconnected = false;
      _bannerTimer?.cancel();
      _mulaiCobaUlang();
    }
    notifyListeners();
  }

  // Selama offline, cek ulang tiap 5 detik (event plugin bisa terlewat).
  void _mulaiCobaUlang() {
    _retryTimer ??= Timer.periodic(const Duration(seconds: 5), (_) => check());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    _debounce?.cancel();
    _retryTimer?.cancel();
    _bannerTimer?.cancel();
    super.dispose();
  }
}