import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/encuesta_detalles_con_respuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_asignaciones_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/estudiante/home/estudiante_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EstudianteEncuestaDetallesResponderScreen extends ConsumerStatefulWidget {
  static String screenName =
      'estudianteresponderEncuestaDetallesResponderScreen';
  final int idEncuesta;
  final int idAsignacion;

  const EstudianteEncuestaDetallesResponderScreen(
      {super.key, required this.idEncuesta, required this.idAsignacion});

  @override
  createState() => _EstudianteEncuestaDetallesResponderScreenState();
}

class _EstudianteEncuestaDetallesResponderScreenState
    extends ConsumerState<EstudianteEncuestaDetallesResponderScreen> {
  late int currentIdEncuesta;
  late Map<int, int> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = {};
    Future.microtask(() {
      final encuestaDetallesNotifier =
          ref.read(encuestaDetallesConRespuestaProvider.notifier);
      encuestaDetallesNotifier.cargarNuevaEncuesta(
          widget.idEncuesta, widget.idAsignacion);
    });
  }

  @override
  void didUpdateWidget(
      covariant EstudianteEncuestaDetallesResponderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idEncuesta != widget.idEncuesta) {
      Future.microtask(() {
        final encuestaDetallesNotifier =
            ref.read(encuestaDetallesConRespuestaProvider.notifier);
        encuestaDetallesNotifier.cargarNuevaEncuesta(
            widget.idEncuesta, widget.idAsignacion);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final encuestaDetallesState =
        ref.watch(encuestaDetallesConRespuestaProvider);

    final usuarioId = ref.read(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Encuesta'),
      ),
      body: encuestaDetallesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : encuestaDetallesState.error != null
              ? Center(
                  child: Text(
                    encuestaDetallesState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : encuestaDetallesState.detalles != null
                  ? ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildInfoEncuestaCard(
                            encuestaDetallesState.detalles!.encuesta),
                        const SizedBox(height: 15),
                        _buildEstilosCard(
                            encuestaDetallesState.detalles!.estilos),
                        const SizedBox(height: 15),
                        _buildPreguntasCard(
                            encuestaDetallesState.detalles!.preguntas,
                            int.tryParse(usuarioId.user!.id)!),
                        const SizedBox(height: 15),
                        _buildButtonResponder(context)
                      ],
                    )
                  : const Center(child: Text('No se encontraron detalles.')),
    );
  }

  Widget _buildInfoEncuestaCard(Encuesta encuesta) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.textNotification('Información'),
          const Divider(thickness: 1),
          AppSpaces.vertical5,
          AppTexts.subTitle(encuesta.titulo),
          AppSpaces.vertical5,
          AppTexts.perfilText(encuesta.autor),
          AppSpaces.vertical5,
          AppTexts.softText(
              encuesta.cuantitativa ? 'Cuantitativa' : 'Cualitativa'),
          AppSpaces.vertical5,
          AppTexts.numberNotification(encuesta.descripcion),
          AppSpaces.vertical5,
          AppTexts.numberNotification(
              'Creada el ${DateFormat('dd-MM-yyyy').format(encuesta.fechaCreacion.toLocal())}'),
        ],
      ),
    );
  }

  Widget _buildEstilosCard(List<Estilo> estilos) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.textNotification(
              'Se determinará tu estilo predominante entre:'),
          const Divider(thickness: 1),
          ...estilos.map((estilo) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: AppTexts.softText('- ${estilo.nombre}'));
          }),
        ],
      ),
    );
  }

  Widget _buildPreguntasCard(List<PreguntaOpciones> preguntas, int usuarioId) {
    final encuestaDetallesNotifier =
        ref.read(encuestaDetallesConRespuestaProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.textNotification('Preguntas'),
          const Divider(thickness: 1),
          ...preguntas.map((preguntaDetalle) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar la pregunta
                  Text(
                    '${preguntaDetalle.pregunta.orden}. ${preguntaDetalle.pregunta.enunciado}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Mostrar las opciones
                  ...preguntaDetalle.opciones.map((opcion) {
                    final bool isSelected =
                        selectedOptions[preguntaDetalle.pregunta.id] ==
                            opcion.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptions[preguntaDetalle.pregunta.id] =
                              opcion.id;

                          // Actualizar respuestas en el Notifier
                          encuestaDetallesNotifier.seleccionarRespuesta(
                            Respuesta(
                              id: 0, // ID asignado posteriormente
                              usuarioId: usuarioId, //
                              asignacionId: widget.idAsignacion,
                              preguntaId: preguntaDetalle.pregunta.id,
                              opcionId: opcion.id,
                              respuestaValorCuantitativo:
                                  opcion.valorCuantitativo.toInt(),
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width:
                              double.infinity, // Ocupa todo el ancho disponible
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green
                                    .withOpacity(0.2) // Fondo verde opaco claro
                                : Colors
                                    .transparent, // Fondo normal para otras opciones
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${opcion.valorCualitativo}. ${opcion.texto}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildButtonResponder(BuildContext context) {
    final encuestaDetallesState =
        ref.watch(encuestaDetallesConRespuestaProvider);
    final encuestaDetallesNotifier =
        ref.read(encuestaDetallesConRespuestaProvider.notifier);
    final asignacionNotifier = ref.read(estudianteAsignacionProvider.notifier);

    return FloatingActionButton(
      onPressed: () async {
        if (encuestaDetallesState.detalles!.preguntas.length !=
            encuestaDetallesState.respuestasEstudiante?.length) {
          // Mostrar SnackBar si faltan respuestas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Responda todas las preguntas',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return; // Detener la ejecución si no se cumplen las condiciones
        }

        // Mostrar cuadro de confirmación
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar Envío'),
              content: const Text(
                  'Al enviar las respuestas no podrá editarlas después. ¿Desea continuar?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancelar
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirmar
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );

        // Si el usuario cancela, no hacer nada
        if (confirmed != true) return;

        // Enviar respuestas
        await encuestaDetallesNotifier
            .enviarRespuestaEncuesta(widget.idAsignacion);
        await asignacionNotifier.obtenerAsignacionesEncuestas();

        if (context.mounted) {
          context.go('/${EstudianteMenuDScreen.screenName}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Respuestas enviadas correctamente',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );          
        }
      },
      child: encuestaDetallesState.isSubmitting
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Enviar Respuestas'),
    );
  }
}
