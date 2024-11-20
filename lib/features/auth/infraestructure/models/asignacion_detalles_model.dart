import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class AsignacionDetallesModel extends AsignacionDetalles {
  AsignacionDetallesModel(
      {required super.encId,
      required super.encTitulo,
      required super.curId,
      required super.curCarrera,
      required super.curNivel,
      required super.curPeriodoAcademico,
      required super.matNombre,
      required super.matId,
      required super.parId});

  factory AsignacionDetallesModel.fromJson(Map<String, dynamic> json) =>
      AsignacionDetallesModel(
          encId: json['enc_id'],
          encTitulo: json['enc_titulo'],
          curId: json['cur_id'],
          curCarrera: json['cur_carrera'],
          curNivel: json['cur_nivel'],
          curPeriodoAcademico: json['cur_periodo_academico'],
          matNombre: json['mat_nombre'],
          matId: json['mat_id'],
          parId: json['par_id']);

  static AsignacionDetallesModel toModel(AsignacionDetalles asignacion) =>
      AsignacionDetallesModel(
          encId: asignacion.encId,
          encTitulo: asignacion.encTitulo,
          curId: asignacion.curId,
          curCarrera: asignacion.curCarrera,
          curNivel: asignacion.curNivel,
          curPeriodoAcademico: asignacion.curPeriodoAcademico,
          matNombre: asignacion.matNombre,
          matId: asignacion.matId,
          parId: asignacion.parId);
}
