import 'package:encuestas_utn/features/auth/domain/entities/estrategia.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';

// Estado para manejar la estrategia
class EstrategiaState {
  final String? estrategia;
  final bool isLoading;
  final bool tieneEstrategia;
  final String? error;
  Estrategia? entidad;

  EstrategiaState(
      {this.estrategia,
      this.isLoading = false,
      this.error,
      this.entidad,
      this.tieneEstrategia = false});

  EstrategiaState copyWith(
      {String? estrategia,
      bool? isLoading,
      bool? tieneEstrategia,
      String? error,
      Estrategia? entidad}) {
    return EstrategiaState(
        estrategia: estrategia ?? this.estrategia,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        entidad: entidad ?? this.entidad,
        tieneEstrategia: tieneEstrategia ?? this.tieneEstrategia);
  }
}

// Notifier para manejar la obtención de estrategias
class EstrategiaNotifier extends StateNotifier<EstrategiaState> {
  final DocenteRepository docenteRepository;
  final String token;

  EstrategiaNotifier(this.docenteRepository, this.token)
      : super(EstrategiaState(isLoading: false));

  Future<void> obtenerEstrategia(String silabo) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final mensaje = await docenteRepository.obtenerEstrategias(silabo);
      state = state.copyWith(
        isLoading: false,
        estrategia: mensaje?.text ?? 'Sin respuesta',
      );

      if (mensaje != null) {
        state.entidad = state.entidad?.copyWith(estrategia: mensaje.text);
        if (state.tieneEstrategia) {
          await docenteRepository.actualizarEstrategiasdeCurso(
              state.entidad!, token);
        } else {
          await docenteRepository.crearEstrategiasdeCurso(
              state.entidad!, token);
          state = state.copyWith(tieneEstrategia: true);
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al obtener estrategia',
      );
    }
  }

  Future<Estrategia?> obtenerEstrategiaDesdeRepositorio(
      Estrategia estrategia) async {
    try {
      final resultado =
          await docenteRepository.obtenerEstrategiasdeCurso(estrategia, token);
      if (resultado != null) {
        state = state.copyWith(
            estrategia: resultado.estrategia, tieneEstrategia: true);
      }
      state = state.copyWith(entidad: estrategia);
      return resultado;
    } catch (e) {
      state = state.copyWith(error: 'Error al obtener estrategia');
      return null;
    }
  }
}

// Provider con Family para manejar múltiples secciones
final estrategiaProvider =
    StateNotifierProvider.family<EstrategiaNotifier, EstrategiaState, String>(
        (ref, sectionId) {
  final session = ref.watch(sessionProvider);
  return EstrategiaNotifier(DocenteRepositoryImpl(), session.token);
});
