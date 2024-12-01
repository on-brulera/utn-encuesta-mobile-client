import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/estudiante_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_asignaciones_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaCursoEstudianteState {
  final List<Curso> cursos;
  final bool isLoading;
  final String? error;

  //Para el curso seleccionado y sus asignaturas
  final Curso? isSelectedCurso;
  final List<Materia>? asignaturas;
  final List<Encuesta>? encuestasFiltradas;

  ListaCursoEstudianteState({
    this.cursos = const [],
    this.isLoading = false,
    this.isSelectedCurso,
    this.asignaturas,
    this.encuestasFiltradas,
    this.error,
  });

  ListaCursoEstudianteState copyWith(
      {List<Curso>? cursos,
      bool? isLoading,
      String? error,
      Curso? isSelectedCurso,
      List<Materia>? asignaturas,
      List<Encuesta>? encuestasFiltradas}) {
    return ListaCursoEstudianteState(
      cursos: cursos ?? this.cursos,
      isLoading: isLoading ?? this.isLoading,
      isSelectedCurso: isSelectedCurso ?? this.isSelectedCurso,
      asignaturas: asignaturas ?? this.asignaturas,
      encuestasFiltradas: encuestasFiltradas ?? this.encuestasFiltradas,
      error: error,
    );
  }
}

class ListaCursoEstudianteNotifier
    extends StateNotifier<ListaCursoEstudianteState> {
  final EstudianteRepository estudianteRepository;
  final String token;
  final int idUsuario;
  final List<Asignacion> asignaciones;
  final List<Encuesta> encuestas;

  ListaCursoEstudianteNotifier(
      {required this.estudianteRepository,
      required this.token,
      required this.idUsuario,
      required this.asignaciones,
      required this.encuestas})
      : super(ListaCursoEstudianteState());

  Future<void> obtenerTodosCursos() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cursos = await estudianteRepository.obtenerCursosByEstudianteId(
          idUsuario, token);

      // Manejo de respuesta vacía
      if (cursos != null) {
        state = state.copyWith(cursos: cursos, isLoading: false);
      } else {
        state = state.copyWith(
          cursos: [],
          isLoading: false,
          error: 'No se encontraron cursos disponibles.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al obtener los cursos: ${e.toString()}',
      );
    }
  }

  Future<void> selectCurso(Curso curso) async {
    state = state.copyWith(isSelectedCurso: curso);
    obtenerMaterias(curso.id);
  }

  Future<void> obtenerMaterias(int cursoId) async {
    final List<Materia>? materias =
        await estudianteRepository.obtenerMateriasPorCurso(cursoId, token);
    state = state.copyWith(asignaturas: materias);
  }

  Future<void> filtrarEncuestasByMateria(int materiaId) async {
    List<Encuesta> encuestasFiltradas = [];
    for (Asignacion asignacion in asignaciones) {
      if (asignacion.cursoId == state.isSelectedCurso!.id &&
          asignacion.materiaId == materiaId) {
        Encuesta encuesta =
            encuestas.where((enc) => enc.idAsignacion == asignacion.id).first;
        encuestasFiltradas.add(encuesta);
      }
    }

    state = state.copyWith(encuestasFiltradas: encuestasFiltradas);
  }
}

final estudianteCursosProvider = StateNotifierProvider<
    ListaCursoEstudianteNotifier, ListaCursoEstudianteState>((ref) {
  final session = ref.watch(sessionProvider);
  final asignaciones = ref.watch(estudianteAsignacionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return ListaCursoEstudianteNotifier(
      estudianteRepository: EstudianteRepositoryImpl(),
      token: session.token,
      asignaciones: asignaciones.asignaciones!,
      encuestas: asignaciones.encuestasAsignadas!,
      idUsuario: int.tryParse(session.user!.id)!);
});
