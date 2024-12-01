import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_cursos_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EstudianteMirarEncuestaCursoScreen extends ConsumerWidget {
  static String screenName = 'estudiante_mirar_encuesta_curso_screen';
  const EstudianteMirarEncuestaCursoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Encuesta>? encuestas =
        ref.watch(estudianteCursosProvider).encuestasFiltradas;

    return FadeIn(
      duration: const Duration(milliseconds: 1230),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Encuestas de Curso'),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Ajusta el máximo ancho de cada card
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8, // Ajusta la proporción ancho/alto
            ),
            itemCount: encuestas!.length,
            itemBuilder: (context, index) {
              return CustomMirarEncuestaCard(
                encuesta: encuestas[index],
              );
            },
          ),
        )),
      ),
    );
  }
}
