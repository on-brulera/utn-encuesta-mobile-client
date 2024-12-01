import 'dart:convert';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';
import 'package:flutter/material.dart';

class StylesVsAverageChart extends StatelessWidget {
  final List<EstudianteResultado> resultados;

  const StylesVsAverageChart({super.key, required this.resultados});

  Map<String, Map<String, dynamic>> _calculateStyleStatistics(
      List<EstudianteResultado> resultados) {
    final Map<String, List<double>> styleGrades = {};

    for (var resultado in resultados) {
      // Decodificar `hisResultadoEncuesta`
      final Map<String, dynamic> data =
          jsonDecode(resultado.hisResultadoEncuesta.replaceAll("'", '"'));

      // Encontrar el estilo predominante para este estudiante
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
        // Asociar la nota al estilo predominante
        styleGrades
            .putIfAbsent(predominantStyle!, () => [])
            .add(resultado.notNota);
      }
    }

    // Calcular el promedio de notas y el número de estudiantes por estilo
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

  @override
  Widget build(BuildContext context) {
    final calculatedStatistics = _calculateStyleStatistics(resultados);

    return SingleChildScrollView(
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
              DataCell(
                  Text(entry.value['average'].toStringAsFixed(2))), // Promedio
              DataCell(Text(
                  entry.value['count'].toString())), // Número de estudiantes
            ],
          );
        }).toList(),
      ),
    );
  }
}
