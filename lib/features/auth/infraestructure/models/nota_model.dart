import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class NotaModel extends Nota {
  NotaModel(
      {required super.id,
      required super.usuarioId,
      required super.cursoId,
      required super.materiaId,
      required super.parcialId,
      required super.nota});

  factory NotaModel.fromJson(Map<String, dynamic> json) => NotaModel(
      id: int.tryParse(json['not_id'].toString()) ?? 0,
      usuarioId: int.tryParse(json['usu_id'].toString()) ?? 0,
      cursoId: int.tryParse(json['cur_id'].toString()) ?? 0,
      materiaId: int.tryParse(json['mat_id'].toString()) ?? 0,
      parcialId: int.tryParse(json['par_id'].toString()) ?? 0,
      nota: json['not_nota'] ?? 0);

  Map<String, dynamic> toJson() {
    return {
      'usu_id': usuarioId,
      'cur_id': cursoId,
      'mat_id': materiaId,
      'par_id': parcialId,
      'not_nota': nota,
    };
  }

  static NotaModel toModel(Nota nota) => NotaModel(
      id: nota.id,
      usuarioId: nota.usuarioId,
      cursoId: nota.cursoId,
      materiaId: nota.materiaId,
      parcialId: nota.parcialId,
      nota: nota.nota);
}
