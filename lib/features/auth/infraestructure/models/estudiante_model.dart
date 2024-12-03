import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class EstudianteModel extends Estudiante {
  EstudianteModel(
      {required super.nombre,
      required super.cedula,
      required super.nota1,
      required super.nota2,
      required super.promedio,
      required super.nota1Id,
      required super.nota2Id,
      required super.usuarioId});

  factory EstudianteModel.fromJson(Map<String, dynamic> json) =>
      EstudianteModel(
          nombre: json['per_nombres'],
          cedula: json['per_cedula'],
          nota1: json['Nota1'] ?? 0,
          usuarioId: json['usu_id'] ?? 0,
          nota2: json['Nota2'] ?? 0,
          promedio: (json['Nota1'] ?? 0 + json['Nota2'] ?? 0) / 2,
          nota1Id: json['Nota1Id'] ?? 0,
          nota2Id: json['Nota2Id'] ?? 0);
}
