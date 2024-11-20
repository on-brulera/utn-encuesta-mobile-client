import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class PromptModel extends Prompt {
  PromptModel(
      {required super.id, required super.titulo, required super.descripcion});

  factory PromptModel.fromJson(Map<String, dynamic> json) => PromptModel(
      id: json['pro_id'],
      titulo: json['pro_titulo'],
      descripcion: json['pro_descripcion']);

  Map<String, dynamic> toJson() {
    return {
      'pro_titulo': titulo,
      'pro_descripcion': descripcion,
    };
  }

  PromptModel toModel(Prompt prompt) => PromptModel(
      id: prompt.id, titulo: prompt.titulo, descripcion: prompt.descripcion);
}
