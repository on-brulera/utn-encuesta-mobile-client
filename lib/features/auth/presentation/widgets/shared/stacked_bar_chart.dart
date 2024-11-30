import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StackedBarChart extends StatelessWidget {
  final Map<String, Map<String, dynamic>> data;

  const StackedBarChart({super.key, required this.data});

  double getMaxY(Map<String, Map<String, dynamic>> data) {
    try {
      return data.values
              .expand((e) => (e['detalle'] as Map<String, int>).values)
              .reduce((a, b) => a > b ? a : b)
              .toDouble() +
          1;
    } catch (_) {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = data.keys.toList();

    // Mapa de colores para cada estilo
    final colorMap = {
      "Activo-Reflexivo": Colors.blue,
      "Sensorial-Intuitivo": Colors.green,
      "Visual-Verbal": Colors.purple,
      "Secuencial-Global": Colors.red,
    };

    return SizedBox(
      height: 350,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 30, // Espacio entre los grupos de barras
          barGroups: List.generate(categories.length, (index) {
            final category = categories[index];
            final details = data[category]!['detalle'] as Map<String, int>;

            // Usar el color del mapa de colores para cada estilo
            final color = colorMap[category] ?? Colors.grey;

            return BarChartGroupData(
              x: index,
              barsSpace: 5, // Espacio entre las barras dentro del grupo
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: details['A']?.toDouble() ?? 0,
                  color: color.withOpacity(0.7), // Barra A con color más claro
                  width: 20,
                  borderRadius: BorderRadius.circular(5),
                ),
                BarChartRodData(
                  fromY: 0,
                  toY: details['B']?.toDouble() ?? 0,
                  color: color, // Barra B con color original
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

                  // Obtener el color correspondiente
                  final color = colorMap[categories[index]] ?? Colors.grey;

                  return SideTitleWidget(
                    angle: 24.7,
                    axisSide: meta.axisSide,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: color, // Aplicar el color a la palabra
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
          maxY: getMaxY(data),
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}
