import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RespuestaEncuestaHorizontalBarChart extends StatelessWidget {
  final int respondieronEncuesta;
  final int noRespondieron;

  const RespuestaEncuestaHorizontalBarChart({
    super.key,
    required this.respondieronEncuesta,
    required this.noRespondieron,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Define la altura del gráfico.
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (respondieronEncuesta + noRespondieron)
              .toDouble(), // Escala basada en el total.
          barGroups: [
            BarChartGroupData(
              x: 0, // Índice para "Respondieron".
              barRods: [
                BarChartRodData(
                  toY: respondieronEncuesta.toDouble(),
                  width: 20,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1, // Índice para "No Respondieron".
              barRods: [
                BarChartRodData(
                  toY: noRespondieron.toDouble(),
                  width: 20,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ],
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              tooltipRoundedRadius: 8,
              tooltipBorder: BorderSide(color: Colors.grey.shade300, width: 1),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String label =
                    group.x == 0 ? 'Respondieron' : 'No Respondieron';
                return BarTooltipItem(
                  '$label\n${rod.toY.toInt()} estudiantes',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 100,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Respondieron',
                          style: TextStyle(fontSize: 12));
                    case 1:
                      return const Text('No Respondieron',
                          style: TextStyle(fontSize: 12));
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),

          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
