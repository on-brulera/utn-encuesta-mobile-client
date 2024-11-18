import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';

// Modelo del estado
class CursoDetalleState {
  final Curso curso;

  CursoDetalleState({required this.curso});

  CursoDetalleState copyWith({Curso? curso}) {
    return CursoDetalleState(curso: curso ?? this.curso);
  }
}

// Clase Notifier
class CursoDetalleNotifier extends StateNotifier<CursoDetalleState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;

  CursoDetalleNotifier({
    required this.docenteRepository,
    required this.token,
  }) : super(CursoDetalleState(
            curso: Curso(
                carrera: 'Ingeniería Mecatrónica',
                nivel: 1,
                periodoAcademico: '')));

  Future<bool> crearCurso() async {
    try {
      final cursoCreado =
          await docenteRepository.crearCurso(state.curso, token);
      if (cursoCreado != null) {
        state = state.copyWith(curso: cursoCreado);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void actualizarCarrera(String carrera) {
    state = state.copyWith(
      curso: state.curso.copyWith(carrera: carrera),
    );
  }

  void actualizarSemestre(int semestre) {
    state = state.copyWith(
      curso: state.curso.copyWith(nivel: semestre),
    );
  }

  void actualizarPeriodoAcademico(String periodo) {
    state = state.copyWith(
      curso: state.curso.copyWith(periodoAcademico: periodo),
    );
  }

  void limpiarEstado() {
    state = CursoDetalleState(
        curso: Curso(
            carrera: 'Ingeniería Mecatrónica', nivel: 1, periodoAcademico: ''));
  }
}

// Provider
final cursoDetalleProvider =
    StateNotifierProvider<CursoDetalleNotifier, CursoDetalleState>((ref) {
  final session = ref.watch(sessionProvider);
  return CursoDetalleNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});

