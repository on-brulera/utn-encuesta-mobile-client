import 'package:encuestas_utn/features/auth/domain/entities/estrategia.dart';

class EstrategiaModel extends Estrategia {
  EstrategiaModel(
      {required super.id,
      required super.cursoId,
      required super.cursoNivel,
      required super.encuestaId,
      required super.estiloId,
      required super.estrategia,
      required super.materiaId,
      required super.promedioNotas});

  factory EstrategiaModel.fromJson(Map<String, dynamic> json) =>
      EstrategiaModel(
          id: int.tryParse(json['estr_id'].toString()) ?? 0,
          cursoId: int.tryParse(json['cur_id'].toString()) ?? 0,
          cursoNivel: int.tryParse(json['cur_nivel'].toString()) ?? 0,
          encuestaId: int.tryParse(json['enc_id'].toString()) ?? 0,
          estiloId: int.tryParse(json['est_id'].toString()) ?? 0,
          estrategia: json['estr_estrategia'],
          materiaId: int.tryParse(json['mat_id'].toString()) ?? 0,
          promedioNotas: json['prom_notas']);

  Map<String, dynamic> toJson() {
    return {
      'cur_id': cursoId,
      'cur_nivel': cursoNivel,
      'enc_id': encuestaId,
      'est_id': estiloId,
      'estr_estrategia': estrategia,
      'mat_id': materiaId,
      'prom_notas': promedioNotas
    };
  }

  static EstrategiaModel toModel(Estrategia estrategia) => EstrategiaModel(
      id: estrategia.id,
      cursoId: estrategia.cursoId,
      cursoNivel: estrategia.cursoNivel,
      encuestaId: estrategia.encuestaId,
      estiloId: estrategia.estiloId,
      estrategia: estrategia.estrategia,
      materiaId: estrategia.materiaId,
      promedioNotas: estrategia.promedioNotas
      );
}
