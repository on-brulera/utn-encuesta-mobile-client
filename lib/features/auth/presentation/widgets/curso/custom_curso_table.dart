import 'package:encuestas_utn/features/auth/presentation/providers/docente/crear_asignacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomCursoTable extends ConsumerStatefulWidget {
  final List<AsignacionDetalles> asignaciones;

  const CustomCursoTable({super.key, required this.asignaciones});

  @override
  ConsumerState<CustomCursoTable> createState() => _CustomCursoTableState();
}

class _CustomCursoTableState extends ConsumerState<CustomCursoTable> {
  int? _currentSortedColumnIndex;
  bool _currentSortedColumnAscending = true;
  int? _selectedRowIndex;
  var tableKey = GlobalKey<DynamicTableState>();

  List<AsignacionDetalles> get sortedAsignaciones {
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

  Future<void> _deleteSelectedRow() async {
    if (_selectedRowIndex != null) {
      final selectedAsignacion = sortedAsignaciones[_selectedRowIndex!];
      final eliminarAsignacion = ref.read(crearAsignacionProvider.notifier);

      try {
        final result = await eliminarAsignacion.eliminarAsignaciones(
          selectedAsignacion.encId,
          selectedAsignacion.curId,
          selectedAsignacion.matId,
          0,
          selectedAsignacion.parId,
        );

        if (result == true) {
          setState(() {
            widget.asignaciones.removeAt(_selectedRowIndex!);
            _selectedRowIndex = null;
          });

          if (mounted) {
            // Verifica si el widget sigue montado
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Asignación eliminada con éxito")),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Error al eliminar la asignación: la asignación ya tiene respuestas")),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error inesperado: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedRowIndex != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _deleteSelectedRow,
                  child: const Text("Eliminar Asignación"),
                ),
              ],
            ),
          ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DynamicTable(
            key: tableKey,
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
                onSelectChanged: (value) {
                  setState(() {
                    _selectedRowIndex = value == true ? index : null;
                  });
                },
                selected: _selectedRowIndex == index,
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
