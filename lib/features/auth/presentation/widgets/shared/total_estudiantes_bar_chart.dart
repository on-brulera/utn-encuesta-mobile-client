import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';

class TotalEstudiantesBarChart extends ConsumerWidget {
  final List<EstudianteResultado> estudiantes;
  final String id;
  final AsignacionDetalles asignacion;

  const TotalEstudiantesBarChart(
      {super.key,
      required this.estudiantes,
      required this.id,
      required this.asignacion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interpretacionProvider(id));

    // Agrupa estudiantes por estilo y cuenta el total por estilo
    final Map<String, int> totalPorEstilo = _contarEstudiantesPorEstilo();
    final estilos = totalPorEstilo.keys.toList();
    final totales = totalPorEstilo.values.toList();

    return Column(
      children: [
        SizedBox(
          height: 350, // Altura específica para el gráfico.
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: totales.isNotEmpty
                  ? (totales.reduce((a, b) => a > b ? a : b) + 1).toDouble()
                  : 1.0,
              barGroups: List.generate(estilos.length, (index) {
                return BarChartGroupData(
                  x: index,
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
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final datosInterpretacion = _generarDatosParaInterpretacion();
            ref.watch(interpretacionProvider(id).notifier).cargarInterpretacion(
                datosInterpretacion); // Llama al método del provider
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
    const prefijoEmpateDos = "Hay un empate entre los estilos: ";

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

  String _generarDatosParaInterpretacion() {
    final Map<String, int> totalPorEstilo = _contarEstudiantesPorEstilo();
    if (totalPorEstilo.isEmpty) {
      return "No hay datos disponibles para generar la interpretación.";
    }

    final buffer = StringBuffer("Datos para interpretación:\n");
    totalPorEstilo.forEach((estilo, total) {
      buffer.writeln("$estilo: $total estudiantes");
    });

    String contexto =
        'Se hizo el test de ${asignacion.encTitulo} a la  ${asignacion.curCarrera} en ${asignacion.matNombre} puedes darme una análisis e interpretación con recomendaciones.';

    return '$contexto ${buffer.toString()}. los datos fueron representados en un diagrama de barras, muestra el total de estudiantes que pertenecen a un estilo, respondeme en 100 palabras aproximadamente.';
  }
}
