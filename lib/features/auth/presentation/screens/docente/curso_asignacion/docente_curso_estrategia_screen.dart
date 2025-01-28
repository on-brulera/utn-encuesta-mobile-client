import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/estrategia_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocenteCursoEstrategiaScreen extends ConsumerStatefulWidget {
  static String screenName = 'docente_curso_estrategia_screen';
  final String idProvider;

  const DocenteCursoEstrategiaScreen({super.key, required this.idProvider});

  @override
  ConsumerState<DocenteCursoEstrategiaScreen> createState() =>
      _DocenteCursoEstrategiaScreenState();
}

class _DocenteCursoEstrategiaScreenState
    extends ConsumerState<DocenteCursoEstrategiaScreen> {
  final TextEditingController _estrategiaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cursoAsignadoDetallesState =
        ref.watch(listaAsignacionDetalleProvider);
    final estrategiaState = ref.watch(estrategiaProvider(widget.idProvider));

    if (cursoAsignadoDetallesState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final cursoAsignacionSelected =
        cursoAsignadoDetallesState.cursoAsignacionSelected;
    final encuestasCursoAsignacionSelected =
        cursoAsignadoDetallesState.encuestasCursoAsignacionSelected ?? [];

    final String contexto = '''
      Soy un docente de ${cursoAsignacionSelected?.matNombre} de la carrera de ${cursoAsignacionSelected?.curCarrera},
      enviame las estrategias en este formato: - Para el tema: Tema tal... - Actividad 1 - Actividad 2 y asi sucesivamente con todos los temas en 50 palabras minimo.
      que estrategias pedagógicas puedo aplicar para el tema de parendizaje: 
      ''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estrategia para el Curso'),
      ),
      body: cursoAsignacionSelected == null
          ? const Center(child: Text('No se encontraron detalles.'))
          : ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // Card 1: Detalles del curso
                _buildCursoCard(cursoAsignacionSelected),
                const SizedBox(height: 10),

                // Card 2: Encuestas asociadas
                _buildEncuestasCard(encuestasCursoAsignacionSelected),
                const SizedBox(height: 10),

                // Card 3: Desplegable para estrategia
                _buildEstrategiaRequest(estrategiaState, contexto),
                const SizedBox(height: 10),

                // Card 4: Mostrar consulta guardada
                _buildEstrategiaResponse(estrategiaState),
              ],
            ),
    );
  }

  Widget _buildCursoCard(AsignacionDetalles curso) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTexts.subTitle('Información del Curso'),
            const Divider(),
            AppTexts.softText(curso.matNombre),
            AppTexts.softText(curso.curCarrera),
            AppTexts.softText('Semestre ${curso.curNivel}'),
            AppTexts.numberNotification(
                'Periodo Académico: ${curso.curPeriodoAcademico}'),
          ],
        ),
      ),
    );
  }

  Widget _buildEncuestasCard(List<AsignacionDetalles> encuestas) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTexts.subTitle('Información de las Encuestas'),
            const Divider(),
            ...encuestas.map((encuesta) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('- ${encuesta.encTitulo}'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEstrategiaRequest(
      EstrategiaState estrategiaState, String contexto) {
    return ExpansionTile(
      title: AppTexts.subTitle('Solicitar Estrategia'),
      children: [
        Card(
          elevation: 5,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  controller: _estrategiaController,
                  decoration: const InputDecoration(
                    labelText: 'Ingrese los temas de la unidad',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final textoIngresado = _estrategiaController.text;
                      if (textoIngresado.isNotEmpty) {
                        ref
                            .read(
                                estrategiaProvider(widget.idProvider).notifier)
                            .obtenerEstrategia('$contexto $textoIngresado');
                      }
                    },
                    child: estrategiaState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Obtener Estrategia'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstrategiaResponse(EstrategiaState estrategiaState) {
    // Separar los temas y actividades si el texto tiene una estructura conocida
    final estrategiaTexto = estrategiaState.estrategia ?? '';
    final temas =
        estrategiaTexto.split(' - ').where((e) => e.isNotEmpty).toList();

    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTexts.subTitle('Estrategia'),
            const Divider(),
            if (estrategiaState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (estrategiaState.error != null)
              Text(
                'Error: ${estrategiaState.error}',
                style: const TextStyle(color: Colors.red),
              )
            else if (estrategiaState.estrategia != null && temas.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var tema in temas)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          children: [
                            // Título del tema
                            TextSpan(
                              text: tema.contains(':')
                                  ? tema.split(':')[0]
                                  : tema,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                            const TextSpan(text: '\n'), // Salto de línea
                            // Actividades del tema
                            if (tema.contains(':'))
                              TextSpan(
                                text: ' - ${tema.split(':')[1]}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blueGrey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            else
              const Text('Sin estrategias aún.'),
          ],
        ),
      ),
    );
  }
}
