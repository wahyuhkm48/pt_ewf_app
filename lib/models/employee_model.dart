// models/employee_model.dart
class EmployeeModel {
  final String userId;
  final String namaLengkap;
  final String email;
  final String role;
  final String? foto;

  EmployeeModel({
    required this.userId,
    required this.namaLengkap,
    required this.email,
    required this.role,
    this.foto,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        userId: json['user_id'],
        namaLengkap: json['nama_lengkap'],
        email: json['email'],
        role: json['role'],
        foto: json['foto'],
      );
}