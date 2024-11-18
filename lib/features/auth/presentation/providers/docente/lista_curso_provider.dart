import 'package:encuestas_utn/features/auth/domain/entities/curso.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaCursoState {
  final List<Curso> cursos;
  final bool isLoading;
  final String? error;

  ListaCursoState({
    this.cursos = const [],
    this.isLoading = false,
    this.error,
  });

  ListaCursoState copyWith({
    List<Curso>? cursos,
    bool? isLoading,
    String? error,
  }) {
    return ListaCursoState(
      cursos: cursos ?? this.cursos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ListaCursoNotifier extends StateNotifier<ListaCursoState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;

  ListaCursoNotifier({
    required this.docenteRepository,
    required this.token,
  }) : super(ListaCursoState());

  Future<void> obtenerTodosCursos() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cursos = await docenteRepository.obtenerAllCurso(token);

      if (cursos != null) {
        state = state.copyWith(cursos: cursos, isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false, error: 'No se pudieron obtener los cursos.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener los cursos: ${e.toString()}');
    }
  }  
}

final listaCursoProvider =
    StateNotifierProvider<ListaCursoNotifier, ListaCursoState>((ref) {
  final session = ref.watch(sessionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return ListaCursoNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
