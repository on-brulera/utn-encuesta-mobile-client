import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class PreguntaModel extends Pregunta {
  PreguntaModel({
    required super.id,
    required super.encuestaId,
    required super.orden,
    required super.enunciado,
    required super.min,
    required super.max,
    required super.valorTotal,
  });

  factory PreguntaModel.fromJson(Map<String, dynamic> json) => PreguntaModel(
      id: int.tryParse(json['pre_id'].toString()) ?? 0,
      encuestaId: int.tryParse(json['enc_id'].toString()) ?? 0,
      orden: int.tryParse(json['pre_orden'].toString()) ?? 0,
      enunciado: json['pre_enunciado'],
      min: int.tryParse(json['pre_num_respuestas_min'].toString()) ?? 0,
      max: int.tryParse(json['pre_num_respuestas_max'].toString()) ?? 0,
      valorTotal: json['pre_valor_total']);

  Map<String, dynamic> toJson() {
    return {
      "enc_id": encuestaId,
      "pre_orden": orden,
      "pre_enunciado": enunciado,
      "pre_num_respuestas_min": min,
      "pre_num_respuestas_max": max,
      "pre_valor_total": valorTotal,
      "pre_tipo_pregunta": tipoPregunta,
    };
  }

  static PreguntaModel toModel(Pregunta pregunta) => PreguntaModel(
      id: pregunta.id,
      encuestaId: pregunta.encuestaId,
      orden: pregunta.orden,
      enunciado: pregunta.enunciado,
      min: pregunta.min,
      max: pregunta.max,
      valorTotal: pregunta.valorTotal);
}
