import 'package:encuestas_utn/features/auth/domain/entities/curso.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/docente/curso_asignacion/docente_curso_detalle_screen.dart';
import 'package:encuestas_utn/utils/app_spaces.dart';
import 'package:encuestas_utn/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomMirarCursoEstudianteCard extends ConsumerWidget {
  final Curso curso;

  const CustomMirarCursoEstudianteCard({super.key, required this.curso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Llamar al método seleccionarCursoAsignadoByCursoId
        // ref
        //     .read(listaAsignacionDetalleProvider.notifier)
        //     .seleccionarCursoAsignadoByCursoId(
        //         asignacionDetalleCurso.curId, asignacionDetalleCurso.matId);

        context.pushNamed(DocenteCursoDetalleScreen.screenName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpaces.horizontal15,
            Expanded(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AppTexts.textNotification('Curso'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            size: 35,
                            Icons.school_sharp,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    AppSpaces.vertical15,
                    Flexible(
                      child: Text(
                        curso.carrera,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    AppSpaces.vertical10,
                    AppTexts.commentNotification(
                        'Semestre ${curso.nivel}'),
                    AppSpaces.vertical20,
                    AppTexts.fechaCurso(
                        curso.periodoAcademico),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
