import 'package:flutter/material.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';

class CustomCursoTable extends StatefulWidget {
  final List<AsignacionDetalles> asignaciones;

  const CustomCursoTable({super.key, required this.asignaciones});

  @override
  State<CustomCursoTable> createState() => _CustomCursoTableState();
}

class _CustomCursoTableState extends State<CustomCursoTable> {
  int? _currentSortedColumnIndex;
  bool _currentSortedColumnAscending = true;

  List<AsignacionDetalles> get sortedAsignaciones {
    // Devuelve una lista ordenada basada en los parámetros actuales
    List<AsignacionDetalles> asignacionesOrdenadas =
        List.from(widget.asignaciones);

    if (_currentSortedColumnIndex != null) {
      asignacionesOrdenadas.sort((a, b) {
        String aValue;
        String bValue;

        switch (_currentSortedColumnIndex) {
          case 0:
            aValue = a.encTitulo;
            bValue = b.encTitulo;
            break;
          case 1:
            aValue = a.curCarrera;
            bValue = b.curCarrera;
            break;
          case 2:
            aValue = a.matNombre;
            bValue = b.matNombre;
            break;
          case 3:
            aValue = a.curPeriodoAcademico;
            bValue = b.curPeriodoAcademico;
            break;
          case 4:
            aValue = a.parId.toString();
            bValue = b.parId.toString();
            break;
          default:
            aValue = '';
            bValue = '';
        }

        return _currentSortedColumnAscending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      });
    }

    return asignacionesOrdenadas;
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: DynamicTable(
            header: const Text("Cursos y Asignaciones"),
            rowsPerPage: 7,
            availableRowsPerPage: const [5, 10],
            showFirstLastButtons: false,
            columnSpacing: 50,
            dataRowMinHeight: 50,
            dataRowMaxHeight: 50,
            showCheckboxColumn: false,
            sortAscending: _currentSortedColumnAscending,
            sortColumnIndex: _currentSortedColumnIndex,
            rows: List.generate(
              sortedAsignaciones.length,
              (index) => DynamicTableDataRow(
                index: index,
                cells: [
                  DynamicTableDataCell(
                      value: sortedAsignaciones[index].encTitulo),
                  DynamicTableDataCell(
                      value: sortedAsignaciones[index].curCarrera),
                  DynamicTableDataCell(
                      value: sortedAsignaciones[index].matNombre),
                  DynamicTableDataCell(
                      value: sortedAsignaciones[index].curPeriodoAcademico),
                  DynamicTableDataCell(
                      value: sortedAsignaciones[index].parId.toString()),
                ],
              ),
            ),
            columns: [
              DynamicTableDataColumn(
                label: const Text("Título"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Carrera"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Materia"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Período Académico"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Parcial"),
                onSort: (columnIndex, ascending) {
                  _sortData(columnIndex, ascending);
                },
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
