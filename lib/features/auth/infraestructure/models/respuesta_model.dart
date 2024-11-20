import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class RespuestaModel extends Respuesta {
  RespuestaModel(
      {required super.id,
      required super.usuarioId,
      required super.asignacionId,
      required super.preguntaId,
      required super.opcionId,
      required super.respuestaValorCuantitativo});

  factory RespuestaModel.fromJson(Map<String, dynamic> json) => RespuestaModel(
      id: json['res_id'],
      usuarioId: json['usu_id'],
      asignacionId: json['asi_id'],
      preguntaId: json['pre_id'],
      opcionId: json['opc_id'],
      respuestaValorCuantitativo: json['res_valor_cuantitativo']);

  Map<String, dynamic> toJson() {
    return {
      'usu_id': usuarioId,
      'asi_id': asignacionId,
      'pre_id': preguntaId,
      'opc_id': opcionId,
      'res_valor_cuantitativo': respuestaValorCuantitativo,
    };
  }

  RespuestaModel toModel(Respuesta respuesta) => RespuestaModel(
      id: respuesta.id,
      usuarioId: respuesta.usuarioId,
      asignacionId: respuesta.asignacionId,
      preguntaId: respuesta.preguntaId,
      opcionId: respuesta.opcionId,
      respuestaValorCuantitativo: respuesta.respuestaValorCuantitativo);
}
