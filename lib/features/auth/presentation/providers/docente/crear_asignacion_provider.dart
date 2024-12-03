import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:encuestas_utn/utils/utils.dart';
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
      int cursoId, int materiaId, int parcialId, String fechaLimite) async {
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
            true,
            token);
        await docenteRepository.crearAsignacion(
            Asignacion(
                encuestaId: encuestaId,
                usuarioId: int.tryParse(estudianteExiste.id)!,
                cursoId: cursoId,
                materiaId: materiaId,
                descripcion: 'Responde rápidamente la encuesta',
                fechaCompletado: convertirAISO8601(fechaLimite),
                realizado: false,
                usuIdAsignador: idUsuarioDocente,
                parcialSeleccionado: parcialId),
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
              fechaCompletado: convertirAISO8601(fechaLimite),
              realizado: false,
              usuIdAsignador: 0,
              parcialSeleccionado: 0));
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al crear la asignación: ${e.toString()}',
      );
    }
  }

  Future<void> actualizarNota(List<Estudiante> estudiantes, int cursoId,
      int materiaId, int parcialId) async {
    state =
        state.copyWith(isLoading: true, error: null, asignacionCreada: null);
    try {
      //OBTENER NOTAS DEL CURSO
      List<Estudiante>? estudiantesConNota = await docenteRepository
          .obtenerEstudiantesByCursoIdMateriaId(cursoId, materiaId, token);

      //REVISAR SI EL USUARIO EXISTE
      for (Estudiante estudiante in estudiantesConNota!) {
        await docenteRepository.crearActualizarNota(
            Nota(
                id: parcialId == 1 ? estudiante.nota1Id : estudiante.nota2Id,
                usuarioId: estudiante.usuarioId,
                cursoId: cursoId,
                materiaId: materiaId,
                parcialId: parcialId,
                nota: parcialId == 1 ? estudiante.nota1 : estudiante.nota2),
            false,
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
              usuIdAsignador: 0,
              parcialSeleccionado: 0));
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al editar la nota: ${e.toString()}',
      );
    }
  }

  Future<bool?> eliminarAsignaciones(
    int encuestaId,
    int cursoId,
    int materiaId,
    int usuarioAsignador,
    int parcialSeleccionado,
  ) async {
    state =
        state.copyWith(isLoading: true, error: null, asignacionCreada: null);
    try {
      bool? responde = await docenteRepository.eliminarASignacionesCurso(
          encuestaId,
          cursoId,
          materiaId,
          idUsuarioDocente,
          parcialSeleccionado,
          token);
      state = state.copyWith(isLoading: false);
      return responde;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al crear la asignación: ${e.toString()}',
      );
      return false;
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
