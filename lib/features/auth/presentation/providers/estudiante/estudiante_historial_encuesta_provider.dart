import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/estudiante_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/estudiante_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class EstudianteHistorialState {
  final Historial? historial;
  final bool isLoading;
  final String? error;

  EstudianteHistorialState({
    this.historial,
    this.isLoading = false,
    this.error,
  });

  EstudianteHistorialState copyWith({
    Historial? historial,
    bool? isLoading,
    String? error,
  }) {
    return EstudianteHistorialState(
      historial: historial ?? this.historial,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EstudianteHistorialNotifier
    extends StateNotifier<EstudianteHistorialState> {
  final EstudianteRepository estudianteRepository;
  final String token;
  final int idUsuario;

  EstudianteHistorialNotifier(
      {required this.estudianteRepository,
      required this.token,
      required this.idUsuario})
      : super(EstudianteHistorialState());

  Future<void> obtenerHistorialByAsignacinId(int idAsignacion) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final historial = await estudianteRepository
          .obtenerResultadoTestEstudianteByAsignacionId(idAsignacion, token);

      if (historial != null && historial.notaEstudiante.isNotEmpty) {
        state = state.copyWith(historial: historial, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No se encontró el historial.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al obtener el historial: ${e.toString()}',
      );
    }
  }

}

final estudianteHistorialProvider = StateNotifierProvider<
    EstudianteHistorialNotifier, EstudianteHistorialState>((ref) {
  final session = ref.watch(sessionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return EstudianteHistorialNotifier(
      estudianteRepository: EstudianteRepositoryImpl(),
      token: session.token,
      idUsuario: int.tryParse(session.user!.id)!);
});
