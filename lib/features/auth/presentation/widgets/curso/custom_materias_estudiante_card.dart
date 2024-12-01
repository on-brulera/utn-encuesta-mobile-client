import 'package:encuestas_utn/features/auth/domain/entities/materia.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_cursos_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/estudiante/mirar_encuesta/estudiante_mirar_encuesta__cursoscreen.dart';
import 'package:encuestas_utn/utils/app_spaces.dart';
import 'package:encuestas_utn/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomMateriasEstudianteCard extends ConsumerWidget {
  final Materia materia;

  const CustomMateriasEstudianteCard({super.key, required this.materia});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await ref.read(estudianteCursosProvider.notifier).filtrarEncuestasByMateria(materia.id);
        if (context.mounted) {
          context.pushNamed(EstudianteMirarEncuestaCursoScreen.screenName);
        } else {
          const Scaffold(body: Center(child: CircularProgressIndicator(),),);
        }
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
                          child: AppTexts.textNotification('Asignatura'),
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
                        materia.nombre,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    AppSpaces.vertical10,
                    AppTexts.commentNotification(materia.descripcion),
                    AppSpaces.vertical20,                    
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
