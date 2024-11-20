class Asignacion {
  final int id;
  final int encuestaId;
  final int usuarioId;
  final int cursoId;
  final int materiaId;
  final String descripcion;
  final DateTime fechaCompletado;
  final bool realizado;
  final int usuIdAsignador;

  Asignacion(
      {this.id = 0,
      required this.encuestaId,
      required this.usuarioId,
      required this.cursoId,
      required this.materiaId,
      required this.descripcion,
      required this.fechaCompletado,
      required this.realizado,
      required this.usuIdAsignador});

  Asignacion copyWith({
    int? id,
    int? encuestaId,
    int? usuarioId,
    int? cursoId,
    int? materiaId,
    String? descripcion,
    DateTime? fechaCompletado,
    bool? realizado,
    int? usuIdAsignador
  }) =>
      Asignacion(
          id: id ?? this.id,
          encuestaId: encuestaId ?? this.encuestaId,
          usuarioId: usuarioId ?? this.usuarioId,
          cursoId: cursoId ?? this.cursoId,
          materiaId: materiaId ?? this.materiaId,
          descripcion: descripcion ?? this.descripcion,
          fechaCompletado: fechaCompletado ?? this.fechaCompletado,
          realizado: realizado ?? this.realizado,
          usuIdAsignador: usuIdAsignador??this.usuIdAsignador);
}
