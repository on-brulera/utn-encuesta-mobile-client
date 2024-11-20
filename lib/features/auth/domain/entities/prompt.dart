class Prompt {
  final int id;
  final String titulo;
  final String descripcion;

  Prompt({this.id = 0, required this.titulo, required this.descripcion});

  Prompt copyWith({
    int? id,
    String? titulo,
    String? descripcion,
  }) =>
      Prompt(
          id: id ?? this.id,
          titulo: titulo ?? this.titulo,
          descripcion: descripcion ?? this.descripcion);
}
