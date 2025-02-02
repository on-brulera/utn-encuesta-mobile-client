import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_cursos_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/curso/custom_materias_estudiante_card.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EstudianteAsignaturaScreen extends ConsumerStatefulWidget {
  static String screenName = 'estudiante_asignaturas_screen';
  const EstudianteAsignaturaScreen({super.key});

  @override
  createState() => _EstudianteAsignaturaScreenState();
}

class _EstudianteAsignaturaScreenState extends ConsumerState<EstudianteAsignaturaScreen> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   final listaCursosNotifier = ref.read(estudianteCursosProvider.notifier);
    //   listaCursosNotifier.obtenerTodosCursos();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final listaCursosState = ref.watch(estudianteCursosProvider);

    if (listaCursosState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (listaCursosState.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error: ${listaCursosState.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final cursos = listaCursosState.asignaturas;

    if (cursos == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No hay cursos disponibles.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CurstomAppBar(titulo: 'Materias'),
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
            itemCount: cursos.length,
            itemBuilder: (context, index) {
              final curso = cursos[index];
              return CustomMateriasEstudianteCard(
                materia: curso,
              );
            },
          ),
        ),
      ),
    );
  }
}
