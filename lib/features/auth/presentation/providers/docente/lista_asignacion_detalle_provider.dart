import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaAsignacionDetalleState {
  final List<AsignacionDetalles>? asignaciones;
  final bool isLoading;
  final String? error;
  //PARA OBTENER LOS CURSOS SIN REPETICION
  final List<AsignacionDetalles>? cursosAsignaciones;
  //PARA OBTENER LOS DETALLES DEL CURSO SIN REPETICION
  final AsignacionDetalles? cursoAsignacionSelected;
  final List<AsignacionDetalles>? encuestasCursoAsignacionSelected;
  final bool hasLoaded;
  //PARA LA LISTA DE ESTUDIANTES
  final List<Estudiante>? estudiantes;

  ListaAsignacionDetalleState(
      {this.asignaciones = const [],
      this.isLoading = false,
      this.error,
      this.cursosAsignaciones = const [],
      this.cursoAsignacionSelected,
      this.encuestasCursoAsignacionSelected,
      this.hasLoaded = false,
      this.estudiantes});

  ListaAsignacionDetalleState copyWith(
      {List<AsignacionDetalles>? asignaciones,
      bool? isLoading,
      String? error,
      List<AsignacionDetalles>? cursosAsignaciones,
      AsignacionDetalles? cursoAsignacionSelected,
      List<AsignacionDetalles>? encuestasCursoAsignacionSelected,
      bool? hasLoaded,
      List<Estudiante>? estudiantes}) {
    return ListaAsignacionDetalleState(
        asignaciones: asignaciones ?? this.asignaciones,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        cursosAsignaciones: cursosAsignaciones ?? this.cursosAsignaciones,
        cursoAsignacionSelected:
            cursoAsignacionSelected ?? this.cursoAsignacionSelected,
        encuestasCursoAsignacionSelected: encuestasCursoAsignacionSelected ??
            this.encuestasCursoAsignacionSelected,
        hasLoaded: hasLoaded ?? this.hasLoaded,
        estudiantes: estudiantes ?? this.estudiantes);
  }
}

class ListaAsignacionDetalleNotifier
    extends StateNotifier<ListaAsignacionDetalleState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;
  final int userId;

  ListaAsignacionDetalleNotifier(
      {required this.docenteRepository,
      required this.token,
      required this.userId})
      : super(ListaAsignacionDetalleState());

  Future<void> obtenerTodasLasAsignaciones() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final asignaciones =
          await docenteRepository.obtenerAsignacionesByDocenteId(userId, token);

      if (asignaciones != null) {
        state = state.copyWith(
            asignaciones: asignaciones, isLoading: false, hasLoaded: true);
        filtrarAsignacionesPorCurso();
      } else {
        state = state.copyWith(
            isLoading: false,
            hasLoaded: true,
            error: 'No se pudieron obtener las asignaciones.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          hasLoaded: true,
          error: 'Error al obtener las asignaciones: ${e.toString()}');
    }
  }

  void filtrarAsignacionesPorCurso() {
    final Set<String> combinacionesVistas = {};
    final List<AsignacionDetalles> cursosAsignaciones = [];

    for (final asignacion in state.asignaciones!) {
      // Crear una combinación única basada en curId y matId
      final combinacion = '${asignacion.curId}-${asignacion.matId}';

      if (!combinacionesVistas.contains(combinacion)) {
        combinacionesVistas.add(combinacion);
        cursosAsignaciones.add(asignacion);
      }
    }

    // Actualizar el estado con las asignaciones filtradas
    state = state.copyWith(cursosAsignaciones: cursosAsignaciones);
  }


  void seleccionarCursoAsignadoByCursoId(
    int cursoId,
    int materiaId,
  ) async {
    AsignacionDetalles cursoAsignadoSeleccionado = state.asignaciones!
        .where((asignacion) =>
            asignacion.curId == cursoId && asignacion.matId == materiaId)
        .first;
    state = state.copyWith(cursoAsignacionSelected: cursoAsignadoSeleccionado);

    List<AsignacionDetalles> encuestasCursoAsignacionSelected = state
        .asignaciones!
        .where((asignacion) =>
            asignacion.curId == cursoAsignadoSeleccionado.curId &&
            asignacion.matId == materiaId)
        .toList();
    state = state.copyWith(
        encuestasCursoAsignacionSelected: encuestasCursoAsignacionSelected);

    List<Estudiante>? estudiantes = await docenteRepository
        .obtenerEstudiantesByCursoIdMateriaId(cursoId, materiaId, token);
    state = state.copyWith(estudiantes: estudiantes);
  }
}

final listaAsignacionDetalleProvider = StateNotifierProvider<
    ListaAsignacionDetalleNotifier, ListaAsignacionDetalleState>((ref) {
  final session = ref.watch(sessionProvider);
  assert(session.token.isNotEmpty, 'El token no está disponible');
  final notifier = ListaAsignacionDetalleNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
    userId: int.parse(session.user!.id),
  );
  notifier.obtenerTodasLasAsignaciones(); // Llamada automática al inicializar
  return notifier;
});
