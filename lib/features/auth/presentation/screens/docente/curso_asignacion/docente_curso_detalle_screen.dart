import 'dart:convert';

import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante_resultado.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/interpretacion_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/area_predominant_styles_chart.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/estudiantes_dynamic_table.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/predominant_styles_chart.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/resultado_encuesta_bar_chart.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/resultado_encuesta_scatter_chart.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/styles_vs_average_chart.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/total_estudiantes_bar_chart.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocenteCursoDetalleScreen extends ConsumerStatefulWidget {
  static String screenName = 'docente_curso_detalle_screen';

  const DocenteCursoDetalleScreen({
    super.key,
  });

  @override
  createState() => _DocenteEncuestaDetallesScreenState();
}

class _DocenteEncuestaDetallesScreenState
    extends ConsumerState<DocenteCursoDetalleScreen> {
  @override
  Widget build(BuildContext context) {
    final cursoAsignadoDetallesState =
        ref.watch(listaAsignacionDetalleProvider);

    if (cursoAsignadoDetallesState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Asegúrate de que las listas no sean nulas antes de usarlas.
    final estudiantes = cursoAsignadoDetallesState.estudiantes ?? [];
    final cursoAsignacionSelected =
        cursoAsignadoDetallesState.cursoAsignacionSelected;
    final encuestasCursoAsignacionSelected =
        cursoAsignadoDetallesState.encuestasCursoAsignacionSelected ?? [];

    //Para el análisis de datos con IA

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Curso'),
      ),
      body: cursoAsignadoDetallesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cursoAsignadoDetallesState.error != null
              ? Center(
                  child: Text(
                    cursoAsignadoDetallesState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : cursoAsignacionSelected != null
                  ? ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildInfoCursoCard(cursoAsignacionSelected),
                        const SizedBox(height: 10),
                        _buildEncuestasCard(encuestasCursoAsignacionSelected),
                        const SizedBox(height: 10),

                        //TABLA DE LISTADO DE ESTUDIANTES
                        EstudiantesDynamicTable(
                            estudiantes:
                                cursoAsignadoDetallesState.estudiantes ?? []),
                        const SizedBox(height: 30),

                        //TILES CON LAS ENCUESTAS
                        _buildExpansionTiles(
                            encuestasCursoAsignacionSelected, estudiantes),
                        const SizedBox(height: 50),
                      ],
                    )
                  : const Center(child: Text('No se encontraron detalles.')),
    );
  }

  Widget _buildInfoCursoCard(AsignacionDetalles curso) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.textNotification('Curso'),
          const Divider(thickness: 1),
          AppSpaces.vertical5,
          AppTexts.subTitle(curso.matNombre),
          AppSpaces.vertical5,
          AppTexts.courseText(curso.curCarrera),
          AppSpaces.vertical5,
          AppTexts.softText('${curso.curNivel} Semestre'),
          AppSpaces.vertical5,
          AppTexts.numberNotification(curso.curPeriodoAcademico),
          AppSpaces.vertical5,
        ],
      ),
    );
  }

  Widget _buildEncuestasCard(List<AsignacionDetalles> encuestas) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.textNotification('Encuestas Asignadas'),
          const Divider(thickness: 1),
          ...encuestas.map((encuesta) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpaces.vertical5,
                    AppTexts.softText('- ${encuesta.encTitulo}'),
                    AppSpaces.vertical10,
                    AppTexts.numberNotification(
                        '   Relacionada con las notas del Parcial ${encuesta.parId}'),
                  ],
                ));
          }),
        ],
      ),
    );
  }

  Widget _buildInterpretacionButton(String titulo,
      {required String datos, required String mensaje}) {
    final interpretacionState = ref.watch(interpretacionProvider);

    if (interpretacionState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (interpretacionState.hasError) {
      return Center(
        child: Text(
          "Error al cargar la interpretación: ${interpretacionState.error}",
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.w300),
        ),
      );
    }

    final respuesta = interpretacionState.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontWeight: FontWeight.w400)),
        const SizedBox(height: 10),
        respuesta != null
            ? Text(respuesta.text,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w300))
            : OutlinedButton(
                onPressed: () => ref
                    .read(interpretacionProvider.notifier)
                    .cargarInterpretacion(datos, mensaje),
                child: const Text("Cargar Interpretación"),
              ),
      ],
    );
  }

  Widget _buildExpansionTiles(
      List<AsignacionDetalles> asignaciones, List<Estudiante>? estudiantes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.numberNotification('Encuestas Asignadas'),
          const Divider(thickness: 1),
          ...asignaciones.map((asignacion) {
            return ExpansionTile(
              title: AppTexts.softText(asignacion.encTitulo),
              subtitle:
                  AppTexts.numberNotification("PARCIAL ${asignacion.parId}"),
              leading: const Icon(Icons.assignment),
              children: [
                const SizedBox(height: 20),
                FutureBuilder<List<EstudianteResultado>?>(
                  future: _getResultadosPorAsignacion(asignacion),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Error al cargar datos: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No hay datos disponibles.");
                    }

                    // Datos cargados correctamente
                    final resultados = snapshot.data!;

                    // Verificar si al menos uno tiene un formato válido
                    final tieneFormatoValido = resultados.any((resultado) =>
                        isValidStructure(resultado.hisResultadoEncuesta));

                    if (tieneFormatoValido) {
                      // Mostrar los diagramas basados en la clase que hicimos
                      return Column(
                        children: [
                          const SizedBox(height: 30),
                          AppTexts.diagrama(
                              'Gráfico de Barras - Sub Estilo Más Predominante'),
                          const SizedBox(height: 10),
                          PredominantStylesChart(
                            responses: resultados
                                .map((r) => r.hisResultadoEncuesta)
                                .toList(),
                          ),
                          const SizedBox(height: 30),
                          _buildInterpretacionButton(
                            "Interpretación Predominancia por Estilo",
                            datos: resultados.toString(),
                            mensaje:
                                "¿Qué interpretación puedes darme de este gráfico?",
                          ),
                          const SizedBox(height: 30),
                          AppTexts.diagrama(
                              'Gráfico de Barras - Total de Estilos por Estudiante'),
                          const SizedBox(height: 10),
                          AreaPredominantStylesChart(
                            responses: resultados
                                .map((r) => r.hisResultadoEncuesta)
                                .toList(),
                          ),
                          const SizedBox(height: 30),
                          _buildInterpretacionButton(
                            "Interpretación Predominancia por Estilo",
                            datos: resultados.toString(),
                            mensaje:
                                "¿Qué interpretación puedes darme de este gráfico?",
                          ),
                          const SizedBox(height: 30),
                          AppTexts.diagrama(
                              'Diagrama de Dispersión - Nota de Estudiante por Estilo'),
                          const SizedBox(height: 10),
                          StylesVsAverageChart(resultados: resultados),
                          const SizedBox(height: 30),
                          _buildInterpretacionButton(
                            "Interpretación Diagrama de Dispersión",
                            datos: resultados.toString(),
                            mensaje:
                                "¿Qué interpretación puedes darme de este gráfico?",
                          ),
                        ],
                      );
                    } else {
                      // Mostrar las tablas predeterminadas
                      return Column(
                        children: [
                          AppTexts.diagrama(
                              'Gráfico de Barras - Total de Estudiantes'),
                          const SizedBox(height: 10),
                          TotalEstudiantesBarChart(estudiantes: resultados),
                          const SizedBox(height: 30),
                          _buildInterpretacionButton(
                            "Interpretación Total de Estudiantes",
                            datos: resultados.toString(),
                            mensaje:
                                "¿Qué interpretación puedes darme de este gráfico?",
                          ),
                          const SizedBox(height: 30),
                          AppTexts.diagrama(
                              'Gráfico de Barras - Promedio de Notas'),
                          const SizedBox(height: 10),
                          ResultadoEncuestaBarChart(estudiantes: resultados),
                          const SizedBox(height: 30),
                          _buildInterpretacionButton(
                            "Interpretación Promedio de Notas",
                            datos: resultados.toString(),
                            mensaje:
                                "¿Qué interpretación puedes darme de este gráfico?",
                          ),
                          const SizedBox(height: 30),
                          AppTexts.diagrama(
                              'Diagrama de Dispersión - Nota de Estudiante por Estilo'),
                          const SizedBox(height: 10),
                          ResultadoEncuestaScatterChart(
                              estudiantes: resultados),
                          const SizedBox(height: 30),
                          _buildInterpretacionButton(
                            "Interpretación Diagrama de Dispersión",
                            datos: resultados.toString(),
                            mensaje:
                                "¿Qué interpretación puedes darme de este gráfico?",
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Método para obtener resultados filtrados por asignación
  Future<List<EstudianteResultado>?> _getResultadosPorAsignacion(
      AsignacionDetalles asignacion) async {
    final asignacionState = ref.watch(listaAsignacionDetalleProvider.notifier);
    List<EstudianteResultado>? resultados =
        await asignacionState.obtenerResultadoEstudiantePorCurso(
            asignacion.curId,
            asignacion.matId,
            asignacion.parId,
            asignacion.encId);
    return resultados;
  }

  bool isValidStructure(String text) {
    try {
      // Intentar decodificar el string como JSON
      final data =
          jsonDecode(text.replaceAll("'", '"')) as Map<String, dynamic>;

      // Claves esperadas para las categorías principales
      final expectedCategories = [
        "Activo-Reflexivo",
        "Sensorial-Intuitivo",
        "Visual-Verbal",
        "Secuencial-Global"
      ];

      // Validar que todas las claves esperadas estén presentes
      for (var category in expectedCategories) {
        if (!data.containsKey(category)) return false;

        final categoryData = data[category] as Map<String, dynamic>;

        // Validar que tenga las claves "diferencia", "predominante" y "detalle"
        if (!categoryData.containsKey("diferencia") ||
            !categoryData.containsKey("predominante") ||
            !categoryData.containsKey("detalle")) {
          return false;
        }

        // Validar que "diferencia" sea un entero
        if (categoryData["diferencia"] is! int) return false;

        // Validar que "predominante" sea un String
        if (categoryData["predominante"] is! String) return false;

        // Validar que "detalle" sea un mapa con claves "A" y "B" (enteros)
        final detalle = categoryData["detalle"] as Map<String, dynamic>;
        if (!detalle.containsKey("A") ||
            !detalle.containsKey("B") ||
            detalle["A"] is! int ||
            detalle["B"] is! int) {
          return false;
        }
      }

      // Si pasaron todas las validaciones, la estructura es válida
      return true;
    } catch (e) {
      // Si ocurre un error en cualquier punto, la estructura no es válida
      return false;
    }
  }
}
