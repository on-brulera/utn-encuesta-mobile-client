import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_asignaciones_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/mensaje_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/configuration/const/menu_opcion.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EstudianteMenuDScreen extends ConsumerWidget {
  static String screenName = 'menuestudiantescreen';
  const EstudianteMenuDScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsignacionEncuesta = ref.watch(estudianteAsignacionProvider);

    //ITEMS PARA LOS MODULOS
    opcionesMenuEstudiante[0].callback =
        () => context.pushNamed(EstudianteMirarEncuestaScreen.screenName);
    opcionesMenuEstudiante[1].callback =
        () => context.pushNamed(EstudianteCursoScreen.screenName);
    // opcionesMenuEstudiante[2].callback =
    //     () => context.pushNamed(EstudianteEstadisticaScreen.screenName);
    opcionesMenuEstudiante[2].callback =
        () => context.pushNamed(EstudiantePerfilScreen.screenName);

    List<Notificacion> notificaciones = [
      Notificacion(
          texto: obtenerTextoEncuestaResponder(
              stateAsignacionEncuesta.encuestasPorResponder!.length),
          callback: () {
            context.pushNamed(EstudianteEncuestasResponder.screenName);
          }),
      Notificacion(
        texto: 'Mire las estadísticas de la última asignación respondida',
        callback: () async {
          // Obtener la última encuesta respondida
          Encuesta? encuesta = await ref
              .read(estudianteAsignacionProvider.notifier)
              .obtenerUltimaEncuestaRespondida();

          if (context.mounted) {
            if (encuesta == null) {
              // Mostrar un SnackBar si no hay encuesta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'No has contestado la última asignación.',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            } else {
              // Redirigir a la página de detalles con los parámetros correspondientes
              context.pushNamed(
                EstudianteEncuestaDetallesScreen.screenName,
                pathParameters: {
                  'idEncuesta': encuesta.id.toString(),
                  'idAsignacion': encuesta.idAsignacion.toString(),
                },
              );
            }
          }
        },
      ),
      Notificacion(
        texto: 'Habla con IA sobre tu estilo de aprendizaje',
        callback: () async {
          try {
            // Esperar a que la operación asíncrona se complete
            await ref
                .read(mensajeProvider.notifier)
                .iniciarChat(UsuarioChat.estudiante);

            // Verificar que el contexto sigue montado antes de navegar
            if (context.mounted) {
              context.pushNamed(
                ChatScreen.screenName,
                extra: UsuarioChat.estudiante,
              );
            }
          } catch (e) {
            // Manejar errores si ocurren durante la operación asíncrona
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al iniciar el chat: $e')),
              );
            }
          }
        },
      ),
    ];

    return Scaffold(
      appBar: const CurstomAppBar(titulo: 'Módulos'),
      body: SafeArea(
        child: FadeIn(
          duration: const Duration(seconds: 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...opcionesMenuEstudiante.map((opcion) {
                        return Padding(
                          padding: (opcion.titulo == 'Perfil')
                              ? const EdgeInsets.only(left: 10, right: 10)
                              : const EdgeInsets.only(left: 10),
                          child: CustomMenuOpcionCard(opcion: opcion),
                        );
                      })
                    ],
                  ),
                ),
                AppSpaces.vertical20,
                ...notificaciones.map((notificacion) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: CustomNotificationCard(notificacion: notificacion),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String obtenerTextoEncuestaResponder(int numEncuestas) {
  if (numEncuestas == 0) return "No tienes encuestas por responder";
  if (numEncuestas == 1) return "Tienes $numEncuestas encuesta por responder";
  return "Tienes $numEncuestas encuestas por responder";
}
