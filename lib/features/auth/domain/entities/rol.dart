class Rol {
  final String id;
  final String nombre;
  final String descripcion;

  Rol({required this.id, required this.nombre, required this.descripcion});

  Rol copyWith({
    String? id,
    String? nombre,
    String? descripcion,
  }) =>
      Rol(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          descripcion: descripcion ?? this.descripcion);
}
