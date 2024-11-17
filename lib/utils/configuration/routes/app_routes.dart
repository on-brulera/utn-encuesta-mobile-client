import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
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
    GoRoute(
      path: '/${DocenteEncuestaDetallesScreen.screenName}/:idEncuesta',
      name: DocenteEncuestaDetallesScreen.screenName, // Define un nombre único
      builder: (context, state) {
        final idEncuesta =
            int.tryParse(state.pathParameters['idEncuesta'] ?? '');
        if (idEncuesta == null) {
          return const Scaffold(
            body: Center(
              child: Text('ID de encuesta no válido'),
            ),
          );
        }
        return DocenteEncuestaDetallesScreen(idEncuesta: idEncuesta);
      },
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
