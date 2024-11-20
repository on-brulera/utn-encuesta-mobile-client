import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class CredencialesApiModel extends CredencialesApi {
  CredencialesApiModel(
      {required super.id,
      required super.nombreServicio,
      required super.apiKey});

  factory CredencialesApiModel.fromJson(Map<String, dynamic> json) =>
      CredencialesApiModel(
          id: json['cred_id'],
          nombreServicio: json['nombre_servicio'],
          apiKey: json['api_key']);

  Map<String, dynamic> toJson() {
    return {'nombre_servicio': nombreServicio, 'api_key': apiKey};
  }

  CredencialesApiModel toModel(CredencialesApi credencial) =>
      CredencialesApiModel(
          id: credencial.id,
          nombreServicio: credencial.nombreServicio,
          apiKey: credencial.apiKey);
}
