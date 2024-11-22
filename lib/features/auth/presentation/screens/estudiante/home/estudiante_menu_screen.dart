import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/utils/configuration/const/menu_opcion.dart';
import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
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
        () => context.pushNamed(EstudianteMirarEncuestaScreen.screenName);
    opcionesMenuEstudiante[1].callback =
        () => context.pushNamed(EstudianteCursoScreen.screenName);
    opcionesMenuEstudiante[2].callback =
        () => context.pushNamed(EstudianteEstadisticaScreen.screenName);
    opcionesMenuEstudiante[3].callback =
        () => context.pushNamed(EstudiantePerfilScreen.screenName);

    List<Notificacion> notificaciones = [
      Notificacion(
          texto: 'Tienes 1 encuesta por responder',
          callback: () =>
              context.pushNamed(EstudianteEncuestasResponder.screenName)),
      Notificacion(
          texto: 'Mire las estadísticas de la última encuesta ',
          callback: () {}),
      Notificacion(
          texto: 'Habla con IA sobre tu estilo de aprendizaje',
          callback: () => context.pushNamed(ChatScreen.screenName,
              extra: UsuarioChat.estudiante)),
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
