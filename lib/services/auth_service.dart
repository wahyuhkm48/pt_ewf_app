// services/auth_service.dart
import '../core/api_client.dart';
import '../models/employee_model.dart';

class AuthService {
  final ApiClient _client;
  AuthService(this._client);

  Future<EmployeeModel> login(String email, String password) async {
    final res = await _client.post('/login', {'email': email, 'password': password}, withAuth: false);
    await _client.saveToken(res['token']);
    return EmployeeModel.fromJson(res['employee']);
  }

  Future<void> logout() async {
    await _client.post('/logout', {});
    await _client.clearToken();
  }
}