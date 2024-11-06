import 'package:encuestas_utn/domain/entities/mensaje.dart';
import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final appRoutes = GoRouter(
  initialLocation: '/${LoginScreen.screenName}',
  routes: [
    //RUTAS PARA DOCENTES Y ESTUDIANTES
    GoRoute(
      path: '/${LoginScreen.screenName}',
      builder: (context, state) => const LoginScreen(),
    ),    
    GoRoute(
      path: '/${ChatScreen.screenName}',
      builder: (context, state) {
        // Obtén el parámetro 'usuarioChat' pasado en la navegación
        final usuarioChat = state.extra as UsuarioChat;
        return ChatScreen(usuarioChat: usuarioChat);
      },
    ),
    //RUTAS PARA EL DOCENTE
    GoRoute(
      path: '/${DocenteMenuDScreen.screenName}',
      builder: (context, state) => const DocenteMenuDScreen(),
    ),
    GoRoute(
      path: '/${DocenteDisenarEncuestaScreen.screenName}',
      builder: (context, state) => const DocenteDisenarEncuestaScreen(),
    ),
    GoRoute(
      path: '/${DocenteCursoAsignacionScreen.screenName}',
      builder: (context, state) => const DocenteCursoAsignacionScreen(),
    ),
    GoRoute(
      path: '/${DocenteEstadisticaScreen.screenName}',
      builder: (context, state) => const DocenteEstadisticaScreen(),
    ),
    GoRoute(
      path: '/${DocentePerfilScreen.screenName}',
      builder: (context, state) => const DocentePerfilScreen(),
    ),
    GoRoute(
      path: '/${DocenteListaEncuestaScreen.screenName}',
      builder: (context, state) => const DocenteListaEncuestaScreen(),
    ),

    //RUTAS PARA EL ESTUDIANTE
    GoRoute(
      path: '/${EstudiantePerfilScreen.screenName}',
      builder: (context, state) => const EstudiantePerfilScreen(),
    ),
    GoRoute(
      path: '/${EstudianteCursoScreen.screenName}',
      builder: (context, state) => const EstudianteCursoScreen(),
    ),
    GoRoute(
      path: '/${EstudianteEstadisticaScreen.screenName}',
      builder: (context, state) => const EstudianteEstadisticaScreen(),
    ),
    GoRoute(
      path: '/${EstudianteMirarEncuestaScreen.screenName}',
      builder: (context, state) => const EstudianteMirarEncuestaScreen(),
    ),
    GoRoute(
      path: '/${EstudianteMenuDScreen.screenName}',
      builder: (context, state) => const EstudianteMenuDScreen(),
    ),
    GoRoute(
      path: '/${EstudianteMenuDScreen.screenName}',
      builder: (context, state) => const EstudianteMenuDScreen(),
    ),
    GoRoute(
      path: '/${EstudianteEncuestasResponder.screenName}',
      builder: (context, state) => const EstudianteEncuestasResponder(),
    ),
  ],
);
