// viewmodels/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/employee_model.dart';
import '../utils/form_errors.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _service;
  AuthViewModel(this._service);

  bool isLoading = false;
  String? errorMessage;
  EmployeeModel? employee;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      employee = await _service.login(email, password);
      return true;
    } catch (e) {
      errorMessage = pesanError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String namaLengkap,
    required String email,
    required String noTelp,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      employee = await _service.register(
        namaLengkap: namaLengkap,
        email: email,
        noTelp: noTelp,
        password: password,
      );
      return true;
    } catch (e) {
      errorMessage = pesanError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    employee = null;
    notifyListeners();
  }

  Future<bool> updateProfile({String? namaLengkap, String? noTelp}) async {
    try {
      employee = await _service.updateProfile(namaLengkap: namaLengkap, noTelp: noTelp);
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = pesanError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFoto(List<int> bytes, String filename) async {
    try {
      employee = await _service.updateFoto(bytes, filename);
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = pesanError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _service.changePassword(currentPassword: currentPassword, newPassword: newPassword);
      return true;
    } catch (e) {
      errorMessage = pesanError(e);
      notifyListeners();
      return false;
    }
  }
}