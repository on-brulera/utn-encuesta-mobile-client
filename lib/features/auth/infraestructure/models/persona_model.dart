import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class PersonaModel extends Persona {
  PersonaModel({required super.cedula, required super.nombres});

  factory PersonaModel.fromJson(Map<String, dynamic> json) =>
      PersonaModel(cedula: json['per_cedula'], nombres: json['per_nombres']);

  Map<String, dynamic> toJson() {
    return {'per_cedula': cedula, 'per_nombres': nombres};
  }

  PersonaModel toModel(Persona persona) =>
      PersonaModel(cedula: persona.cedula, nombres: persona.nombres);
}
