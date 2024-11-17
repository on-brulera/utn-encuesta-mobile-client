import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

abstract class DocenteRepository {
  //PARA LA CREACIÓN DE ENCUESTAS
  Future<Encuesta?> crearEncuesta(Encuesta encuesta, String token);

  Future<Estilo?> crearEstilo(Estilo estilo, String token);

  Future<Pregunta?> crearPregunta(Pregunta pregunta, String token);

  Future<Opcion?> crearOpcion(Opcion opcion, String token);

  Future<bool?> eliminarEncuesta(int idEncuesta ,String token);

  //PARA OBTENER LISTAS DE DATOS

  Future<List<Encuesta>?> obtenerAllEncuestas(String token);

  Future<EncuestaDetalles?> obtenerEncuestaDellates(
      String token, int encuestaId);
}
