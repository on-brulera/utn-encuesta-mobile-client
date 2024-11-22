import 'package:flutter/material.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante.dart';

class EstudiantesDynamicTable extends StatefulWidget {
  final List<Estudiante> estudiantes;

  const EstudiantesDynamicTable({super.key, required this.estudiantes});

  @override
  State<EstudiantesDynamicTable> createState() =>
      _EstudiantesDynamicTableState();
}

class _EstudiantesDynamicTableState extends State<EstudiantesDynamicTable> {
  int? _currentSortedColumnIndex;
  bool _currentSortedColumnAscending = true;

  List<Estudiante> get sortedEstudiantes {
    // Devuelve una copia ordenada basada en los parámetros actuales
    List<Estudiante> estudiantesOrdenados = List.from(widget.estudiantes);

    if (_currentSortedColumnIndex != null) {
      estudiantesOrdenados.sort((a, b) {
        var aValue = _currentSortedColumnIndex == 0 ? a.nombre : a.cedula;
        var bValue = _currentSortedColumnIndex == 0 ? b.nombre : b.cedula;
        return _currentSortedColumnAscending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      });
    }

    return estudiantesOrdenados;
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _currentSortedColumnIndex = columnIndex;
      _currentSortedColumnAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabla dinámica
        SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: DynamicTable(
            header: const Text(
              "Tabla de Estudiantes",
              style: TextStyle(fontSize: 18),
            ),
            rowsPerPage: 5,
            showFirstLastButtons: false,
            availableRowsPerPage: const [5, 10],
            columnSpacing: 50,
            dataRowMinHeight: 50,
            dataRowMaxHeight: 50,
            showCheckboxColumn: false,
            sortAscending: _currentSortedColumnAscending,
            sortColumnIndex: _currentSortedColumnIndex,
            rows: List.generate(
              sortedEstudiantes.length,
              (index) => DynamicTableDataRow(
                color: const WidgetStatePropertyAll(Colors.white12),
                index: index,
                cells: [
                  DynamicTableDataCell(value: sortedEstudiantes[index].nombre),
                  DynamicTableDataCell(value: sortedEstudiantes[index].cedula),
                  DynamicTableDataCell(
                      value: sortedEstudiantes[index].nota1.toStringAsFixed(2)),
                  DynamicTableDataCell(
                      value: sortedEstudiantes[index].nota2.toStringAsFixed(2)),
                  DynamicTableDataCell(
                      value:
                          sortedEstudiantes[index].promedio.toStringAsFixed(2)),
                ],
              ),
            ),
            columns: [
              DynamicTableDataColumn(
                label: const Text("Nombre"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Cédula"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
                isEditable: false,
              ),
              DynamicTableDataColumn(
                label: const Text("Parcial 1"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Parcial 2"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Promedio"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
