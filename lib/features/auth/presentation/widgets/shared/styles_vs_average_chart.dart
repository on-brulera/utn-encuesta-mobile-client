import 'dart:convert';
import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';

class StylesVsAverageChart extends ConsumerWidget {
  final List<EstudianteResultado> resultados;
  final String id; // Identificador único para el provider
  final AsignacionDetalles asignacion;

  const StylesVsAverageChart({
    super.key,
    required this.resultados,
    required this.id,
    required this.asignacion
  });

  Map<String, Map<String, dynamic>> _calculateStyleStatistics(
      List<EstudianteResultado> resultados) {
    final Map<String, List<double>> styleGrades = {};

    for (var resultado in resultados) {
      final Map<String, dynamic> data =
          jsonDecode(resultado.hisResultadoEncuesta.replaceAll("'", '"'));

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
        styleGrades
            .putIfAbsent(predominantStyle!, () => [])
            .add(resultado.notNota);
      }
    }

    final Map<String, Map<String, dynamic>> statistics = {};
    styleGrades.forEach((style, grades) {
      final average = grades.reduce((a, b) => a + b) / grades.length;
      statistics[style] = {
        'average': average,
        'count': grades.length,
      };
    });

    return statistics;
  }

  String _generateDataForInterpretation(
      Map<String, Map<String, dynamic>> statistics) {
    if (statistics.isEmpty) {
      return "No hay datos para interpretar.";
    }

    final buffer = StringBuffer("Resultados por estilo de aprendizaje:\n");
    statistics.forEach((style, data) {
      buffer.writeln(
          "$style: Promedio de notas = ${data['average'].toStringAsFixed(2)}, Número de estudiantes = ${data['count']}");
    });
    String contexto =
        'Se hizo el test de ${asignacion.encTitulo} a la ${asignacion.curCarrera} en ${asignacion.matNombre} puedes darme una análisis e interpretación con recomendaciones.';

    return '$contexto ${buffer.toString()}. los datos fueron representados en un cuadro, muestra el promedio de estudiantes que pertenecen a un estilo, respondeme en 100 palabras aproximadamente.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interpretacionProvider(id));

    final calculatedStatistics = _calculateStyleStatistics(resultados);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection:
              Axis.horizontal, // Desplazamiento horizontal si es necesario
          child: DataTable(
            columnSpacing: 16, // Ajustar espacio entre columnas
            columns: const [
              DataColumn(label: Text('Estilo de Aprendizaje')),
              DataColumn(label: Text('Promedio de Notas')),
              DataColumn(label: Text('Número de Estudiantes')),
            ],
            rows: calculatedStatistics.entries.map((entry) {
              return DataRow(
                cells: [
                  DataCell(Text(entry.key)), // Estilo de aprendizaje
                  DataCell(Text(
                      entry.value['average'].toStringAsFixed(2))), // Promedio
                  DataCell(Text(entry.value['count']
                      .toString())), // Número de estudiantes
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final dataForInterpretation =
                _generateDataForInterpretation(calculatedStatistics);
            ref
                .read(interpretacionProvider(id).notifier)
                .cargarInterpretacion(dataForInterpretation);
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
}
