class Estilo {
  final int id;
  final int encuestaId;
  final String nombre;
  final String descripcion;
  final bool parametro;

  Estilo(
      {this.id = 0,
      required this.encuestaId,
      required this.nombre,
      required this.descripcion,
      this.parametro = false});

  Estilo copyWith({
    int? id,
    int? encuestaId,
    String? nombre,
    String? descripcion,
    bool? parametro,
  }) =>
      Estilo(
          id: id ?? this.id,
          encuestaId: encuestaId ?? this.encuestaId,
          nombre: nombre ?? this.nombre,
          descripcion: descripcion ?? this.descripcion,
          parametro: parametro?? this.parametro);
}
