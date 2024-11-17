class Pregunta {
  final int id;
  final int encuestaId;
  final int orden;
  final String enunciado;
  final int min;
  final int max;
  final double valorTotal;
  final String tipoPregunta;

  Pregunta(
      {this.id = 0,
      required this.encuestaId,
      required this.orden,
      required this.enunciado,
      this.min = 0,
      this.max = 0,
      this.valorTotal = 0,
      this.tipoPregunta = 'seleccion'});

  Pregunta copyWith({
    int? id,
    int? encuestaId,
    int? orden,
    String? enunciado,
    int? min,
    int? max,
    double? valorTotal,
    String? tipoPregunta,
  }) =>
      Pregunta(
          id: id ?? this.id,
          encuestaId: encuestaId ?? this.encuestaId,
          orden: orden ?? this.orden,
          enunciado: enunciado ?? this.enunciado,
          min: min ?? this.min,
          max: max ?? this.max,
          valorTotal: valorTotal ?? this.valorTotal);
}
