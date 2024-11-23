import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/encuesta_detalles_con_respuesta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:intl/intl.dart';

class EstudianteEncuestaDetallesScreen extends ConsumerStatefulWidget {
  static String screenName = 'estudianteEncuestaDetallesScreen';
  final int idEncuesta;
  final int idAsignacion;

  const EstudianteEncuestaDetallesScreen(
      {super.key, required this.idEncuesta, required this.idAsignacion});

  @override
  createState() => _EstudianteEncuestaDetallesScreenState();
}

class _EstudianteEncuestaDetallesScreenState
    extends ConsumerState<EstudianteEncuestaDetallesScreen> {
  late int currentIdEncuesta;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final encuestaDetallesNotifier =
          ref.read(encuestaDetallesConRespuestaProvider.notifier);
      encuestaDetallesNotifier.cargarNuevaEncuesta(
          widget.idEncuesta, widget.idAsignacion);
    });
  }

  @override
  void didUpdateWidget(covariant EstudianteEncuestaDetallesScreen oldWidget) {
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
                            encuestaDetallesState.respuestas!)
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
          AppTexts.textNotification('Estilos'),
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

  Widget _buildPreguntasCard(
      List<PreguntaOpciones> preguntas, List<Respuesta> respuestas) {
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
                    // Verificar si la opción está en las respuestas
                    final bool isAnswered = respuestas.any(
                      (respuesta) =>
                          respuesta.opcionId == opcion.id &&
                          respuesta.preguntaId == preguntaDetalle.pregunta.id,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width:
                            double.infinity, // Ocupa todo el ancho disponible
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isAnswered
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
}
