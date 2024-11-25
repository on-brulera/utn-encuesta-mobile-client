import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/models.dart';
import 'package:encuestas_utn/utils/configuration/connection/conn.dart';

class EstudianteRepositoryImpl implements EstudianteRepository {
  @override
  Future<List<Asignacion>?> obtenerAsignacionDeEncuestaByEstudianteId(
      int idEstudiante, String token) async {
    try {
      final response = await estilosAPI.get(
        '/asignacion/usuario/$idEstudiante',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        final List<dynamic> asignacionesJson = response.data['data'];
        List<Asignacion> asignaciones = asignacionesJson
            .map((asignacion) => AsignacionModel.fromJson(asignacion))
            .toList();
        return asignaciones;
      }
      if (response.statusCode == 404) return [];
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Curso>?> obtenerCursosByEstudianteId(
      int idEstudiante, String token) async {
    try {
      final response = await estilosAPI.get(
        '/curso/usuario/$idEstudiante',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        final List<dynamic> cursosJson = response.data['data'];
        final List<Curso> cursos =
            cursosJson.map((curso) => CursoModel.fromJson(curso)).toList();
        return cursos;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Respuesta>?> obtenerRespuestaEncuestaByAsignacionId(
      int idAsignacion, String token) async {
    try {
      final response = await estilosAPI.post(
        '/respuesta/asignacion/$idAsignacion',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        final List<dynamic> respuestasJson =
            response.data['data']['respuestas'];
        final List<Respuesta> respuestas = respuestasJson
            .map((curso) => RespuestaModel.fromJson(curso))
            .toList();
        return respuestas;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Respuesta?> enviarRespuestasDeEncuesta(
      Respuesta respuesta, String token) async {
    try {
      final response = await estilosAPI.post('/respuesta',
          data: RespuestaModel.toModel(respuesta).toJson(),
          options: addToken(token));
      if (response.statusCode == 201) {
        return RespuestaModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Asignacion?> marcarAsignacionTerminada(
      int idAsignacion, String token) async {
    try {
      final response = await estilosAPI.get(
          '/asignacion/usuario/terminada/$idAsignacion',
          options: addToken(token));
      if (response.statusCode == 200) {
        return AsignacionModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> calificarTestcalificarTest(
    String modelo,
    Map<String, dynamic> reglasJson,
    List<Map<String, dynamic>> respuestas,
    int idAsignacion,
    String cedulaEstudiante,
    String token,
  ) async {
    try {
      // Construir el JSON a enviar
      final Map<String, dynamic> jsonData = {
        "Modelo": modelo,
        "reglas_json": [reglasJson],
        "respuestas": respuestas,
        "idAsignacion": idAsignacion,
        "est_cedula": cedulaEstudiante,
      };

      // Enviar el JSON a la API
      final response = await estilosAPI.post(
        '/recalificar/app',
        data: jsonData,
        options: addToken(token),
      );

      // Verificar la respuesta
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Historial?> obtenerResultadoTestEstudianteByAsignacionId(
      int idAsignacion, String token) async {
    try {
      final Map<String, dynamic> jsonData = {
        "ids_asignacion": [idAsignacion],
      };

      final response = await estilosAPI.post(
        '/historial/asignacion',
        data: jsonData,
        options: addToken(token),
      );

      if (response.statusCode == 200) {
        return HistorialModel.fromJson(response.data['data'][0]);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
