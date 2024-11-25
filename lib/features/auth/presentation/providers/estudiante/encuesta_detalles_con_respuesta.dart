import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/estudiante_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:encuestas_utn/utils/modelos_to_json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';

// Modelo del estado
class EncuestaDetallesConRespuestaState {
  final bool isLoading;
  final EncuestaDetalles? detalles;
  final List<Respuesta>? respuestas;
  final List<Respuesta>? respuestasEstudiante;
  final String? error;
  final bool isSubmitting;

  EncuestaDetallesConRespuestaState(
      {this.isLoading = false,
      this.detalles,
      this.error,
      this.respuestas,
      this.respuestasEstudiante,
      this.isSubmitting = false});

  EncuestaDetallesConRespuestaState copyWith({
    bool? isLoading,
    EncuestaDetalles? detalles,
    String? error,
    List<Respuesta>? respuestas,
    List<Respuesta>? respuestasEstudiante,
    bool? isSubmitting,
  }) {
    return EncuestaDetallesConRespuestaState(
        isLoading: isLoading ?? this.isLoading,
        detalles: detalles ?? this.detalles,
        error: error,
        respuestas: respuestas ?? this.respuestas,
        respuestasEstudiante: respuestasEstudiante ?? this.respuestasEstudiante,
        isSubmitting: isSubmitting ?? this.isSubmitting);
  }
}

// Clase Notifier
class EncuestaDetallesConRespuestaNotifier
    extends StateNotifier<EncuestaDetallesConRespuestaState> {
  final DocenteRepositoryImpl docenteRepository;
  final EstudianteRepository estudianteRepository;
  final String token;
  final String cedula;

  EncuestaDetallesConRespuestaNotifier(
      {required this.docenteRepository,
      required this.token,
      required this.cedula,
      required this.estudianteRepository})
      : super(EncuestaDetallesConRespuestaState());

  Future<void> obtenerEncuestaDetalles(int idEncuesta, int idAsignacion) async {
    state = state.copyWith(isLoading: true, error: null, detalles: null);
    try {
      final detalles =
          await docenteRepository.obtenerEncuestaDellates(token, idEncuesta);
      final respuestas = await estudianteRepository
          .obtenerRespuestaEncuestaByAsignacionId(idAsignacion, token);

      if (detalles != null) {
        state = state.copyWith(
            isLoading: false,
            detalles: detalles,
            respuestas: respuestas,
            respuestasEstudiante: []);
      } else {
        state = state.copyWith(
            isLoading: false, error: 'No se pudieron obtener los detalles.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener los detalles de la encuesta: $e');
    }
  }

  Future<void> enviarRespuestaEncuesta(int idAsignacion) async {
    try {
      state = state.copyWith(isSubmitting: true);
      final respuestas = state.respuestasEstudiante!.map((respuesta) async {
        return await estudianteRepository.enviarRespuestasDeEncuesta(
            respuesta, token);
      }).toList();
      await estudianteRepository.marcarAsignacionTerminada(idAsignacion, token);

      List<PreguntaOpciones> listaJson = prepararListaParaJson();
      List<Map<String, dynamic>> jsonRespuestasEstudiante = [];
      if (state.detalles!.modelo == 'Modelo1') {
        jsonRespuestasEstudiante =
            generarRespuestasModelo1Jso1n(preguntasConOpciones: listaJson);
      }
      if (state.detalles!.modelo == 'Modelo2') {
        jsonRespuestasEstudiante =
            generarRespuestasModelo2Json(preguntasConOpciones: listaJson);
      }
      if (state.detalles!.modelo == 'Modelo3') {
        jsonRespuestasEstudiante =
            generarRespuestasModelo3Json(preguntasConOpciones: listaJson);
      }

      await estudianteRepository.calificarTestcalificarTest(
          state.detalles!.modelo!,
          state.detalles!.reglasCalculo!.reglasJson,
          jsonRespuestasEstudiante,
          idAsignacion,
          cedula,
          token);

      if (respuestas.isNotEmpty) {
        state = state.copyWith(respuestasEstudiante: [], isSubmitting: false);
      } else {
        state = state.copyWith(
            error: 'No se pudieron enviar las respuestas.',
            isSubmitting: false);
      }
    } catch (e) {
      state = state.copyWith(
          error: 'Error al enviar los respuestas de la encuesta: $e',
          isSubmitting: false);
    }
  }

  List<PreguntaOpciones> prepararListaParaJson() {
    List<PreguntaOpciones> preguntasJson = [];

    for (PreguntaOpciones preguntaOpcion in state.detalles!.preguntas) {
      List<Opcion> opciones = [];
      for (Respuesta respuesta in state.respuestasEstudiante!) {
        if (preguntaOpcion.pregunta.id == respuesta.preguntaId) {
          opciones.add(preguntaOpcion.opciones
              .where((opc) => opc.preguntaId == respuesta.preguntaId)
              .first);
        }
      }
      preguntasJson.add(preguntaOpcion.copyWith(opciones: opciones));
    }
    return preguntasJson;
  }

  void cargarNuevaEncuesta(int idEncuesta, int idAsignacion) {
    state = EncuestaDetallesConRespuestaState(); // Limpia el estado anterior
    obtenerEncuestaDetalles(idEncuesta, idAsignacion);
  }

  void limpiarEstado() {
    state = EncuestaDetallesConRespuestaState();
  }

  void seleccionarRespuesta(Respuesta nuevaRespuesta) {
    final respuestasActuales = state.respuestasEstudiante ?? [];
    // Remover cualquier respuesta previa para la misma pregunta
    final respuestasFiltradas = respuestasActuales
        .where((respuesta) => respuesta.preguntaId != nuevaRespuesta.preguntaId)
        .toList();
    // Agregar la nueva respuesta
    respuestasFiltradas.add(nuevaRespuesta);
    // Actualizar el estado con las nuevas respuestas
    state = state.copyWith(respuestasEstudiante: respuestasFiltradas);
  }
}

// Provider
final encuestaDetallesConRespuestaProvider = StateNotifierProvider<
    EncuestaDetallesConRespuestaNotifier,
    EncuestaDetallesConRespuestaState>((ref) {
  final session = ref.watch(sessionProvider);
  return EncuestaDetallesConRespuestaNotifier(
      docenteRepository: DocenteRepositoryImpl(),
      estudianteRepository: EstudianteRepositoryImpl(),
      token: session.token,
      cedula: session.user!.cedula);
});
