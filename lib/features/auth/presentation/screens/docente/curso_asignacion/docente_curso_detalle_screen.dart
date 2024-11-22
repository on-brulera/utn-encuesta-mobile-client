import 'package:encuestas_utn/features/auth/domain/entities/asignacion_detalles.dart';
import 'package:encuestas_utn/features/auth/domain/entities/pregunta_opciones.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/estudiantes_dynamic_table.dart';
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
              : cursoAsignadoDetallesState.cursoAsignacionSelected != null
                  ? ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildInfoCursoCard(cursoAsignadoDetallesState
                            .cursoAsignacionSelected!),
                        const SizedBox(height: 10),
                        _buildEncuestasCard(cursoAsignadoDetallesState
                            .encuestasCursoAsignacionSelected!),
                        const SizedBox(height: 10),
                        EstudiantesDynamicTable(
                            estudiantes:
                                cursoAsignadoDetallesState.estudiantes ?? [])
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

  Widget _buildPreguntasCard(List<PreguntaOpciones> preguntas) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          AppTexts.textNotification('Preguntas'),
          const Divider(thickness: 1),
          ...preguntas.map((preguntaDetalle) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${preguntaDetalle.pregunta.orden}. ${preguntaDetalle.pregunta.enunciado}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...preguntaDetalle.opciones.map((opcion) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppTexts.softText(
                          '${opcion.valorCualitativo}. ${opcion.texto}'),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
