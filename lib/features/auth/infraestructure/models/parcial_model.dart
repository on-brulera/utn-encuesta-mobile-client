import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class ParcialModel extends Parcial {
  ParcialModel({required super.id, required super.descripcion});

  factory ParcialModel.fromJson(Map<String, dynamic> json) =>
      ParcialModel(id: json['par_id'], descripcion: json['par_descripcion']);

  Map<String, dynamic> toJson() {
    return {"par_descripcion": descripcion};
  }

  ParcialModel toModel(Parcial parcial) =>
      ParcialModel(id: parcial.id, descripcion: parcial.descripcion);
}
