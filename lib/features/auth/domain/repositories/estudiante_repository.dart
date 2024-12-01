import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

abstract class EstudianteRepository {
  //OBTENER LISTAS DE DATOS
  Future<List<Asignacion>?> obtenerAsignacionDeEncuestaByEstudianteId(
      int idEstudiante, String token);

  Future<List<Curso>?> obtenerCursosByEstudianteId(
      int idEstudiante, String token);

  Future<List<Respuesta>?> obtenerRespuestaEncuestaByAsignacionId(
      int idAsignacion, String token);

  //CREACIÓN DE RESPUESTAS PARA EL TEST

  Future<Respuesta?> enviarRespuestasDeEncuesta(
      Respuesta respuesta, String token);

  Future<Asignacion?> marcarAsignacionTerminada(int idAsignacion, String token);

  Future<bool> calificarTestcalificarTest(
    String modelo,
    Map<String, dynamic> reglasJson,
    List<Map<String, dynamic>> respuestas,
    int idAsignacion,
    String cedulaEstudiante,
    String token,
  );

  Future<Historial?> obtenerResultadoTestEstudianteByAsignacionId(
      int idAsignacion, String token);

  Future<List<Materia>?> obtenerMateriasPorCurso(int idCurso, String token);
}
