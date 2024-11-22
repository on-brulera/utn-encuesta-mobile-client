
import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/models.dart';
import 'package:encuestas_utn/utils/configuration/connection/conn.dart';

class EstudianteRepositoryImpl implements EstudianteRepository{



  @override
  Future<Asignacion?> obtenerAsignacionDeEncuestaByEstudianteId(int idEstudiante, String token) async{    
    try {
      final response = await estilosAPI.get(
        '/asignacion/usuario/$idEstudiante',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        return AsignacionModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Curso?> obtenerCursosByEstudianteId(int idEstudiante, String token) async{
    try {
      final response = await estilosAPI.get(
        '/curso/usuario/$idEstudiante',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        return CursoModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}