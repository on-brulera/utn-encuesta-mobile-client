import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class EstudianteModel extends Estudiante {
  EstudianteModel(
      {required super.nombre,
      required super.cedula,
      required super.nota1,
      required super.nota2,
      required super.promedio});

  factory EstudianteModel.fromJson(Map<String, dynamic> json) =>
      EstudianteModel(
          nombre: json['per_nombres'],
          cedula: json['per_cedula'],
          nota1: json['Nota1'] ?? 0,
          nota2: json['Nota2'] ?? 0,
          promedio: (json['Nota1'] ?? 0 + json['Nota2'] ?? 0) / 2 );
}
