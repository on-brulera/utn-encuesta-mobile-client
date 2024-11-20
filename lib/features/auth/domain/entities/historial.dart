class Historial {
  final int id;
  final int cursoId;
  final int asignacionId;
  final String estudianteCedula;
  final String resultadoEncuesta;
  final String notaEstudiante;
  final DateTime fechaEncuesta;

  Historial(
      {this.id = 0,
      required this.cursoId,
      required this.asignacionId,
      required this.estudianteCedula,
      required this.resultadoEncuesta,
      required this.notaEstudiante, 
      required this.fechaEncuesta});

  Historial copyWith({
    int? id,
    int? cursoId,
    int? asignacionId,
    String? estudianteCedula,
    String? resultadoEncuesta,
    String? notaEstudiante,
    DateTime? fechaEncuesta,
  }) =>
      Historial(
          id: id ?? this.id,
          cursoId: cursoId ?? this.cursoId,
          asignacionId: asignacionId ?? this.asignacionId,
          estudianteCedula: estudianteCedula ?? this.estudianteCedula,
          resultadoEncuesta: resultadoEncuesta ?? this.resultadoEncuesta,
          notaEstudiante: notaEstudiante ?? this.notaEstudiante,
          fechaEncuesta: fechaEncuesta??this.fechaEncuesta);
}
