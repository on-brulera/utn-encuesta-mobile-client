import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class EncuestaDetalles {
  final Encuesta encuesta;
  final List<PreguntaOpciones> preguntas;
  final List<Estilo> estilos;

  EncuestaDetalles(
      {required this.encuesta, required this.preguntas, required this.estilos});

  EncuestaDetalles copyWith(Encuesta? encuesta,
          List<PreguntaOpciones>? preguntas, List<Estilo>? estilos) =>
      EncuestaDetalles(
          encuesta: encuesta ?? this.encuesta,
          preguntas: preguntas ?? this.preguntas,
          estilos: estilos ?? this.estilos);
}

