import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class EncuestaDetalles {
  final Encuesta encuesta;
  final List<PreguntaOpciones> preguntas;
  final List<Estilo> estilos;
  final ReglasCalculo? reglasCalculo;
  final String? modelo;

  EncuestaDetalles(
      {required this.encuesta,
      required this.preguntas,
      required this.estilos,
      this.reglasCalculo,
      this.modelo});

  EncuestaDetalles copyWith(
          Encuesta? encuesta,
          List<PreguntaOpciones>? preguntas,
          List<Estilo>? estilos,
          String? modelo,
          ReglasCalculo? reglasCalculo) =>
      EncuestaDetalles(
          encuesta: encuesta ?? this.encuesta,
          preguntas: preguntas ?? this.preguntas,
          estilos: estilos ?? this.estilos,
          modelo: modelo ?? this.modelo,
          reglasCalculo: reglasCalculo??this.reglasCalculo,);
}
