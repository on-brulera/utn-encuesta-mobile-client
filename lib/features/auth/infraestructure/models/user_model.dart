import 'package:encuestas_utn/features/auth/domain/entities/user.dart';

class UserModel extends User {
  @override
  final String token;

  UserModel({
    required super.id,
    required super.usuario,
    required super.password,
    required super.rol,
    required this.token,
  });

  // Convierte el JSON de la API a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['usu_id'].toString(),
      usuario: json['usu_usuario'],
      password: json['usu_password'],
      rol: json['rol_codigo'],
      token: json['token'],
    );
  }
}
