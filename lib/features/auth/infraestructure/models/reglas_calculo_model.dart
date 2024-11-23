import 'package:encuestas_utn/features/auth/domain/entities/reglas_calculo.dart';

class ReglasCalculoModel extends ReglasCalculo {
  ReglasCalculoModel(
      {required super.id,
      required super.encuestaId,
      required super.reglasJson});

  factory ReglasCalculoModel.fromJson(Map<String, dynamic> json) =>
      ReglasCalculoModel(
          id: json['reg_id'],
          encuestaId: json['enc_id'],
          reglasJson: json['reglas_json'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() {
    return {"enc_id": encuestaId, "reglas_json": reglasJson};
  }

  static ReglasCalculoModel toModel(ReglasCalculo regla) => ReglasCalculoModel(
      id: regla.id, encuestaId: regla.encuestaId, reglasJson: regla.reglasJson);
}
