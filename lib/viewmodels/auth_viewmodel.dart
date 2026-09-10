// viewmodels/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/employee_model.dart';

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
      errorMessage = e.toString();
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
}