import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/admin_repository_impl.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/auth_repository_impl.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> usuarios;

  UserLoaded(this.usuarios);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserNotifier extends StateNotifier<UserState> {
  final AdminRepositoryImpl adminRepository;
  final AuthRepositoryImpl authRepository;
  final DocenteRepository docenteRepository;
  final String token;
  bool _isLoaded = false; // Bandera para controlar las peticiones

  UserNotifier(this.adminRepository, this.authRepository, this.token,
      this.docenteRepository)
      : super(UserInitial());

  Future<void> obtenerUsuariosPorRol(String rolCodigo) async {
    // Evita realizar la solicitud si los datos ya fueron cargados
    if (_isLoaded) return;

    try {
      state = UserLoading();
      final usuarios =
          await adminRepository.obtenerUsuariosByCodigoRol(rolCodigo);

      if (usuarios != null) {
        state = UserLoaded(usuarios);
        _isLoaded = true; // Marca los datos como cargados
      } else {
        state =
            UserError('No se encontraron usuarios para el rol especificado.');
      }
    } catch (e) {
      state = UserError('Ocurrió un error al obtener los usuarios: $e');
    }
  }

  Future<bool> crearDocente(
      String cedula, String nombre, String password) async {
    try {
      // Lógica para crear el docente
      await docenteRepository.crearPersona(
          Persona(cedula: cedula, nombres: nombre), token);
      User? docente = await docenteRepository.crearEstudiante(
          User(
              id: '0',
              usuario: 'D$cedula',
              password: password,
              rol: 'DOC',
              cedula: cedula,
              cursoId: 1),
          token);

      if (docente != null) {
        // Actualiza el estado directamente añadiendo el nuevo docente
        if (state is UserLoaded) {
          final usuarios = List<User>.from((state as UserLoaded).usuarios);
          usuarios.add(docente);
          state = UserLoaded(usuarios);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void reset() {
    _isLoaded = false; // Resetea la bandera
    state = UserInitial(); // Vuelve al estado inicial
  }

  Future<void> actualizarPassword(User usuario) async {
    await authRepository.cambiarPassword(usuario, token);
  }
}

final adminRepositoryProvider = Provider<AdminRepositoryImpl>((ref) {
  return AdminRepositoryImpl();
});

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  final session = ref.watch(sessionProvider);
  return UserNotifier(adminRepository, AuthRepositoryImpl(), session.token,
      DocenteRepositoryImpl());
});

final docentesProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  final session = ref.watch(sessionProvider);
  final notifier = UserNotifier(adminRepository, AuthRepositoryImpl(),
      session.token, DocenteRepositoryImpl());
  notifier.obtenerUsuariosPorRol('DOC'); // Inicializa con el rol de docentes
  return notifier;
});

final estudiantesProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  final session = ref.watch(sessionProvider);
  final notifier = UserNotifier(adminRepository, AuthRepositoryImpl(),
      session.token, DocenteRepositoryImpl());
  notifier.obtenerUsuariosPorRol('EST'); // Inicializa con el rol de estudiantes
  return notifier;
});
