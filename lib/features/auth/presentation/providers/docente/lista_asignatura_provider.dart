import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaAsignaturaState {
  final List<Materia> materias;
  final bool isLoading;
  final String? error;

  ListaAsignaturaState({
    this.materias = const [],
    this.isLoading = false,
    this.error,
  });

  ListaAsignaturaState copyWith({
    List<Materia>? materias,
    bool? isLoading,
    String? error,
  }) {
    return ListaAsignaturaState(
      materias: materias ?? this.materias,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ListaAsignaturaNotifier extends StateNotifier<ListaAsignaturaState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;

  ListaAsignaturaNotifier({
    required this.docenteRepository,
    required this.token,
  }) : super(ListaAsignaturaState());

  Future<void> obtenerTodasMaterias() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final materias = await docenteRepository.obtenerAllMateria(token);

      if (materias != null) {
        state = state.copyWith(materias: materias, isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false, error: 'No se pudieron obtener las asignaturas.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener las asignaturas: ${e.toString()}');
    }
  }
}

final listaAsignaturaProvider =
    StateNotifierProvider<ListaAsignaturaNotifier, ListaAsignaturaState>((ref) {
  final session = ref.watch(sessionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return ListaAsignaturaNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
