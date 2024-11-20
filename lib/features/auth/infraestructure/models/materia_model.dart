import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class MateriaModel extends Materia {
  MateriaModel(
      {required super.id, required super.nombre, required super.descripcion});

  factory MateriaModel.fromJson(Map<String, dynamic> json) => MateriaModel(
      id: int.tryParse(json['mat_id'].toString()) ?? 0,
      nombre: json['mat_nombre'],
      descripcion: json['mat_descripcion'] ?? 'Sin descripción');

  Map<String, dynamic> toJson() {
    return {
      'map_nombre': nombre,
      'mat_descripcion': descripcion,
    };
  }

  static MateriaModel toModel(Materia materia) => MateriaModel(
      id: materia.id, nombre: materia.nombre, descripcion: materia.descripcion);
}
