import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/curso/custom_mirar_curso_card.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocenteListaCursoScreen extends ConsumerWidget {
  static String screenName = 'docente_lista_curso_screen';
  const DocenteListaCursoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listaAsignacionState = ref.watch(listaAsignacionDetalleProvider);

    // Verificar el estado
    if (listaAsignacionState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (listaAsignacionState.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error: ${listaAsignacionState.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Obtener la lista filtrada de cursos
    final cursosAsignaciones = listaAsignacionState.cursosAsignaciones ?? [];

    return FadeIn(
      duration: const Duration(milliseconds: 1230),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Cursos Creados'),
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
              itemCount: cursosAsignaciones.length,
              itemBuilder: (context, index) {
                final curso = cursosAsignaciones[index];
                return CustomMirarCursoCard(
                  asignacionDetalleCurso: curso,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
