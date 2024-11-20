import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

abstract class DocenteRepository {
  //PARA LA CREACIÓN DE ENCUESTAS
  Future<Encuesta?> crearEncuesta(Encuesta encuesta, String token);

  Future<Estilo?> crearEstilo(Estilo estilo, String token);

  Future<Pregunta?> crearPregunta(Pregunta pregunta, String token);

  Future<Opcion?> crearOpcion(Opcion opcion, String token);

  Future<bool?> eliminarEncuesta(int idEncuesta, String token);

  //PARA LA CREACIÓN DE CURSOS

  Future<Curso?> crearCurso(Curso curso, String token);

  //PARA LA CREACION DE PERSONAS

  Future<Persona?> crearPersona(Persona persona, String token);

  Future<User?> crearEstudiante(User usuario, String token);

  //PARA LA CREACIÓN DE ASIGNACIONES

  Future<Asignacion?> crearAsignacion(Asignacion asignacion, String token);

  //PARA LA CREACIÓN DE NOTAS

  Future<Nota?> crearActualizarNota(Nota nota, String token);

  //PARA OBTENER LISTAS DE DATOS

  Future<List<Encuesta>?> obtenerAllEncuestas(String token);

  Future<List<Curso>?> obtenerAllCurso(String token);

  Future<List<Materia>?> obtenerAllMateria(String token);

  Future<List<Parcial>?> obtenerAllParcial( String token);

  Future<EncuestaDetalles?> obtenerEncuestaDellates(
      String token, int encuestaId);
  
  //OBTENER DATOS POR IDENTIFICADOR

  Future<User?> obtenerUsuarioByCedula(String cedula, String token);  

  Future<List<AsignacionDetalles>?> obtenerAsignacionesByDocenteId(int docenteId, String token);

  Future<Asignacion?> obtenerAsignacionByEncuestaId(int encuestaId, String token);

}
