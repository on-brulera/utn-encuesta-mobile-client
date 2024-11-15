import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estilo.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/encuesta_model.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/estilo_model.dart';
import 'package:encuestas_utn/utils/configuration/connection/conn.dart';

class DocenteRepositoryImpl implements DocenteRepository {  

  //*PARA LA CREACIÓN DE ENCUESTAS */
  @override
  Future<Encuesta?> crearEncuesta(Encuesta encuesta, String token) async {
    try {
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
  Future<Estilo?> crearEstilo(Estilo estilo, String token) async{
    try {
      final response = await estilosAPI.post('/estilo',
          data: EstiloModel.toModel(estilo).toJson(),          
          options: addToken(token));
      if (response.statusCode == 201) {
        return EstiloModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
