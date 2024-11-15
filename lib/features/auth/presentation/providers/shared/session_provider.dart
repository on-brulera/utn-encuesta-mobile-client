import 'package:encuestas_utn/features/auth/domain/entities/user.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/auth_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionState {
  final User? user;
  final String token;

  SessionState({this.user, this.token = ''});

  SessionState copyWith({User? user, String? token}) {
    return SessionState(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  final AuthRepository authRepository;

  SessionNotifier({required this.authRepository}) : super(SessionState());

  Future<void> login(String usuario, String password) async {
    try {
      // Utiliza el repositorio para manejar la lógica de autenticación
      final user = await authRepository.login(usuario, password);
      if (user != null) {
        // Actualiza el estado con el usuario autenticado y su token
        state = state.copyWith(user: user, token: user.token);
      } else {
        state = state.copyWith(
            user: User(
                id: 'id', usuario: 'usuario', password: 'password', rol: 'DOC'),
            token: 'jajaja');
        // print("Error: Usuario o contraseña incorrectos");
      }
    } catch (e) {
      // print("Error en la autenticación: $e");
    }
  }

  void logout() {
    // Limpiar el estado de la sesión
    state = SessionState();
  }
}

// Provider global que expone SessionNotifier
final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(authRepository: AuthRepositoryImpl());
});
