class Respuesta {
  final int id;
  final int usuarioId;
  final int asignacionId;
  final int preguntaId;
  final int opcionId;
  final int respuestaValorCuantitativo;

  Respuesta(
      {this.id = 0,
      required this.usuarioId,
      required this.asignacionId,
      required this.preguntaId,
      required this.opcionId,
      required this.respuestaValorCuantitativo});

  Respuesta copyWith({
    int? id,
    int? usuarioId,
    int? asignacionId,
    int? preguntaId,
    int? opcionId,
    int? respuestaValorCuantitativo,
  }) =>
      Respuesta(
          id: id ?? this.id,
          usuarioId: usuarioId ?? this.usuarioId,
          asignacionId: asignacionId ?? this.asignacionId,
          preguntaId: preguntaId ?? this.preguntaId,
          opcionId: opcionId ?? this.opcionId,
          respuestaValorCuantitativo:
              respuestaValorCuantitativo ?? this.respuestaValorCuantitativo);
}
