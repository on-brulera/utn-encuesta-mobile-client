import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';

class MensajeNotifier extends StateNotifier<List<Mensaje>> {
  MensajeNotifier(
      {required this.cedula,
      required this.docenteRepository,
      required this.idUsuario})
      : super([]);
  final String cedula;
  final String idUsuario;
  final DocenteRepository docenteRepository;

  Future<void> iniciarChat(UsuarioChat usuario) async {
    bool esEstudiante = usuario == UsuarioChat.estudiante;
    if (state.isEmpty) {
      Mensaje? mensaje = await docenteRepository.iniciarChat(
        esEstudiante? cedula: idUsuario, esEstudiante
      );
      agregarMensaje(mensaje!);
    }
  }

  // Añadir un nuevo mensaje a la lista
  void agregarMensaje(Mensaje mensaje) {
    state = [...state, mensaje];
  }

  // Simular respuesta del backend (lógica real se conecta con la API)
  Future<void> enviarMensaje(String texto, UsuarioChat usuario) async {
    bool esEstudiante = usuario == UsuarioChat.estudiante;
    // Mensaje enviado por el usuario
    agregarMensaje(Mensaje(text: texto, fromWho: FromWho.me));

    Mensaje? mensaje = await docenteRepository.enviarMensajeChat(
        esEstudiante ? cedula : idUsuario, texto, usuario == UsuarioChat.estudiante);

    // Respuesta de la IA
    agregarMensaje(Mensaje(
      text: mensaje!.text,
      // imageUrl:
      //     'https://www.excelsior.com.mx/media/pictures/2024/11/21/3216015.jpg',<<
      fromWho: FromWho.ia,
    ));
  }
}

// Provider para acceder al estado
final mensajeProvider = StateNotifierProvider<MensajeNotifier, List<Mensaje>>(
  (ref) {
    final session = ref.watch(sessionProvider);

    // Validar que session.user no sea null
    if (session.user == null) {
      throw Exception('El usuario no está autenticado. Sesión no válida.');
    }
    return MensajeNotifier(
      cedula: session.user!.cedula,
      idUsuario: session.user!.id,
      docenteRepository: DocenteRepositoryImpl(),
    );
  },
);
