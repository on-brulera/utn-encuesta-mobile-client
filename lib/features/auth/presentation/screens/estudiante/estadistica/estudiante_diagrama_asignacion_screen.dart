import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_historial_encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:intl/intl.dart';

class EstudianteDiagramaAsignacionScreen extends ConsumerStatefulWidget {
  static String screenName = 'estudianteEncuestaHistorialScreen';
  final int idEncuesta;
  final int idAsignacion;

  const EstudianteDiagramaAsignacionScreen(
      {super.key, required this.idEncuesta, required this.idAsignacion});

  @override
  createState() => _EstudianteEncuestaDetallesScreenState();
}

class _EstudianteEncuestaDetallesScreenState
    extends ConsumerState<EstudianteDiagramaAsignacionScreen> {
  late int currentIdEncuesta;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final encuestaHistorialNotifier =
          ref.read(estudianteHistorialProvider.notifier);
      encuestaHistorialNotifier
          .obtenerHistorialByAsignacinId(
          widget.idAsignacion);
    });
  }

  @override
  void didUpdateWidget(covariant EstudianteDiagramaAsignacionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idEncuesta != widget.idEncuesta) {
      final encuestaHistorialNotifier =
          ref.read(estudianteHistorialProvider.notifier);
      encuestaHistorialNotifier
          .obtenerHistorialByAsignacinId(widget.idAsignacion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final encuestaHistorialState =
        ref.watch(estudianteHistorialProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagrama de la Encuesta'),
      ),
      body: encuestaHistorialState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : encuestaHistorialState.error != null
              ? Center(
                  child: Text(
                    encuestaHistorialState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : encuestaHistorialState.historial != null
                  ? ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildInfoEncuestaCard(
                            encuestaHistorialState.historial!),
                        const SizedBox(height: 15),                        
                      ],
                    )
                  : const Center(child: Text('No se encontraron detalles.')),
    );
  }

  Widget _buildInfoEncuestaCard(Historial historial) {
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
          AppTexts.subTitle(historial.estudianteCedula),
          AppSpaces.vertical5,
          AppTexts.perfilText('Nota estudiante: ${historial.notaEstudiante}'),
          AppSpaces.vertical5,
          AppTexts.numberNotification('Resultado encuesta: ${historial.resultadoEncuesta}'),
          AppSpaces.vertical5,
          AppTexts.numberNotification(
              'Finalizado el ${DateFormat('dd-MM-yyyy').format(historial.fechaEncuesta)}'),
        ],
      ),
    );
  } 

}
