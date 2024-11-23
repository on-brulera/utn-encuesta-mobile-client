import 'package:encuestas_utn/features/auth/domain/entities/curso.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/estudiante_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaCursoEstudianteState {
  final List<Curso> cursos;
  final bool isLoading;
  final String? error;

  ListaCursoEstudianteState({
    this.cursos = const [],
    this.isLoading = false,
    this.error,
  });

  ListaCursoEstudianteState copyWith({
    List<Curso>? cursos,
    bool? isLoading,
    String? error,
  }) {
    return ListaCursoEstudianteState(
      cursos: cursos ?? this.cursos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ListaCursoEstudianteNotifier
    extends StateNotifier<ListaCursoEstudianteState> {
  final EstudianteRepository estudianteRepository;
  final String token;
  final int idUsuario;

  ListaCursoEstudianteNotifier(
      {required this.estudianteRepository,
      required this.token,
      required this.idUsuario})
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
}

final estudianteCursosProvider = StateNotifierProvider<
    ListaCursoEstudianteNotifier, ListaCursoEstudianteState>((ref) {
  final session = ref.watch(sessionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return ListaCursoEstudianteNotifier(
      estudianteRepository: EstudianteRepositoryImpl(),
      token: session.token,
      idUsuario: int.tryParse(session.user!.id)!);
});
