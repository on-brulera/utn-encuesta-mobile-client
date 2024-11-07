import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/configuration/const/menu_opcion.dart';
import 'package:encuestas_utn/domain/entities/mensaje.dart';
import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstudianteMenuDScreen extends StatelessWidget {
  static String screenName = 'menuestudiantescreen';
  const EstudianteMenuDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //ITEMS PARA LOS MODULOS
    opcionesMenuEstudiante[0].callback =
        () => context.go('/${EstudianteMirarEncuestaScreen.screenName}');
    opcionesMenuEstudiante[1].callback =
        () => context.go('/${EstudianteCursoScreen.screenName}');
    opcionesMenuEstudiante[2].callback =
        () => context.go('/${EstudianteEstadisticaScreen.screenName}');
    opcionesMenuEstudiante[3].callback =
        () => context.go('/${EstudiantePerfilScreen.screenName}');

    List<Notificacion> notificaciones = [
      Notificacion(
          texto: 'Tienes 1 encuesta por responder',
          callback: () =>
              context.go('/${EstudianteEncuestasResponder.screenName}')),
      Notificacion(
          texto: 'Mire las estadísticas de la última encuesta ',
          callback: () {}),
      Notificacion(
          texto: 'Habla con IA sobre tu estilo de aprendizaje',
          callback: () => context.go('/${ChatScreen.screenName}',
              extra: UsuarioChat.estudiante)),
    ];

    return Scaffold(
      body: SafeArea(
        child: FadeIn(
          duration: const Duration(seconds: 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.title('Módulos'),
                      IconButton.outlined(
                          onPressed: () =>
                              context.go('/${LoginScreen.screenName}'),
                          icon: const Icon(Icons.exit_to_app_rounded))
                    ],
                  ),
                ),
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
