class Encuesta {
  final int id;
  final String titulo;
  final String descripcion;
  final String autor;
  final bool cuantitativa;
  final DateTime fechaCreacion;

  //atributoss que no estan en la entidad de la bdd
  final String fecha = '23-01-2024';
  final String curso = 'Curso A';
  final String parcial = 'Parcial 1';
  final int numPreguntas = 100;

  Encuesta({
    this.id = 0,
    this.titulo = '',
    this.descripcion = '',
    this.autor = '',
    this.cuantitativa = false,
    required this.fechaCreacion,
  });

  Encuesta copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    String? autor,
    bool? cuantitativa,
    DateTime? fechaCreacion,
  }) {
    return Encuesta(
      id: id?? this.id,
      titulo: titulo?? this.titulo,
      autor: autor?? this.autor,
      descripcion: descripcion?? this.descripcion,
      cuantitativa: cuantitativa?? this.cuantitativa,
      fechaCreacion: fechaCreacion?? this.fechaCreacion);
  }
}
