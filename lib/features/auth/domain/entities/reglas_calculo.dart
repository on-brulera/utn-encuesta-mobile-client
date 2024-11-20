class ReglasCalculo {
  final int? id;
  final int encuestaId;
  final Map<String, dynamic> reglasJson;

  ReglasCalculo({
    this.id = 0,
    required this.encuestaId,
    required this.reglasJson,
  });

  ReglasCalculo copyWith({
    int? id,
    int? encuestaId,
    Map<String, dynamic>? reglasJson,
  }) =>
      ReglasCalculo(
          id: id ?? this.id,
          encuestaId: encuestaId ?? this.encuestaId,
          reglasJson: reglasJson ?? this.reglasJson);
}
