import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultadoEncuestaScatterChart extends ConsumerWidget {
  final List<EstudianteResultado> estudiantes;
  final String id;
  final AsignacionDetalles asignacion;

  const ResultadoEncuestaScatterChart(
      {super.key,
      required this.estudiantes,
      required this.id,
      required this.asignacion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el estado del provider
    final state = ref.watch(interpretacionProvider(id));

    // Extraer estilos únicos y asignar índices únicos
    final estilos = _extraerEstilosUnicos(estudiantes);
    final Map<String, int> estilosIndices = {
      for (var i = 0; i < estilos.length; i++) estilos[i]: i
    };

    // Generar colores dinámicamente
    final Map<String, Color> estiloColores =
        _generarColoresParaEstilos(estilos);

    return Column(
      children: [
        SizedBox(
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
                    color:
                        estiloColores[estilo] ?? Colors.grey, // Color dinámico.
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
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final datosInterpretacion =
                _generarDatosParaInterpretacion(estudiantes);

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

  /// Genera los datos para la interpretación.
  String _generarDatosParaInterpretacion(
      List<EstudianteResultado> estudiantes) {
    final Map<String, List<double>> agrupadoPorEstilo = {};

    for (final estudiante in estudiantes) {
      final estilo = _extraerEstilo(estudiante.hisResultadoEncuesta);
      agrupadoPorEstilo.putIfAbsent(estilo, () => []).add(estudiante.notNota);
    }

    final buffer = StringBuffer("Datos para la interpretación:\n");
    agrupadoPorEstilo.forEach((estilo, notas) {
      buffer.writeln("Estilo: $estilo, Notas: ${notas.join(", ")}");
    });

    String contexto =
        'Se hizo el test de ${asignacion.encTitulo} a la  ${asignacion.curCarrera} en ${asignacion.matNombre} puedes darme una análisis e interpretación con recomendaciones.';

    return '$contexto ${buffer.toString()}. los datos fueron representados en un diagrama de disperción, muestra las notas individuales de estudiantes que pertenecen a un estilo, respondeme en 100 palabras aproximadamente.';
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
