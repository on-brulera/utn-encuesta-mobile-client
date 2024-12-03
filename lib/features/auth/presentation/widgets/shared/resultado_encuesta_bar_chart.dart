import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';

class ResultadoEncuestaBarChart extends ConsumerWidget {
  final List<EstudianteResultado> estudiantes;
  final String id;
  final AsignacionDetalles asignacion;

  const ResultadoEncuestaBarChart(
      {super.key, required this.estudiantes, required this.id, required this.asignacion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtén el estado del provider
    final state = ref.watch(interpretacionProvider(id));

    // Agrupa estudiantes por estilo y calcula el promedio por estilo
    final Map<String, List<double>> agrupadoPorEstilo =
        _agruparPorEstilo(estudiantes);
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

    return Column(
      children: [
        SizedBox(
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
                      toY:
                          promedios[index], // Promedio de notas para el estilo.
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
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final datosInterpretacion =
                _generarDatosParaInterpretacion(agrupadoPorEstilo);
            ref
                .watch(interpretacionProvider(id).notifier)
                .cargarInterpretacion(datosInterpretacion);
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

  /// Genera un string con los datos del gráfico para la interpretación.
  String _generarDatosParaInterpretacion(
      Map<String, List<double>> agrupadoPorEstilo) {
    final buffer = StringBuffer("Interpretación del gráfico:\n");

    agrupadoPorEstilo.forEach((estilo, notas) {
      final promedio = notas.reduce((a, b) => a + b) / notas.length;
      buffer.writeln(
          "$estilo: Promedio ${promedio.toStringAsFixed(2)} con ${notas.length} estudiantes.");
    });


  String contexto =
        'Se hizo el test de ${asignacion.encTitulo} a la  ${asignacion.curCarrera} en ${asignacion.matNombre}  en la Parcial ${asignacion.parId} puedes darme una análisis e interpretación con recomendaciones.';

    return '$contexto ${buffer.toString()}. los datos fueron representados en un diagrama de barras, muestra el promedio de notas de estudiantes que pertenecen a un estilo, respondeme en 100 palabras aproximadamente.';
  }

  /// Agrupa estudiantes por estilo y devuelve un mapa de estilo -> lista de notas.
  Map<String, List<double>> _agruparPorEstilo(
      List<EstudianteResultado> estudiantes) {
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
