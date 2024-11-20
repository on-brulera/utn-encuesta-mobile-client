import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class HistorialModel extends Historial {
  HistorialModel(
      {required super.id,
      required super.cursoId,
      required super.asignacionId,
      required super.estudianteCedula,
      required super.resultadoEncuesta,
      required super.notaEstudiante,
      required super.fechaEncuesta});

  factory HistorialModel.fromJson(Map<String, dynamic> json) => HistorialModel(
      id: json['his_id'],
      cursoId: json['cur_id'],
      asignacionId: json['asi_id'],
      estudianteCedula: json['est_cedula'],
      resultadoEncuesta: json['his_resultado_encuesta'],
      notaEstudiante: json['his_nota_estudiante'],
      fechaEncuesta: json['his_fecha_encuesta']);

  Map<String, dynamic> toJson() {
    return {
      'cur_id': cursoId,
      'asi_id': asignacionId,
      'est_cedula': estudianteCedula,
      'his_resultado_encuesta': resultadoEncuesta,
      'his_nota_estudiante': notaEstudiante,
      'his_fecha_encuesta': fechaEncuesta
    };
  }

  HistorialModel toModel(Historial historial) => HistorialModel(
      id: historial.id,
      cursoId: historial.cursoId,
      asignacionId: historial.asignacionId,
      estudianteCedula: historial.estudianteCedula,
      resultadoEncuesta: historial.resultadoEncuesta,
      notaEstudiante: historial.notaEstudiante,
      fechaEncuesta: historial.fechaEncuesta);
}
