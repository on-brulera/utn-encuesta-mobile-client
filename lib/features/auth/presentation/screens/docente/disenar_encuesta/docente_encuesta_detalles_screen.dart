import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/encuesta_detalles_provider.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:intl/intl.dart';

class DocenteEncuestaDetallesScreen extends ConsumerStatefulWidget {
  static String screenName = 'docenteEncuestaDetallesScreen';
  final int idEncuesta;

  const DocenteEncuestaDetallesScreen({
    super.key,
    required this.idEncuesta,
  });

  @override
  createState() => _DocenteEncuestaDetallesScreenState();
}

class _DocenteEncuestaDetallesScreenState
    extends ConsumerState<DocenteEncuestaDetallesScreen> {
  late int currentIdEncuesta;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final encuestaDetallesNotifier =
          ref.read(encuestaDetallesProvider.notifier);
      encuestaDetallesNotifier.cargarNuevaEncuesta(widget.idEncuesta);
    });
  }

  @override
  void didUpdateWidget(covariant DocenteEncuestaDetallesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idEncuesta != widget.idEncuesta) {
      Future.microtask(() {
        final encuestaDetallesNotifier =
            ref.read(encuestaDetallesProvider.notifier);
        encuestaDetallesNotifier.cargarNuevaEncuesta(widget.idEncuesta);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final encuestaDetallesState = ref.watch(encuestaDetallesProvider);

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
                            encuestaDetallesState.detalles!.preguntas),
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

  Widget _buildPreguntasCard(List<PreguntaOpciones> preguntas) {
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
                  Text(
                    '${preguntaDetalle.pregunta.orden}. ${preguntaDetalle.pregunta.enunciado}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...preguntaDetalle.opciones.map((opcion) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppTexts.softText(
                          '${opcion.valorCualitativo}. ${opcion.texto}'),
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
