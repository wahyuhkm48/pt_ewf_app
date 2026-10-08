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

    Future<EmployeeModel> register({
    required String namaLengkap,
    required String email,
    required String noTelp,
    required String password,
  }) async {
    final res = await _client.post('/register', {
      'nama_lengkap': namaLengkap,
      'email': email,
      'no_telp': noTelp,
      'password': password,
      'password_confirmation': password,
    }, withAuth: false);
    await _client.saveToken(res['token']);
    return EmployeeModel.fromJson(res['employee']);
  }

  Future<void> logout() async {
    await _client.post('/logout', {});
    await _client.clearToken();
  }

  Future<EmployeeModel> updateProfile({String? namaLengkap, String? noTelp}) async {
    final body = <String, dynamic>{};
    if (namaLengkap != null) body['nama_lengkap'] = namaLengkap;
    if (noTelp != null) body['no_telp'] = noTelp;

    final res = await _client.put('/profile', body);
    return EmployeeModel.fromJson(res['employee']);
  }

  Future<EmployeeModel> updateFoto(List<int> bytes, String filename) async {
    final res = await _client.postMultipart('/profile/foto', fieldName: 'foto', bytes: bytes, filename: filename);
    return EmployeeModel.fromJson(res['employee']);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.put('/profile/password', {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPassword,
    });
  }
}