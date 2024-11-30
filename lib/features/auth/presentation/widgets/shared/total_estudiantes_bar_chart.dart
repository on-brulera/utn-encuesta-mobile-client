import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalEstudiantesBarChart extends StatelessWidget {
  final List<EstudianteResultado> estudiantes;

  const TotalEstudiantesBarChart({super.key, required this.estudiantes});

  @override
  Widget build(BuildContext context) {
    // Agrupa estudiantes por estilo y cuenta el total por estilo
    final Map<String, int> totalPorEstilo = _contarEstudiantesPorEstilo();

    // Convierte los datos en listas para la representación gráfica
    final estilos = totalPorEstilo.keys.toList();
    final totales = totalPorEstilo.values.toList();

    return SizedBox(
      height: 350, // Altura específica para el gráfico.
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: totales.isNotEmpty
              ? (totales.reduce((a, b) => a > b ? a : b) + 1).toDouble()
              : 1.0,
          barGroups: List.generate(estilos.length, (index) {
            return BarChartGroupData(
              x: index, // Índice del estilo en el eje X.
              barRods: [
                BarChartRodData(
                  toY: totales[index]
                      .toDouble(), // Total de estudiantes para el estilo.
                  color: Colors.blue, // Personaliza el color de la barra.
                  width: 15,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50, // Aumentar el espacio reservado.
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= estilos.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    angle: 24.4,
                    child: Text(
                      estilos[index], // Nombre del estilo en el eje X.
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
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
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }

  /// Cuenta el número total de estudiantes por estilo de aprendizaje.
  Map<String, int> _contarEstudiantesPorEstilo() {
    final Map<String, int> totalPorEstilo = {};

    for (final estudiante in estudiantes) {
      final estilo = _extraerEstilo(estudiante.hisResultadoEncuesta);
      totalPorEstilo[estilo] = (totalPorEstilo[estilo] ?? 0) + 1;
    }

    return totalPorEstilo;
  }

  /// Extrae el estilo de aprendizaje del texto.
  String _extraerEstilo(String hisResultadoEncuesta) {
    const prefijoEstilo = "El estilo predominante es: ";
    const prefijoEmpate =
        "Hay un empate entre las inteligencias predominantes: ";
    const prefijoEmpateDos ="Hay un empate entre los estilos: ";

    if (hisResultadoEncuesta.startsWith(prefijoEstilo)) {
      return hisResultadoEncuesta.substring(prefijoEstilo.length).trim();
    }

    if (hisResultadoEncuesta.startsWith(prefijoEmpate)) {
      final estilosEmpatados = hisResultadoEncuesta
          .substring(prefijoEmpate.length)
          .split(', ')
          .map((estilo) => estilo.trim())
          .join(', ');
      return estilosEmpatados;
    }

    if (hisResultadoEncuesta.startsWith(prefijoEmpateDos)) {
      final estilosEmpatados = hisResultadoEncuesta
          .substring(prefijoEmpateDos.length)
          .split(', ')
          .map((estilo) => estilo.trim())
          .join(', ');
      return estilosEmpatados;
    }

    return "Otro";
  }

  String generarResumenEstilos() {
    final Map<String, int> totalPorEstilo = _contarEstudiantesPorEstilo();

    if (totalPorEstilo.isEmpty) {
      return "No hay datos disponibles sobre los estilos de aprendizaje.";
    }

    final buffer = StringBuffer("Del total de estudiantes:\n");

    totalPorEstilo.forEach((estilo, total) {
      buffer.writeln("$total pertenecen al estilo $estilo.");
    });

    return buffer.toString();
  }
}