import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class AsignacionModel extends Asignacion {
  AsignacionModel(
      {required super.id,
      required super.encuestaId,
      required super.usuarioId,
      required super.cursoId,
      required super.materiaId,
      required super.descripcion,
      required super.fechaCompletado,
      required super.realizado});

  factory AsignacionModel.fromJson(Map<String, dynamic> json) =>
      AsignacionModel(
          id: int.tryParse(json['asi_id'].toString()) ?? 0,
          encuestaId: int.tryParse(json['enc_id'].toString()) ?? 0,
          usuarioId: int.tryParse(json['usu_id'].toString()) ?? 0,
          cursoId: int.tryParse(json['cur_id'].toString()) ?? 0,
          materiaId: int.tryParse(json['mat_id'].toString()) ?? 0,
          descripcion: json['asi_descripcion'] ?? 'Sin descripcion',
          fechaCompletado: DateTime.parse(json['asi_fecha_completado']),
          realizado: json['asi_realizado'] ?? false);

  Map<String, dynamic> toJson() {
    return {
      'enc_id': encuestaId,
      'usu_id': usuarioId,
      'cur_id': cursoId,
      'mat_id': materiaId,
      'asi_descripcion': descripcion,
      'asi_fecha_completado': fechaCompletado,
      'asi_realizado': realizado
    };
  }

  AsignacionModel toModel(Asignacion asignacion) => AsignacionModel(
      id: id,
      encuestaId: asignacion.encuestaId,
      usuarioId: asignacion.usuarioId,
      cursoId: asignacion.cursoId,
      materiaId: asignacion.materiaId,
      descripcion: asignacion.descripcion,
      fechaCompletado: asignacion.fechaCompletado,
      realizado: asignacion.realizado);
}
