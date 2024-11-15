import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';

class EncuestaModel extends Encuesta {
  EncuestaModel(
      {required super.id,
      required super.titulo,
      required super.descripcion,
      required super.autor,
      required super.cuantitativa,
      required super.fechaCreacion});

  factory EncuestaModel.fromJson(Map<String, dynamic> json) => EncuestaModel(
      id: json['enc_id'],
      titulo: json['enc_titulo'],
      descripcion: json['enc_descripcion'],
      autor: json['enc_autor'],
      cuantitativa: json['enc_cuantitativa'],
      fechaCreacion: DateTime.parse(json['enc_fecha_creacion']));

  Map<String, dynamic> toJson() {
    return {
      "enc_titulo": titulo,
      "enc_descripcion": descripcion,
      "enc_autor": autor,
      "enc_cuantitativa": cuantitativa,
      "enc_fecha_creacion": fechaCreacion.toIso8601String(),
    };
  }

  static EncuestaModel toModel(Encuesta encuesta) => EncuestaModel(
      id: encuesta.id,
      titulo: encuesta.titulo,
      descripcion: encuesta.descripcion,
      autor: encuesta.autor,
      cuantitativa: encuesta.cuantitativa,
      fechaCreacion: encuesta.fechaCreacion);
}
