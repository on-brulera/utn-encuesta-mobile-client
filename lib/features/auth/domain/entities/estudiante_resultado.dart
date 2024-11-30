class EstudianteResultado {
  final int usuId;
  final String nombre;
  final int curId;
  final int matId;
  final int parId;
  final double notNota;
  final String hisResultadoEncuesta;

  EstudianteResultado({
    required this.usuId,
    required this.nombre,
    required this.curId,
    required this.matId,
    required this.parId,
    required this.notNota,
    required this.hisResultadoEncuesta,
  });

  factory EstudianteResultado.fromJson(Map<String, dynamic> json) {
    return EstudianteResultado(
      usuId: json['usu_id'],
      nombre: json['nombre'],
      curId: json['cur_id'],
      matId: json['mat_id'],
      parId: json['par_id'],
      notNota: (json['not_nota'] as num).toDouble(),
      hisResultadoEncuesta: json['his_resultado_encuesta'],
    );
  }
}