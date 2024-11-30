import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResultadoEncuestaScatterChart extends StatelessWidget {
  final List<EstudianteResultado> estudiantes;

  const ResultadoEncuestaScatterChart({super.key, required this.estudiantes});

  @override
  Widget build(BuildContext context) {
    // Extraer estilos únicos y asignar índices únicos
    final estilos = _extraerEstilosUnicos(estudiantes);
    final Map<String, int> estilosIndices = {
      for (var i = 0; i < estilos.length; i++) estilos[i]: i
    };

    // Generar colores dinámicamente
    final Map<String, Color> estiloColores =
        _generarColoresParaEstilos(estilos);

    return SizedBox(
      height: 400, // Define una altura específica para el gráfico.
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: estudiantes.map((estudiante) {
            final estilo = _extraerEstilo(estudiante.hisResultadoEncuesta);
            final xValue = estilosIndices[estilo]?.toDouble() ?? -1.0;
            return ScatterSpot(
              xValue, // Índice del estilo en el eje X.
              estudiante.notNota, // Nota en el eje Y.
              show: true,
              dotPainter: FlDotCirclePainter(
                radius: 4, // Tamaño del punto.
                color: estiloColores[estilo] ?? Colors.grey, // Color dinámico.
              ),
            );
          }).toList(),
          minX: -1, // Comienza antes del primer estilo.
          maxX: estilos.length.toDouble(), // Último índice del estilo.
          minY: 0.0, // Nota mínima.
          maxY: 10.0, // Nota máxima.
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                interval: 1, // Mostrar un título por índice.
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= estilos.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    angle: 24.4, // Texto cruzado.
                    axisSide: meta.axisSide,
                    child: Text(
                      estilos[index], // Estilo correspondiente en el eje X.
                      style: const TextStyle(fontSize: 10),
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

  /// Extrae una lista de estilos únicos de los estudiantes.
  List<String> _extraerEstilosUnicos(List<EstudianteResultado> estudiantes) {
    final estilos = estudiantes
        .map((e) => _extraerEstilo(e.hisResultadoEncuesta))
        .toSet()
        .toList();
    estilos.sort(); // Ordenar alfabéticamente para consistencia.
    return estilos;
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
      return hisResultadoEncuesta
          .substring(prefijoEmpate.length)
          .split(', ')
          .map((e) => e.trim())
          .join(','); // Combina estilos empatados como uno único.
    }

    if (hisResultadoEncuesta.startsWith(prefijoEmpateDos)) {
      return hisResultadoEncuesta
          .substring(prefijoEmpateDos.length)
          .split(', ')
          .map((e) => e.trim())
          .join(','); // Combina estilos empatados como uno único.
    }

    return "Otro";
  }

  /// Genera colores dinámicos para cada estilo.
  Map<String, Color> _generarColoresParaEstilos(List<String> estilos) {
    final List<Color> coloresBase = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.indigo,
      Colors.lime,
      Colors.black,
      Colors.redAccent,
      Colors.blueGrey,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.tealAccent
    ];

    final Map<String, Color> estiloColores = {};
    for (var i = 0; i < estilos.length; i++) {
      estiloColores[estilos[i]] = coloresBase[i % coloresBase.length];
    }
    return estiloColores;
  }
}
