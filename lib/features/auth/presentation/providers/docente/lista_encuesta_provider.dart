import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaEncuestaState {
  final List<Encuesta> encuestas;
  final bool isLoading;
  final String? error;

  ListaEncuestaState({
    this.encuestas = const [],
    this.isLoading = false,
    this.error,
  });

  ListaEncuestaState copyWith({
    List<Encuesta>? encuestas,
    bool? isLoading,
    String? error,
  }) {
    return ListaEncuestaState(
      encuestas: encuestas ?? this.encuestas,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ListaEncuestaNotifier extends StateNotifier<ListaEncuestaState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;

  ListaEncuestaNotifier({
    required this.docenteRepository,
    required this.token,
  }) : super(ListaEncuestaState());

  Future<void> obtenerTodasLasEncuestas() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final encuestas = await docenteRepository.obtenerAllEncuestas(token);

      if (encuestas != null) {
        state = state.copyWith(encuestas: encuestas, isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false, error: 'No se pudieron obtener las encuestas.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener las encuestas: ${e.toString()}');
    }
  }

  Future<bool?> borrarEncuestaDetallesConId(int idEncuesta) async {
    final bool? codigoStatus =
        await docenteRepository.eliminarEncuesta(idEncuesta, token);
    return codigoStatus;
  }
}

final listaEncuestaProvider =
    StateNotifierProvider<ListaEncuestaNotifier, ListaEncuestaState>((ref) {
  final session = ref.watch(sessionProvider);
  return ListaEncuestaNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
