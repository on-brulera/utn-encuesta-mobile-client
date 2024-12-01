import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PredominantStylesChart extends StatelessWidget {
  final List<String> responses;

  const PredominantStylesChart({super.key, required this.responses});

  Map<String, int> _processPredominantStyles(List<String> responses) {
    final Map<String, int> result = {};

    for (var response in responses) {
      // Decodificar cada string de respuesta
      final Map<String, dynamic> data =
          jsonDecode(response.replaceAll("'", '"'));

      // Encontrar el estilo con la mayor "diferencia" en la respuesta del estudiante
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

  @override
  Widget build(BuildContext context) {
    final processedData = _processPredominantStyles(responses);

    // Obtener el valor máximo para ajustar el eje Y
    final maxValue = processedData.values.reduce((a, b) => a > b ? a : b);

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

    final styles = processedData.keys.toList();

    return SizedBox(
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
