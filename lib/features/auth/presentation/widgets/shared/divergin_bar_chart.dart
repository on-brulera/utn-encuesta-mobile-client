import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DivergingBarChart extends StatelessWidget {
  final Map<String, Map<String, dynamic>> data;

  const DivergingBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final categories = data.keys.toList();

    return SizedBox(
      height: 350,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(categories.length, (index) {
            final category = categories[index];
            final difference = data[category]!['diferencia'] as int;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: difference.toDouble(),
                  color: difference > 0 ? Colors.green : Colors.red,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    Text(value.toInt().toString()),
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
                    child: Text(categories[index]),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
          alignment: BarChartAlignment.spaceAround,
          maxY: data.values
                  .map((e) => (e['diferencia'] as int).abs())
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble() +
              1,
        ),
      ),
    );
  }
}
