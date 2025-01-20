class Estrategia {
  final int id;
  final int estiloId;
  final int cursoId;
  final int cursoNivel;
  final String promedioNotas;
  final int encuestaId;
  final int materiaId;
  final String estrategia;

  Estrategia(
      {this.id = 0,
      required this.estiloId,
      required this.cursoId,
      required this.cursoNivel,
      required this.promedioNotas,
      required this.encuestaId,
      required this.materiaId,
      required this.estrategia});

  Estrategia copyWith({
    int? id,
    int? estiloId,
    int? cursoId,
    int? cursoNivel,
    String? promedioNotas,
    int? encuestaId,
    int? materiaId,
    String? estrategia,
  }) =>
      Estrategia(
          id: id ?? this.id,
          estiloId: estiloId ?? this.estiloId,
          cursoId: cursoId ?? this.cursoId,
          cursoNivel: cursoNivel ?? this.cursoNivel,
          promedioNotas: promedioNotas ?? this.promedioNotas,
          encuestaId: encuestaId ?? this.encuestaId,
          materiaId: materiaId ?? this.materiaId,
          estrategia: estrategia ?? this.estrategia);
}
