import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estilo.dart';

abstract class DocenteRepository {
  //PARA LA CREACIÓN DE ENCUESTAS
  Future<Encuesta?> crearEncuesta(Encuesta encuesta, String token);

  Future<Estilo?> crearEstilo(Estilo estilo, String token);

  //PARA OBTENER LISTAS DE DATOS

  // Future<List<Encuesta>?> obtenerAllEncuestas();
}
