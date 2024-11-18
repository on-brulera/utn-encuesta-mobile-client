class Curso {
  final int id;
  final String carrera;
  final int nivel;
  final String periodoAcademico;

  Curso(
      {this.id = 0,
      required this.carrera,
      required this.nivel,
      required this.periodoAcademico});

  Curso copyWith({
    int? id,
    String? carrera,
    int? nivel,
    String? periodoAcademico,
  }) =>
      Curso(
          id: id ?? this.id,
          carrera: carrera ?? this.carrera,
          nivel: nivel ?? this.nivel,
          periodoAcademico: periodoAcademico ?? this.periodoAcademico);
}
