import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class OpcionModel extends Opcion {
  OpcionModel({
    required super.id,
    required super.preguntaId,
    required super.estiloId,
    required super.texto,
    required super.valorCualitativo,
    required super.valorCuantitativo,
  });

  factory OpcionModel.fromJson(Map<String, dynamic> json) => OpcionModel(
        id: int.tryParse(json['opc_id'].toString()) ?? 0,
        preguntaId: int.tryParse(json['pre_id'].toString()) ?? 0,
        estiloId: int.tryParse(json['est_id'].toString()) ?? 0,
        texto: json['opc_texto'] ?? '',
        valorCualitativo: json['valor_cualitativo'] ?? '',
        valorCuantitativo:
            double.tryParse(json['valor_cuantitativo']?.toString() ?? '0') ??
                0.0,
      );

  Map<String, dynamic> toJson() {
    return {
      "pre_id": preguntaId,
      "est_id": estiloId,
      "opc_texto": texto,
      "valor_cualitativo": valorCualitativo,
      "valor_cuantitativo": valorCuantitativo,
    };
  }

  static OpcionModel toModel(Opcion opcion) => OpcionModel(
        id: opcion.id,
        preguntaId: opcion.preguntaId,
        estiloId: opcion.estiloId,
        texto: opcion.texto,
        valorCualitativo: opcion.valorCualitativo,
        valorCuantitativo: opcion.valorCuantitativo,
      );
}