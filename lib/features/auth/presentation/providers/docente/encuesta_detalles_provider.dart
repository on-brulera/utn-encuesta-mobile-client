import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';

// Modelo del estado
class EncuestaDetallesState {
  final bool isLoading;
  final EncuestaDetalles? detalles;
  final String? error;

  EncuestaDetallesState({
    this.isLoading = false,
    this.detalles,
    this.error,
  });

  EncuestaDetallesState copyWith({
    bool? isLoading,
    EncuestaDetalles? detalles,
    String? error,
  }) {
    return EncuestaDetallesState(
      isLoading: isLoading ?? this.isLoading,
      detalles: detalles ?? this.detalles,
      error: error,
    );
  }
}

// Clase Notifier
class EncuestaDetallesNotifier extends StateNotifier<EncuestaDetallesState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;

  EncuestaDetallesNotifier({
    required this.docenteRepository,
    required this.token,
  }) : super(EncuestaDetallesState());

  Future<void> obtenerEncuestaDetalles(int idEncuesta) async {
    state = state.copyWith(isLoading: true, error: null, detalles: null);
    try {
      final detalles =
          await docenteRepository.obtenerEncuestaDellates(token, idEncuesta);
      if (detalles != null) {
        state = state.copyWith(isLoading: false, detalles: detalles);
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

  void cargarNuevaEncuesta(int idEncuesta) {
    state = EncuestaDetallesState(); // Limpia el estado anterior
    obtenerEncuestaDetalles(idEncuesta);
  }

  void limpiarEstado() {
    state = EncuestaDetallesState();
  }
}

// Provider
final encuestaDetallesProvider =
    StateNotifierProvider<EncuestaDetallesNotifier, EncuestaDetallesState>(
        (ref) {
  final session = ref.watch(sessionProvider);
  return EncuestaDetallesNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
