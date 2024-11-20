import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

class ListaAsignacionDetalleState {
  final List<AsignacionDetalles> asignaciones;
  final bool isLoading;
  final String? error;

  ListaAsignacionDetalleState({
    this.asignaciones = const [],
    this.isLoading = false,
    this.error,
  });

  ListaAsignacionDetalleState copyWith({
    List<AsignacionDetalles>? asignaciones,
    bool? isLoading,
    String? error,
  }) {
    return ListaAsignacionDetalleState(
      asignaciones: asignaciones ?? this.asignaciones,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
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
        state = state.copyWith(asignaciones: asignaciones, isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false,
            error: 'No se pudieron obtener las asignaciones.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener las asignaciones: ${e.toString()}');
    }
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
