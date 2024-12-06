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
    required super.cedula,
    required super.cursoId,
  });

  // Convierte el JSON de la API a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['usu_id'].toString(),
      usuario: json['usu_usuario'],
      password: json['usu_password'],
      rol: json['rol_codigo'],
      token: json['token'] ?? 'Sin token',
      cedula: json['per_cedula'],
      cursoId: json['cur_id'],
    );
  }

  Map<String, dynamic> toJsonEstudiante() {
    return {
      "cur_id": cursoId,
      "per_cedula": cedula,
      "usu_usuario": 'E$cedula',
      "usu_password": 'E$cedula',
      "rol_codigo": 'EST',
      "usu_estado": false
    };
  }

  Map<String, dynamic> toJsonDocente() {
    return {
      "cur_id": cursoId,
      "per_cedula": cedula,
      "usu_usuario": 'D$cedula',
      "usu_password": password,
      "rol_codigo": 'DOC',
      "usu_estado": false
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "cur_id": cursoId,
      "per_cedula": cedula,
      "usu_usuario": usuario,
      "usu_password": password,
      "rol_codigo": rol,
      "usu_estado": true
    };
  }

  static UserModel toModel(User usuario) => UserModel(
      id: usuario.id,
      usuario: usuario.usuario,
      password: usuario.password,
      rol: usuario.rol,
      token: '',
      cedula: usuario.cedula,
      cursoId: usuario.cursoId);
}
