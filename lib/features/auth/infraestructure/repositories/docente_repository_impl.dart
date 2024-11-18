import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/models.dart';
import 'package:encuestas_utn/utils/configuration/connection/conn.dart';

class DocenteRepositoryImpl implements DocenteRepository {
  //*PARA LA CREACIÓN DE ENCUESTAS */
  @override
  Future<Encuesta?> crearEncuesta(Encuesta encuesta, String token) async {
    try {
      if (encuesta.id != 0) {
        await estilosAPI.delete('/encuesta/delete/all/${encuesta.id}',
            options: addToken(token));
      }
      final response = await estilosAPI.post('/encuesta',
          data: EncuestaModel.toModel(encuesta).toJson(),
          options: addToken(token));
      if (response.statusCode == 201) {
        return EncuestaModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Estilo?> crearEstilo(Estilo estilo, String token) async {
    try {
      final response = await estilosAPI.post('/estilo',
          data: EstiloModel.toModel(estilo).toJson(), options: addToken(token));
      if (response.statusCode == 201) {
        return EstiloModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Pregunta?> crearPregunta(Pregunta pregunta, String token) async {
    try {
      final response = await estilosAPI.post('/pregunta',
          data: PreguntaModel.toModel(pregunta).toJson(),
          options: addToken(token));
      if (response.statusCode == 201) {
        return PreguntaModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Opcion?> crearOpcion(Opcion opcion, String token) async {
    try {
      final response = await estilosAPI.post('/opcion',
          data: OpcionModel.toModel(opcion).toJson(), options: addToken(token));
      if (response.statusCode == 201) {
        return OpcionModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Encuesta>?> obtenerAllEncuestas(String token) async {
    try {
      final response = await estilosAPI.get(
        '/encuesta',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        final List<dynamic> encuestasJson = response.data['data'];
        final encuestas =
            encuestasJson.map((json) => EncuestaModel.fromJson(json)).toList();

        return encuestas;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<EncuestaDetalles?> obtenerEncuestaDellates(
      String token, int encuestaId) async {
    try {
      final response = await estilosAPI.get(
        '/encuesta/detalles/$encuestaId',
        options: addToken(token),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final encuesta = EncuestaModel.fromJson(data);
        final preguntas = (data['preguntas'] as List).map((preguntaJson) {
          final pregunta = PreguntaModel.fromJson(preguntaJson);
          final opciones = (preguntaJson['opciones'] as List)
              .map((opcionJson) => OpcionModel.fromJson(opcionJson))
              .toList();
          return PreguntaOpciones(pregunta: pregunta, opciones: opciones);
        }).toList();

        final estilos = (data['estilos'] as List)
            .map((estiloJson) => EstiloModel.fromJson(estiloJson))
            .toList();

        return EncuestaDetalles(
            encuesta: encuesta, preguntas: preguntas, estilos: estilos);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool?> eliminarEncuesta(int idEncuesta, String token) async {
    try {
      final response = await estilosAPI.delete(
        '/encuesta/delete/all/$idEncuesta',
        options: addToken(token),
      );
      return response.statusCode == 204;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Curso?> crearCurso(Curso curso, String token) async {
    try {
      final response = await estilosAPI.post('/curso',
          data: CursoModel.toModel(curso).toJson(), options: addToken(token));
      if (response.statusCode == 201) {
        return CursoModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Curso>?> obtenerAllCurso(String token) async {
    try {
      final response = await estilosAPI.get(
        '/curso',
        options: addToken(token),
      );
      if (response.statusCode == 200) {
        final List<dynamic> cursosJson = response.data['data'];
        final cursos =
            cursosJson.map((json) => CursoModel.fromJson(json)).toList();

        return cursos;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
