import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

abstract class EstudianteRepository {
  Future<Asignacion?> obtenerAsignacionDeEncuestaByEstudianteId(
      int idEstudiante, String token);

  Future<Curso?> obtenerCursosByEstudianteId(int idEstudiante, String token);
}
