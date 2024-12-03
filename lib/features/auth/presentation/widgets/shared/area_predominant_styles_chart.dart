import 'dart:convert';
import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreaPredominantStylesChart extends ConsumerWidget {
  final List<String> responses;
  final String id; // Identificador único para el provider
  final AsignacionDetalles asignacion;

  const AreaPredominantStylesChart({
    super.key,
    required this.responses,
    required this.id,
    required this.asignacion
  });

  Map<String, Map<String, int>> _processAreaPredominantStyles(
      List<String> responses) {
    final Map<String, Map<String, int>> result = {};

    for (var response in responses) {
      final Map<String, dynamic> data =
          jsonDecode(response.replaceAll("'", '"'));

      data.forEach((category, details) {
        final predominant = details['predominante'] as String;

        result.putIfAbsent(category, () => {});
        result[category]![predominant] =
            (result[category]![predominant] ?? 0) + 1;
      });
    }

    return result;
  }

  String _generarDatosParaInterpretacion(Map<String, Map<String, int>> data) {
    if (data.isEmpty) {
      return "No hay datos para interpretar.";
    }

    final buffer = StringBuffer("Resultados por áreas y estilos:\n");
    data.forEach((area, estilos) {
      buffer.writeln("Área: $area");
      estilos.forEach((estilo, count) {
        buffer.writeln("  $estilo: $count estudiantes.");
      });
      buffer.writeln(); // Espacio entre áreas
    });
    String contexto =
        'Se hizo el test de ${asignacion.encTitulo} a la  ${asignacion.curCarrera} en ${asignacion.matNombre} puedes darme una análisis e interpretación con recomendaciones.';

    return '$contexto ${buffer.toString()}. los datos fueron representados en un diagrama de barras, muestra muestra el total de todos los estilos de los estudiantes, respondeme en 100 palabras aproximadamente.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interpretacionProvider(id));

    final processedData = _processAreaPredominantStyles(responses);
    final categories = processedData.keys.toList();

    final maxValue = processedData.values
        .expand((styles) => styles.values)
        .reduce((a, b) => a > b ? a : b);

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

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              groupsSpace: 30,
              barGroups: List.generate(categories.length, (index) {
                final category = categories[index];
                final styles = processedData[category]!;

                return BarChartGroupData(
                  x: index,
                  barsSpace: 5,
                  barRods: styles.entries.map((entry) {
                    final style = entry.key;
                    final count = entry.value;

                    return BarChartRodData(
                      fromY: 0,
                      toY: count.toDouble(),
                      color: colorMap[style] ?? Colors.grey,
                      width: 14,
                      borderRadius: BorderRadius.circular(5),
                    );
                  }).toList(),
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
                      if (index < 0 || index >= categories.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        angle: 24.4,
                        axisSide: meta.axisSide,
                        child: Text(
                          categories[index],
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
