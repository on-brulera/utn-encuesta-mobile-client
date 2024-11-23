class Encuesta {
  final int id;
  final String titulo;
  final String descripcion;
  final String autor;
  final bool cuantitativa;
  final DateTime fechaCreacion;

  //atributo para pocos,
  final int idAsignacion;
  final String fechaLimite;

  Encuesta({
    this.id = 0,
    this.titulo = '',
    this.descripcion = '',
    this.autor = '',
    this.cuantitativa = false,
    required this.fechaCreacion,
    this.idAsignacion = 0,
    this.fechaLimite ='',
  });

  Encuesta copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    String? autor,
    bool? cuantitativa,
    DateTime? fechaCreacion,
    int? idAsignacion,
    String? fechaLimite,
  }) {
    return Encuesta(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        autor: autor ?? this.autor,
        descripcion: descripcion ?? this.descripcion,
        cuantitativa: cuantitativa ?? this.cuantitativa,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        idAsignacion: idAsignacion?? this.idAsignacion,
        fechaLimite: fechaLimite??this.fechaLimite);
        
  }
}
