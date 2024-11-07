import 'package:dynamic_table/dynamic_table.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomCursoTable extends StatelessWidget {
  final List<DynamicTableDataRow> rows;
  const CustomCursoTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return DynamicTable(
      header: AppTexts.subTitle('Cursos'),
      onSelectAll: null,
      rowsPerPage: 3,
      showCheckboxColumn: false,
      columns: [
        DynamicTableDataColumn(
            label: const Text('Curso'),
            dynamicTableInputType: DynamicTableTextInput()),
        DynamicTableDataColumn(
            label: const Text('Carrera'),
            dynamicTableInputType: DynamicTableTextInput()),
        DynamicTableDataColumn(
            label: const Text('Nivel'),
            dynamicTableInputType: DynamicTableTextInput()),
        DynamicTableDataColumn(
            label: const Text('Materia'),
            dynamicTableInputType: DynamicTableTextInput()),
        DynamicTableDataColumn(
            label: const Text('Período'),
            dynamicTableInputType: DynamicTableTextInput()),
      ],
      rows: rows,
    );
  }
}
