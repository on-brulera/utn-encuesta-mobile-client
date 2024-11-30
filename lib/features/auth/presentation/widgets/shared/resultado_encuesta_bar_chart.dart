import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResultadoEncuestaBarChart extends StatelessWidget {
  final List<EstudianteResultado> estudiantes;

  const ResultadoEncuestaBarChart({super.key, required this.estudiantes});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<double>> agrupadoPorEstilo = _agruparPorEstilo();
    final Map<String, double> promedioPorEstilo = agrupadoPorEstilo.map(
      (estilo, notas) {
        final promedio = notas.reduce((a, b) => a + b) / notas.length;
        return MapEntry(estilo, promedio);
      },
    );

    final estilos = promedioPorEstilo.keys.toList();
    final promedios = promedioPorEstilo.values.toList();
    final totales = estilos
        .map((estilo) => agrupadoPorEstilo[estilo]?.length ?? 0)
        .toList();

    return SizedBox(
      height: 350, // Altura específica para el gráfico.
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10.0, // Escala fija de 1 a 10.
          barGroups: List.generate(estilos.length, (index) {
            return BarChartGroupData(
              x: index, // Índice del estilo en el eje X.
              barRods: [
                BarChartRodData(
                  toY: promedios[index], // Promedio de notas para el estilo.
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          estilos[index], // Nombre del estilo en el eje X.
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '(${totales[index]})', // Total de estudiantes entre paréntesis.
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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

  /// Agrupa estudiantes por estilo y devuelve un mapa de estilo -> lista de notas.
  Map<String, List<double>> _agruparPorEstilo() {
    final Map<String, List<double>> agrupadoPorEstilo = {};

    for (final estudiante in estudiantes) {
      final estilo = _extraerEstilo(estudiante.hisResultadoEncuesta);
      agrupadoPorEstilo.putIfAbsent(estilo, () => []).add(estudiante.notNota);
    }

    return agrupadoPorEstilo;
  }

  /// Extrae el estilo de aprendizaje del texto.
  String _extraerEstilo(String hisResultadoEncuesta) {
    const prefijoEstilo = "El estilo predominante es: ";
    const prefijoEmpate =
        "Hay un empate entre las inteligencias predominantes: ";
    const prefijoEmpateDos = "Hay un empate entre los estilos: ";

    if (hisResultadoEncuesta.startsWith(prefijoEstilo)) {
      return hisResultadoEncuesta.substring(prefijoEstilo.length).trim();
    }

    if (hisResultadoEncuesta.startsWith(prefijoEmpate)) {
      final estilosEmpatados = hisResultadoEncuesta
          .substring(prefijoEmpate.length)
          .split(',')
          .map((estilo) => estilo.trim())
          .join(', ');
      return estilosEmpatados;
    }

    if (hisResultadoEncuesta.startsWith(prefijoEmpateDos)) {
      final estilosEmpatados = hisResultadoEncuesta
          .substring(prefijoEmpateDos.length)
          .split(',')
          .map((estilo) => estilo.trim())
          .join(', ');
      return estilosEmpatados;
    }

    return "Otro";
  }
}
