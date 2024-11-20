import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaParcialState {
  final List<Parcial> parciales;
  final bool isLoading;
  final String? error;

  ListaParcialState({
    this.parciales = const [],
    this.isLoading = false,
    this.error,
  });

  ListaParcialState copyWith({
    List<Parcial>? parciales,
    bool? isLoading,
    String? error,
  }) {
    return ListaParcialState(
      parciales: parciales ?? this.parciales,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ListaParcialNotifier extends StateNotifier<ListaParcialState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;

  ListaParcialNotifier({
    required this.docenteRepository,
    required this.token,
  }) : super(ListaParcialState());

  Future<void> obtenerTodasParciales() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final parciales = await docenteRepository.obtenerAllParcial(token);

      if (parciales != null) {
        state = state.copyWith(parciales: parciales, isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false, error: 'No se pudieron obtener las parciales.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener las parciales: ${e.toString()}');
    }
  }
}

final listaParcialProvider =
    StateNotifierProvider<ListaParcialNotifier, ListaParcialState>((ref) {
  final session = ref.watch(sessionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return ListaParcialNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
