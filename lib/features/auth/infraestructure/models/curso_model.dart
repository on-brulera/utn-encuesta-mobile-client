import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class CursoModel extends Curso {
  CursoModel(
      {required super.id,
      required super.carrera,
      required super.nivel,
      required super.periodoAcademico});

  factory CursoModel.fromJson(Map<String, dynamic> json) => CursoModel(
      id: int.tryParse(json['cur_id'].toString()) ?? 0,
      carrera: json['cur_carrera'],
      nivel: int.tryParse(json['cur_nivel'].toString()) ?? 0,
      periodoAcademico: json['cur_periodo_academico']);

  Map<String, dynamic> toJson() {
    return {
      'cur_carrera': carrera,
      'cur_nivel': nivel,
      'cur_periodo_academico': periodoAcademico
    };
  }

  static CursoModel toModel(Curso curso) => CursoModel(
      id: curso.id,
      carrera: curso.carrera,
      nivel: curso.nivel,
      periodoAcademico: curso.periodoAcademico);
}
