import 'package:encuestas_utn/features/auth/domain/entities/estilo.dart';

class EstiloModel extends Estilo {
  EstiloModel(
      {required super.id,
      required super.encuestaId,
      required super.nombre,
      required super.descripcion,
      required super.parametro});

  factory EstiloModel.fromJson(Map<String, dynamic> json) => EstiloModel(
      id: int.tryParse(json['est_id'].toString()) ?? 0,
      encuestaId: int.tryParse(json['enc_id'].toString()) ?? 0,
      nombre: json['est_nombre'],
      descripcion: json['est_descripcion'] ?? '',
      parametro: json['est_parametro']);

  Map<String, dynamic> toJson() {
    return {
      "enc_id": encuestaId,
      "est_nombre": nombre,
      "est_descripcion": descripcion,
      "est_parametro": parametro
    };
  }

  static EstiloModel toModel(Estilo estilo) => EstiloModel(
      id: estilo.id,
      encuestaId: estilo.encuestaId,
      nombre: estilo.nombre,
      descripcion: estilo.descripcion,
      parametro: estilo.parametro);
}
