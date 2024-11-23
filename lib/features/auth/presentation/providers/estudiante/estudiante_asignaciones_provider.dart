import 'package:encuestas_utn/features/auth/domain/entities/asignacion.dart';
import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/estudiante_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EstudianteAsignacionesState {
  final List<Asignacion>? asignaciones;
  final List<Encuesta>? encuestas;
  final List<Encuesta>? encuestasAsignadas;
  final List<Encuesta>? encuestasPorResponder;
  final bool isLoading;
  final bool isLoaded;
  EstudianteAsignacionesState({
    this.asignaciones,
    this.encuestas,
    this.encuestasAsignadas,
    this.encuestasPorResponder,
    this.isLoading = false,
    this.isLoaded = false,
  });

  EstudianteAsignacionesState copyWith({
    List<Asignacion>? asignaciones,
    List<Encuesta>? encuestas,
    List<Encuesta>? encuestasAsignadas,
    List<Encuesta>? encuestasPorResponder,
    bool? isLoading,
    bool? isLoaded,
  }) =>
      EstudianteAsignacionesState(
          asignaciones: asignaciones ?? this.asignaciones,
          encuestas: encuestas ?? this.encuestas,
          encuestasAsignadas: encuestasAsignadas ?? this.encuestasAsignadas,
          encuestasPorResponder:
              encuestasPorResponder ?? this.encuestasPorResponder,
          isLoaded: isLoaded ?? this.isLoaded,
          isLoading: isLoading ?? this.isLoading);
}

class EstudianteAsignacionesNotifier
    extends StateNotifier<EstudianteAsignacionesState> {
  final EstudianteRepository repositorioEstudiante;
  final DocenteRepository repositorioDocente;
  final String token;
  final String idEstudiante;

  EstudianteAsignacionesNotifier(
      {required this.token,
      required this.idEstudiante,
      required this.repositorioEstudiante,
      required this.repositorioDocente})
      : super(EstudianteAsignacionesState());

  Future<void> obtenerAsignacionesEncuestas() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true); // Inicia la carga
    try {
      List<Asignacion>? asignaciones =
          await repositorioEstudiante.obtenerAsignacionDeEncuestaByEstudianteId(
              int.tryParse(idEstudiante)!, token);
      List<Encuesta>? encuestas =
          await repositorioDocente.obtenerAllEncuestas(token);
      if (asignaciones != null) {
        state = state.copyWith(
          asignaciones: asignaciones,
          encuestas: encuestas,
          isLoaded: true,
          isLoading: false,
        );
        await actualizarEncuestasAsignadas();
        await actualizarEncuestasPorResponder();
      } else {
        state = state.copyWith(isLoading: false); // Manejar el caso de error
      }
    } catch (e) {
      state = state.copyWith(isLoading: false); // Manejar excepciones
      rethrow;
    }
  }

  Future<void> actualizarEncuestasAsignadas() async {
    List<Encuesta> encuestasActualizadas = [];
    for (Asignacion asignacion in state.asignaciones!) {
      Encuesta encuesta = state.encuestas!
          .where((encuesta) => encuesta.id == asignacion.encuestaId)
          .first;
      encuestasActualizadas.add(encuesta.copyWith(idAsignacion: asignacion.id, fechaLimite: asignacion.fechaCompletado.toIso8601String()));
    }
    state = state.copyWith(encuestasAsignadas: encuestasActualizadas);
  }

  Future<void> actualizarEncuestasPorResponder() async {
    List<Encuesta> encuestasActualizadas = [];
    for (Asignacion asignacion in state.asignaciones!) {
      if (!asignacion.realizado) {
        final encuestasFiltradas = state.encuestas!
            .where((encuesta) =>
                encuesta.id == asignacion.encuestaId &&
                    asignacion.realizado == false &&
                    DateTime.now().isBefore(asignacion.fechaCompletado) ||
                DateTime.now().isAtSameMomentAs(asignacion.fechaCompletado))
            .toList();

        if (encuestasFiltradas.isNotEmpty) {
          encuestasActualizadas.add(encuestasFiltradas.first.copyWith(
              idAsignacion: asignacion.id,
              fechaLimite: asignacion.fechaCompletado.toIso8601String()));
        }
      }
    }
    state = state.copyWith(encuestasPorResponder: encuestasActualizadas);
  }
}

final estudianteAsignacionProvider = StateNotifierProvider<
    EstudianteAsignacionesNotifier, EstudianteAsignacionesState>(
  (ref) {
    final session = ref.watch(sessionProvider);
    return EstudianteAsignacionesNotifier(
        idEstudiante: session.user!.id,
        token: session.token,
        repositorioEstudiante: EstudianteRepositoryImpl(),
        repositorioDocente: DocenteRepositoryImpl());
  },
);
