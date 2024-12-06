import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// GoRouter configuration
final appRoutes = GoRouter(
  initialLocation: '/${LoginScreen.screenName}',
  routes: [
    //PARA EL ADMINISTRADOR
    GoRoute(
      path: '/${AdminMenuScreen.screenName}',
      name: AdminMenuScreen.screenName,
      builder: (context, state) => const AdminMenuScreen(),
    ),
    GoRoute(
      path: '/${AdminDocenteScreen.screenName}',
      name: AdminDocenteScreen.screenName,
      builder: (context, state) => const AdminDocenteScreen(),
    ),
    GoRoute(
      path: '/${AdminEstudianteteScreen.screenName}',
      name: AdminEstudianteteScreen.screenName,
      builder: (context, state) => const AdminEstudianteteScreen(),
    ),
    GoRoute(
      path: '/${AdminPerfilScreen.screenName}',
      name: AdminPerfilScreen.screenName,
      builder: (context, state) => const AdminPerfilScreen(),
    ),
    //RUTAS PARA DOCENTES Y ESTUDIANTES
    GoRoute(
      path: '/${LoginScreen.screenName}',
      name: LoginScreen.screenName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/${ChatScreen.screenName}',
      name: ChatScreen.screenName,
      builder: (context, state) {
        // Obtén el parámetro 'usuarioChat' pasado en la navegación
        final usuarioChat = state.extra as UsuarioChat;
        return ChatScreen(usuarioChat: usuarioChat);
      },
    ),
    //RUTAS PARA EL DOCENTE
    GoRoute(
      path: '/${DocenteMenuDScreen.screenName}',
      name: DocenteMenuDScreen.screenName,
      builder: (context, state) => const DocenteMenuDScreen(),
    ),
    GoRoute(
      path: '/${DocenteDisenarEncuestaScreen.screenName}',
      name: DocenteDisenarEncuestaScreen.screenName,
      builder: (context, state) => const DocenteDisenarEncuestaScreen(),
    ),
    GoRoute(
      path: '/${DocenteCursoAsignacionScreen.screenName}',
      name: DocenteCursoAsignacionScreen.screenName,
      builder: (context, state) => const DocenteCursoAsignacionScreen(),
    ),
    GoRoute(
      path: '/${DocenteEstadisticaScreen.screenName}',
      name: DocenteEstadisticaScreen.screenName,
      builder: (context, state) => const DocenteEstadisticaScreen(),
    ),
    GoRoute(
      path: '/${DocentePerfilScreen.screenName}',
      name: DocentePerfilScreen.screenName,
      builder: (context, state) => const DocentePerfilScreen(),
    ),
    GoRoute(
      path: '/${DocenteListaEncuestaScreen.screenName}',
      name: DocenteListaEncuestaScreen.screenName,
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
    GoRoute(
      path: '/${DocenteListaCursoScreen.screenName}',
      name: DocenteListaCursoScreen.screenName,
      builder: (context, state) => const DocenteListaCursoScreen(),
    ),
    GoRoute(
      path: '/${DocenteCursoDetalleScreen.screenName}',
      name: DocenteCursoDetalleScreen.screenName,
      builder: (context, state) => const DocenteCursoDetalleScreen(),
    ),

    //RUTAS PARA EL ESTUDIANTE
    GoRoute(
      path: '/${EstudiantePerfilScreen.screenName}',
      name: EstudiantePerfilScreen.screenName,
      builder: (context, state) => const EstudiantePerfilScreen(),
    ),
    GoRoute(
      path: '/${EstudianteCursoScreen.screenName}',
      name: EstudianteCursoScreen.screenName,
      builder: (context, state) => const EstudianteCursoScreen(),
    ),
    GoRoute(
      path: '/${EstudianteEstadisticaScreen.screenName}',
      name: EstudianteEstadisticaScreen.screenName,
      builder: (context, state) => const EstudianteEstadisticaScreen(),
    ),
    GoRoute(
      path: '/${EstudianteMirarEncuestaScreen.screenName}',
      name: EstudianteMirarEncuestaScreen.screenName,
      builder: (context, state) => const EstudianteMirarEncuestaScreen(),
    ),
    GoRoute(
      path: '/${EstudianteMenuDScreen.screenName}',
      name: EstudianteMenuDScreen.screenName,
      builder: (context, state) => const EstudianteMenuDScreen(),
    ),
    GoRoute(
      path: '/${EstudianteEncuestasResponder.screenName}',
      name: EstudianteEncuestasResponder.screenName,
      builder: (context, state) => const EstudianteEncuestasResponder(),
    ),
    GoRoute(
      path:
          '/${EstudianteEncuestaDetallesScreen.screenName}/:idEncuesta/:idAsignacion',
      name:
          EstudianteEncuestaDetallesScreen.screenName, // Define un nombre único
      builder: (context, state) {
        final idEncuesta =
            int.tryParse(state.pathParameters['idEncuesta'] ?? '');
        final idAsignacion =
            int.tryParse(state.pathParameters['idAsignacion'] ?? '');
        if (idEncuesta == null && idAsignacion == null) {
          return const Scaffold(
            body: Center(
              child: Text('ID de encuesta y asignación no válido'),
            ),
          );
        }
        return EstudianteEncuestaDetallesScreen(idEncuesta: idEncuesta!, idAsignacion: idAsignacion!,);
      },
    ),
    GoRoute(
      path:
          '/${EstudianteEncuestaDetallesResponderScreen.screenName}/:idEncuesta/:idAsignacion',
      name:
          EstudianteEncuestaDetallesResponderScreen
          .screenName, // Define un nombre único
      builder: (context, state) {
        final idEncuesta =
            int.tryParse(state.pathParameters['idEncuesta'] ?? '');
        final idAsignacion =
            int.tryParse(state.pathParameters['idAsignacion'] ?? '');
        if (idEncuesta == null && idAsignacion == null) {
          return const Scaffold(
            body: Center(
              child: Text('ID de encuesta y asignación no válido'),
            ),
          );
        }
        return EstudianteEncuestaDetallesResponderScreen(
          idEncuesta: idEncuesta!,
          idAsignacion: idAsignacion!,
        );
      },
    ),
    GoRoute(
      path:
          '/${EstudianteDiagramaAsignacionScreen.screenName}/:idEncuesta/:idAsignacion',
      name:
          EstudianteDiagramaAsignacionScreen
          .screenName, // Define un nombre único
      builder: (context, state) {
        final idEncuesta =
            int.tryParse(state.pathParameters['idEncuesta'] ?? '');
        final idAsignacion =
            int.tryParse(state.pathParameters['idAsignacion'] ?? '');
        if (idEncuesta == null && idAsignacion == null) {
          return const Scaffold(
            body: Center(
              child: Text('ID de encuesta y asignación no válido'),
            ),
          );
        }
        return EstudianteDiagramaAsignacionScreen(
          idEncuesta: idEncuesta!,
          idAsignacion: idAsignacion!,
        );
      },
    ),
    GoRoute(
      path: '/${EstudianteAsignaturaScreen.screenName}',
      name: EstudianteAsignaturaScreen.screenName,
      builder: (context, state) => const EstudianteAsignaturaScreen(),
    ),
    GoRoute(
      path: '/${EstudianteMirarEncuestaCursoScreen.screenName}',
      name: EstudianteMirarEncuestaCursoScreen.screenName,
      builder: (context, state) => const EstudianteMirarEncuestaCursoScreen(),
    ),
  ],
);
