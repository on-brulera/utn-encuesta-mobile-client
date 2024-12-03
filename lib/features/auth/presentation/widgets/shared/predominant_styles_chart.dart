import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class PredominantStylesChart extends ConsumerWidget {
  final List<String> responses;
  final String id; // Identificador único para el provider
  final AsignacionDetalles asignacion;

  const PredominantStylesChart({
    super.key,
    required this.responses,
    required this.id,
    required this.asignacion
  });

  Map<String, int> _processPredominantStyles(List<String> responses) {
    final Map<String, int> result = {};

    for (var response in responses) {
      final Map<String, dynamic> data =
          jsonDecode(response.replaceAll("'", '"'));

      String? predominantStyle;
      int maxDifference = 0;

      data.forEach((category, details) {
        final difference = details['diferencia'] as int;
        final predominant = details['predominante'] as String;

        if (difference > maxDifference) {
          maxDifference = difference;
          predominantStyle = predominant;
        }
      });

      if (predominantStyle != null) {
        result[predominantStyle!] = (result[predominantStyle] ?? 0) + 1;
      }
    }

    return result;
  }

  String _generarDatosParaInterpretacion(Map<String, int> data) {
    if (data.isEmpty) {
      return "No hay datos disponibles para interpretar.";
    }

    final buffer = StringBuffer("Interpretación del gráfico:\n");
    data.forEach((estilo, count) {
      buffer.writeln("$estilo: $count estudiantes.");
    });

    String contexto =
        'Se hizo el test de ${asignacion.encTitulo} a la  ${asignacion.curCarrera} en ${asignacion.matNombre} puedes darme una análisis e interpretación con recomendaciones.';

    return '$contexto ${buffer.toString()}. los datos fueron representados en un diagrama de barras, muestra el total de estudiantes que pertenecen a un estilo, respondeme en 100 palabras aproximadamente.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interpretacionProvider(id));

    final processedData = _processPredominantStyles(responses);

    final maxValue = processedData.values.isEmpty
        ? 1
        : processedData.values.reduce((a, b) => a > b ? a : b);

    final colorMap = {
      "Activo": Colors.blue,
      "Reflexivo": Colors.orange,
      "Sensorial": Colors.green,
      "Intuitivo": Colors.yellow,
      "Visual": Colors.purple,
      "Verbal": Colors.pink,
      "Secuencial": Colors.red,
      "Global": Colors.teal,
    };

    final styles = processedData.keys.toList();

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              groupsSpace: 30,
              barGroups: List.generate(styles.length, (index) {
                final style = styles[index];
                final count = processedData[style]!;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      fromY: 0,
                      toY: count.toDouble(),
                      color: colorMap[style] ?? Colors.grey,
                      width: 20,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 1 == 0 && value > 0 && value <= maxValue) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= styles.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        angle: 24.4,
                        child: Text(
                          styles[index],
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              gridData: const FlGridData(show: true),
              maxY: maxValue.toDouble(),
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.linear,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final datosInterpretacion =
                _generarDatosParaInterpretacion(processedData);
            ref
                .read(interpretacionProvider(id).notifier)
                .cargarInterpretacion(datosInterpretacion);
          },
          child: state.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Cargar interpretación"),
        ),
        const SizedBox(height: 10),
        if (state.error != null)
          Text(
            state.error!,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          )
        else if (state.interpretacion != null)
          Text(
            state.interpretacion!,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
      ],
    );
  }
}
