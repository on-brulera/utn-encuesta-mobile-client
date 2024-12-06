import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/mensaje_provider.dart';
import 'package:encuestas_utn/utils/configuration/const/menu_opcion.dart';
import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DocenteMenuDScreen extends ConsumerWidget {
  static String screenName = 'menudocentescreen';
  const DocenteMenuDScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //Para las encuestas
    final listaEncuestaState = ref.watch(listaEncuestaProvider);
    final listaEncuestaNotifier = ref.read(listaEncuestaProvider.notifier);
    final int numeroDeEncuestas = listaEncuestaState.encuestas.length;
    final String textoEncuestas = numeroDeEncuestas == 1
        ? 'Tiene $numeroDeEncuestas test para su investigación'
        : 'Tiene $numeroDeEncuestas tests para su investigación';

    //Para los cursos
    final listaCursoAsignacionState = ref.watch(listaAsignacionDetalleProvider);
    final listaCursoAsignacionNotifier =
        ref.read(listaAsignacionDetalleProvider.notifier);
    final int numeroDeCursos =
        listaCursoAsignacionState.cursosAsignaciones!.length;
    final String textoCursos = numeroDeEncuestas == 1
        ? 'Tiene $numeroDeCursos curso a su disposición'
        : 'Tiene $numeroDeCursos cursos a su disposición';

    // Cargar encuestas si aún no se han cargado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listaEncuestaState.encuestas.isEmpty &&
          !listaEncuestaState.isLoading) {
        listaEncuestaNotifier.obtenerTodasLasEncuestas();
      }
      if (!listaCursoAsignacionState.hasLoaded &&
          !listaCursoAsignacionState.isLoading) {
        listaCursoAsignacionNotifier.obtenerTodasLasAsignaciones();
      }
    });

    //ITEMS PARA LOS MODULOS

    opcionesMenuDocente[0].callback = () {
      ref.read(disenarEncuestaProvider.notifier).limpiarEncuesta();
      context.pushNamed(DocenteDisenarEncuestaScreen.screenName);
    };
    opcionesMenuDocente[1].callback =
        () => context.pushNamed(DocenteCursoAsignacionScreen.screenName);
    // opcionesMenuDocente[2].callback =
    //     () => context.pushNamed(DocenteEstadisticaScreen.screenName);
    opcionesMenuDocente[2].callback =
        () => context.pushNamed(DocentePerfilScreen.screenName);

    List<Notificacion> notificaciones = [
      Notificacion(
          texto: textoEncuestas,
          callback: () =>
              context.pushNamed(DocenteListaEncuestaScreen.screenName)),
      Notificacion(
          texto: textoCursos,
          callback: () =>
              context.pushNamed(DocenteListaCursoScreen.screenName)),
      Notificacion(
        texto: 'Habla con IA sobre los estilos de aprendizaje',
        callback: () async {
          try {
            // Mostrar un diálogo de carga
            showDialog(
              context: context,
              barrierDismissible:
                  false, // Evita que el usuario cierre el diálogo manualmente
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );

            // Esperar a que la operación asíncrona se complete
            await ref
                .read(mensajeProvider.notifier)
                .iniciarChat(UsuarioChat.docente);

            // Cerrar el diálogo de carga
            if (context.mounted) {
              Navigator.of(context).pop();
            }

            // Navegar a la pantalla del chat
            if (context.mounted) {
              context.pushNamed(
                ChatScreen.screenName,
                extra: UsuarioChat.docente,
              );
            }
          } catch (e) {
            // Cerrar el diálogo de carga en caso de error
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al iniciar el chat: $e')),
              );
            }
          }
        },
      ),
    ];

    return Scaffold(
      appBar: const CurstomAppBar(
        titulo: "Módulos",
      ),
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
      ),
    );
  }
}
