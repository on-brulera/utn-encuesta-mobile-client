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
      required this.parametro});
}
