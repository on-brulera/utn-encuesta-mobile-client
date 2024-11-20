import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';

// Modelo del estado
class CrearAsignacionState {
  final bool isLoading;
  final String? error;
  final Asignacion? asignacionCreada;

  CrearAsignacionState({
    this.isLoading = false,
    this.error,
    this.asignacionCreada,
  });

  CrearAsignacionState copyWith({
    bool? isLoading,
    String? error,
    Asignacion? asignacionCreada,
  }) {
    return CrearAsignacionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      asignacionCreada: asignacionCreada,
    );
  }
}

// Clase Notifier
class CrearAsignacionNotifier extends StateNotifier<CrearAsignacionState> {
  final DocenteRepositoryImpl docenteRepository;
  final String token;
  final int idUsuarioDocente;

  CrearAsignacionNotifier(
      {required this.docenteRepository,
      required this.token,
      required this.idUsuarioDocente})
      : super(CrearAsignacionState());

  Future<void> crearAsignacion(List<Estudiante> estudiantes, int encuestaId,
      int cursoId, int materiaId, int parcialId) async {
    state =
        state.copyWith(isLoading: true, error: null, asignacionCreada: null);
    try {
      //REVISAR SI EL USUARIO EXISTE
      for (Estudiante estudiante in estudiantes) {
        User? estudianteExiste = await docenteRepository.obtenerUsuarioByCedula(
            estudiante.cedula, token);

        if (estudianteExiste == null) {
          await docenteRepository.crearPersona(
              Persona(cedula: estudiante.cedula, nombres: estudiante.nombre),
              token);
          estudianteExiste = await docenteRepository.crearEstudiante(
              User(
                  id: '0',
                  usuario: estudiante.cedula,
                  password: estudiante.cedula,
                  rol: 'EST',
                  cedula: estudiante.cedula,
                  cursoId: cursoId),
              token);
        }

        await docenteRepository.crearActualizarNota(
            Nota(
                usuarioId: int.tryParse(estudianteExiste!.id)!,
                cursoId: cursoId,
                materiaId: materiaId,
                parcialId: parcialId,
                nota: parcialId == 1 ? estudiante.nota1 : estudiante.nota2),
            token);
        await docenteRepository.crearAsignacion(
            Asignacion(
                encuestaId: encuestaId,
                usuarioId: int.tryParse(estudianteExiste.id)!,
                cursoId: cursoId,
                materiaId: materiaId,
                descripcion: 'Responde rápidamente la encuesta',
                fechaCompletado: DateTime.now(),
                realizado: false,
                usuIdAsignador: idUsuarioDocente),
            token);
      }

      state = state.copyWith(
          isLoading: false,
          asignacionCreada: Asignacion(
              encuestaId: 0,
              usuarioId: 0,
              cursoId: 0,
              materiaId: 0,
              descripcion: '',
              fechaCompletado: DateTime.now(),
              realizado: false,
              usuIdAsignador: 0));
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al crear la asignación: ${e.toString()}',
      );
    }
  }
}

// Provider
final crearAsignacionProvider =
    StateNotifierProvider<CrearAsignacionNotifier, CrearAsignacionState>((ref) {
  final session = ref.watch(sessionProvider);
  // Verifica si el token está disponible
  assert(session.token.isNotEmpty, 'El token no está disponible');
  return CrearAsignacionNotifier(
      docenteRepository: DocenteRepositoryImpl(),
      token: session.token,
      idUsuarioDocente: int.tryParse(session.user!.id)!);
});
