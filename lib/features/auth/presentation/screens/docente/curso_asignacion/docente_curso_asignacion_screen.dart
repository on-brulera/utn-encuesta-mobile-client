import 'package:animate_do/animate_do.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocenteCursoAsignacionScreen extends StatelessWidget {
  static String screenName = 'docente_curso_asignacion_screen';
  const DocenteCursoAsignacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generamos una lista de 12 cursos para las filas
    final List<DynamicTableDataRow> rows = List.generate(
      12,
      (index) => DynamicTableDataRow(
        index: index,
        cells: [
          DynamicTableDataCell(value: 'Curso ${index + 1}'),
          DynamicTableDataCell(value: 'Carrera ${index + 1}'),
          DynamicTableDataCell(value: 'Nivel ${index + 1}'),
          DynamicTableDataCell(value: 'Materia ${index + 1}'),
          DynamicTableDataCell(value: 'Período ${index + 1}'),
        ],
      ),
    );

    return FadeIn(
      duration: const Duration(milliseconds: 1200),
      child: Scaffold(
        appBar: AppBar(
          title: AppTexts.title('Curso y Asignación'),
          actions: [
            IconButton.outlined(
                onPressed: () =>
                    context.go('/${DocenteMenuDScreen.screenName}'),
                icon: const Icon(Icons.exit_to_app_rounded)),
            AppSpaces.horizontal20,
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //BOX EXPANSIBLE PARA CREAR CURSOS
                const CustomCrearCursoBox(),
                //BOX PARA ASIGNAR ENCUESTAS A CURSOS
                const CustomAsignarEncuestaCursoBox(),
                //CUADRO DE CURSOS
                AppSpaces.vertical15,
                SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: CustomCursoTable(rows: rows)),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
