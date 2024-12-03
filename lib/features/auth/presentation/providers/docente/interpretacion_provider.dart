import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';

class InterpretacionNotifier extends StateNotifier<InterpretacionState> {
  final DocenteRepository docenteRepository;

  InterpretacionNotifier(this.docenteRepository) : super(InterpretacionState());

  Future<void> cargarInterpretacion(String texto) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final respuesta = await docenteRepository.analizarResultado(texto);
      state = state.copyWith(
        isLoading: false,
        interpretacion: respuesta?.text ?? 'Sin respuesta',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar interpretación',
      );
    }
  }
}

class InterpretacionState {
  final String? interpretacion;
  final bool isLoading;
  final String? error;

  InterpretacionState({
    this.interpretacion,
    this.isLoading = false,
    this.error,
  });

  InterpretacionState copyWith({
    String? interpretacion,
    bool? isLoading,
    String? error,
  }) {
    return InterpretacionState(
      interpretacion: interpretacion ?? this.interpretacion,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final interpretacionProvider = StateNotifierProvider.family<
    InterpretacionNotifier, InterpretacionState, String>(
  (ref, id) => InterpretacionNotifier(DocenteRepositoryImpl()),
);
