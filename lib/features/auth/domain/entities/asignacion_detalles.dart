class AsignacionDetalles {
  final int encId;
  final String encTitulo;
  final int curId;
  final String curCarrera;
  final int curNivel;
  final String curPeriodoAcademico;
  final String matNombre;
  final int matId;
  final int parId;

  AsignacionDetalles(
      {required this.encId,
      required this.encTitulo,
      required this.curId,
      required this.curCarrera,
      required this.curNivel,
      required this.curPeriodoAcademico,
      required this.matNombre,
      required this.matId,
      required this.parId});

  AsignacionDetalles copyWith({
    int? encId,
    String? encTitulo,
    int? curId,
    String? curCarrera,
    int? curNivel,
    String? curPeriodoAcademico,
    String? matNombre,
    int? matId,
    int? parId,
  }) =>
      AsignacionDetalles(
          encId: encId ?? this.encId,
          encTitulo: encTitulo ?? this.encTitulo,
          curId: curId ?? this.curId,
          curCarrera: curCarrera ?? this.curCarrera,
          curNivel: curNivel ?? this.curNivel,
          curPeriodoAcademico: curPeriodoAcademico ?? this.curPeriodoAcademico,
          matNombre: matNombre ?? this.matNombre,
          matId: matId ?? this.matId,
          parId: parId ?? this.parId);
}
