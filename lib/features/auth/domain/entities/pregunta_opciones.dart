import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

class PreguntaOpciones {
  final Pregunta pregunta;
  final List<Opcion> opciones;
  PreguntaOpciones({required this.pregunta, required this.opciones});

  PreguntaOpciones copyWith({Pregunta? pregunta, List<Opcion>? opciones}) =>
      PreguntaOpciones(
          pregunta: pregunta ?? this.pregunta,
          opciones: opciones ?? this.opciones);
}
