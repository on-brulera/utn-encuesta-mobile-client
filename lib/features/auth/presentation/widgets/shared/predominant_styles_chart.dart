import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PredominantStylesChart extends StatelessWidget {
  final List<String> responses;

  const PredominantStylesChart({super.key, required this.responses});

  Map<String, Map<String, int>> _processResponses(List<String> responses) {
    final Map<String, Map<String, int>> result = {};

    for (var response in responses) {
      // Decodificar cada string de respuesta
      final Map<String, dynamic> data =
          jsonDecode(response.replaceAll("'", '"'));

      // Recorrer cada categoría y contar el estilo predominante
      data.forEach((category, details) {
        final predominant = details['predominante'];
        result.putIfAbsent(category, () => {});
        result[category]![predominant] =
            (result[category]![predominant] ?? 0) + 1;
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final processedData = _processResponses(responses);
    final categories = processedData.keys.toList();

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
      height: 350,
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
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
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
                    axisSide: meta.axisSide,
                    child: Text(
                      categories[index],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}
