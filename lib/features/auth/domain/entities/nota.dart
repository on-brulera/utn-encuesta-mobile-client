class Nota {
  final int id;
  final int usuarioId;
  final int cursoId;
  final int materiaId;
  final int parcialId;
  final double nota;

  Nota(
      {this.id = 0,
      required this.usuarioId,
      required this.cursoId,
      required this.materiaId,
      required this.parcialId,
      required this.nota});

  Nota copyWith({
    int? id,
    int? usuarioId,
    int? cursoId,
    int? materiaId,
    int? parcialId,
    double? nota,
  }) =>
      Nota(
          id: id ?? this.id,
          usuarioId: usuarioId ?? this.usuarioId,
          cursoId: cursoId ?? this.cursoId,
          materiaId: materiaId ?? this.materiaId,
          parcialId: parcialId ?? this.parcialId,
          nota: nota ?? this.nota);
}
