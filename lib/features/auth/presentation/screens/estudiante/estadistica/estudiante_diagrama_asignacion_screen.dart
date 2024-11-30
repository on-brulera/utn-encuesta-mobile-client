import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_historial_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/stacked_bar_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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
          .obtenerHistorialByAsignacinId(widget.idAsignacion);
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
    final encuestaHistorialState = ref.watch(estudianteHistorialProvider);

    if (encuestaHistorialState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Diagrama de la Encuesta'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (encuestaHistorialState.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Diagrama de la Encuesta'),
        ),
        body: Center(
          child: Text(
            encuestaHistorialState.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (encuestaHistorialState.historial == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Diagrama de la Encuesta'),
        ),
        body: const Center(
          child: Text('No se encontraron detalles.'),
        ),
      );
    }

    final historial = encuestaHistorialState.historial!;

    // Verificar si "notaEstudiante" contiene "Sin nota"
    final isSinNota = historial.notaEstudiante == 'Sin nota';

    // Si "Sin nota", procesar resultadoEncuesta para usar en StackedBarChart
    Map<String, Map<String, dynamic>> resultadoEncuestaData = {};
    if (isSinNota) {
      resultadoEncuestaData =
          (json.decode(historial.resultadoEncuesta.replaceAll("'", '"'))
                  as Map<String, dynamic>)
              .map((key, value) {
        final detalle = (value['detalle'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int));
        return MapEntry(key, {
          'diferencia': value['diferencia'],
          'predominante': value['predominante'],
          'detalle': detalle,
        });
      });
    } else {
      final Map<String, double> notasMap =
          (json.decode(historial.notaEstudiante) as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toDouble()));
      return Scaffold(
        appBar: AppBar(
          title: const Text('Diagrama de la Encuesta'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            _buildInfoEncuestaCard(historial, ''),
            const SizedBox(height: 50),
            ResultadoEncuestaChart(notasEstudiante: notasMap),
            const SizedBox(height: 200),
          ],
        ),
      );
    }

    // Mostrar el gráfico StackedBarChart si "notaEstudiante" es "Sin nota"
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagrama de la Encuesta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildInfoEncuestaCard(historial,
              "Los resultados obtenidos reflejan los estilos de aprendizaje predominantes en cada dimensión evaluada. A continuación, se presenta un análisis detallado de cada estilo, indicando la diferencia entre las preferencias, el estilo predominante identificado y los valores correspondientes a cada dimensión evaluada"),
          const SizedBox(height: 50),
          StackedBarChart(data: resultadoEncuestaData),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _buildInfoEncuestaCard(Historial historial, String texto) {
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
          AppTexts.commentNotification(
              'Identificación del estudiante: ${historial.estudianteCedula}'),
          AppSpaces.vertical15,
          AppSpaces.vertical5,
          texto.isEmpty
              ? AppTexts.subTitle(
                  'Resultado de la encuesta \n ${historial.resultadoEncuesta}')
              : AppTexts.subTitle(texto),
          AppSpaces.vertical15,
          AppTexts.numberNotification(
              'Finalizado el ${DateFormat('dd-MM-yyyy').format(historial.fechaEncuesta)}'),
        ],
      ),
    );
  }
}

class ResultadoEncuestaChart extends StatelessWidget {
  final Map<String, double> notasEstudiante;

  const ResultadoEncuestaChart({super.key, required this.notasEstudiante});

  @override
  Widget build(BuildContext context) {
    final double maxNota = notasEstudiante.values.isEmpty
        ? 1.0
        : notasEstudiante.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 400, // Define una altura específica para el gráfico.
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxNota + 0.5, // Suponiendo que la escala es de 0 a 5.
          barGroups:
              notasEstudiante.entries.toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key; // Índice de la entrada.
            final entry = mapEntry.value; // Entrada actual (key, value).

            return BarChartGroupData(
              x: index, // Usa el índice como posición en el eje X.
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.blue, // Personaliza el color.
                  width: 20,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1, // Espaciado en el eje Y.
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(value.toString(),
                      style: const TextStyle(fontSize: 12));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 100,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= notasEstudiante.keys.length) {
                    return const SizedBox
                        .shrink(); // Maneja casos fuera de rango.
                  }
                  final key = notasEstudiante.keys.elementAt(index);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    angle: 26,
                    child: Text(
                      key,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
