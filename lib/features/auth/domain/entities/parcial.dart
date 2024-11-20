class Parcial {
  final int id;
  final String descripcion;

  Parcial({this.id = 0, required this.descripcion});

  Parcial copyWith({
    int? id,
    String? descripcion,
  }) =>
      Parcial(id: id ?? this.id, descripcion: descripcion ?? this.descripcion);
}
