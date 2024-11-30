import 'package:encuestas_utn/utils/app_texts.dart';
import 'package:flutter/material.dart';

class RespuestaEncuestaTable extends StatelessWidget {
  final int totalEstudiantes;
  final int respondieronEncuesta;
  final int noRespondieron;

  const RespuestaEncuestaTable({
    super.key,
    required this.totalEstudiantes,
    required this.respondieronEncuesta,
    required this.noRespondieron,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        color: Colors.white, // Fondo de la tarjeta completamente blanco.
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Espaciado interno de la tarjeta.
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              Colors.white, // Color de fondo de los encabezados.
            ),
            dataRowColor: WidgetStateProperty.all(
              Colors.white, // Fondo blanco para las filas de datos.
            ),
            columnSpacing: 20,
            headingTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Texto negro para los encabezados.
            ),
            dataTextStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black, // Texto negro para las filas de datos.
            ),
            columns: [
              DataColumn(
                label: AppTexts.textNotification('Descripción'),
              ),
              DataColumn(
                label: AppTexts.textNotification('Cantidad'),
              ),
              DataColumn(
                label: AppTexts.textNotification('Porcentaje'),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(AppTexts.softText('Total Estudiantes')),
                DataCell(Text(totalEstudiantes.toString())),
                const DataCell(Text('100%')),
              ]),
              DataRow(cells: [
                DataCell(AppTexts.softText('Respondieron')),
                DataCell(Text(respondieronEncuesta.toString())),
                DataCell(Text(
                    '${((respondieronEncuesta / totalEstudiantes) * 100).toStringAsFixed(1)}%')),
              ]),
              DataRow(cells: [
                DataCell(AppTexts.softText('No Respondieron')),
                DataCell(Text(noRespondieron.toString())),
                DataCell(Text(
                    '${((noRespondieron / totalEstudiantes) * 100).toStringAsFixed(1)}%')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
