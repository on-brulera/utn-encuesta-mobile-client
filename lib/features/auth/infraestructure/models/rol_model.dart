import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class RolModel extends Rol {
  RolModel(
      {required super.id, required super.nombre, required super.descripcion});

  factory RolModel.fromJson(Map<String, dynamic> json) => RolModel(
      id: json['rol_id'],
      nombre: json['rol_nombre'],
      descripcion: json['rol_descripcion']);

  Map<String, dynamic> toJson() {
    return {
      'rol_id': id,
      'rol_nombre': nombre,
      'rol_descripcion': descripcion,
    };
  }

  RolModel toModel(Rol rol) =>
      RolModel(id: rol.id, nombre: rol.nombre, descripcion: rol.descripcion);
}
