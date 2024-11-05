import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/configuration/const/menu_opcion.dart';
import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocenteMenuDScreen extends StatelessWidget {
  static String screenName = 'menudocentescreen';
  const DocenteMenuDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //ITEMS PARA LOS MODULOS

    opcionesMenuDocente[0].callback =
        () => context.go('/${DocenteDisenarEncuestaScreen.screenName}');
    opcionesMenuDocente[1].callback =
        () => context.go('/${DocenteCursoAsignacionScreen.screenName}');
    opcionesMenuDocente[2].callback =
        () => context.go('/${DocenteEstadisticaScreen.screenName}');
    opcionesMenuDocente[3].callback =
        () => context.go('/${DocentePerfilScreen.screenName}');

    List<Notificacion> notificaciones = [
      Notificacion(
          texto: 'Tiene 10 tests para su investigación', callback: () => context.go('/${DocenteListaEncuestaScreen.screenName}')),
      Notificacion(texto: 'Tiene 10 cursos a su disposición', callback: () {}),
      Notificacion(
          texto: 'Mire las estadísticas del último curso', callback: () {}),
    ];

    return Scaffold(
      body: SafeArea(
        child: FadeIn(
          duration: const Duration(seconds: 2),
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
                    ...opcionesMenuDocente.map((opcion) {
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
    );
  }
}