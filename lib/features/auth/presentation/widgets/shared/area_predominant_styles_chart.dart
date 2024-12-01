import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AreaPredominantStylesChart extends StatelessWidget {
  final List<String> responses;

  const AreaPredominantStylesChart({super.key, required this.responses});

  Map<String, Map<String, int>> _processAreaPredominantStyles(
      List<String> responses) {
    final Map<String, Map<String, int>> result = {};

    for (var response in responses) {
      // Decodificar cada string de respuesta
      final Map<String, dynamic> data =
          jsonDecode(response.replaceAll("'", '"'));

      // Para cada área, contar el estilo predominante
      data.forEach((category, details) {
        final predominant = details['predominante'] as String;

        result.putIfAbsent(category, () => {});
        result[category]![predominant] =
            (result[category]![predominant] ?? 0) + 1;
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final processedData = _processAreaPredominantStyles(responses);
    final categories = processedData.keys.toList();

    // Obtener el valor máximo para ajustar el eje Y
    final maxValue = processedData.values
        .expand((styles) => styles.values)
        .reduce((a, b) => a > b ? a : b);

    // Colores asignados a cada estilo
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

    return SizedBox(
      height: 400,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 30, // Espacio entre los grupos de barras
          barGroups: List.generate(categories.length, (index) {
            final category = categories[index];
            final styles = processedData[category]!;

            return BarChartGroupData(
              x: index,
              barsSpace: 5, // Espacio entre las barras dentro del grupo
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
                  // Mostrar solo números enteros desde 1 hasta el máximo
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
              sideTitles:
                  SideTitles(showTitles: false), // Ocultar el eje superior
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
          maxY: maxValue.toDouble(), // Ajustar el eje Y al valor máximo
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}
