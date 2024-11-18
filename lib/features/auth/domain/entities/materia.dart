class Materia {
  final int id;
  final String nombre;
  final String descripcion;

  Materia({this.id = 0, required this.nombre, required this.descripcion});

  Materia copyWith({
    int? id,
    String? nombre,
    String? descripcion,
  }) =>
      Materia(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          descripcion: descripcion ?? this.descripcion);
}
