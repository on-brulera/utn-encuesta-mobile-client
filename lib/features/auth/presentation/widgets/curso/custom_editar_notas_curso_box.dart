import 'package:encuestas_utn/features/auth/domain/entities/estudiante.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/crear_asignacion_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignatura_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_curso_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_parcial_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/shared/estudiantes_dynamic_table.dart';
import 'package:encuestas_utn/utils/excel_service.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomEditarNotasCursoBox extends ConsumerStatefulWidget {
  const CustomEditarNotasCursoBox({super.key});

  @override
  createState() => _CustomEditarNotasCursoBoxState();
}

class _CustomEditarNotasCursoBoxState
    extends ConsumerState<CustomEditarNotasCursoBox> {
  String? selectedCurso; // Curso seleccionado
  String? selectedAsignatura;
  String? selectedParcial;
  String? selectedEncuesta;
  late final TextEditingController fechaLimiteController;
  List<Estudiante> estudiantes = [];

  @override
  void initState() {
    super.initState();
    // Llama al método para obtener los cursos al iniciar
    fechaLimiteController = TextEditingController();
    Future.microtask(
        () => ref.read(listaCursoProvider.notifier).obtenerTodosCursos());
    Future.microtask(() =>
        ref.read(listaAsignaturaProvider.notifier).obtenerTodasMaterias());
    Future.microtask(
        () => ref.read(listaParcialProvider.notifier).obtenerTodasParciales());
  }

  @override
  void dispose() {
    fechaLimiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursoState = ref.watch(listaCursoProvider);
    final asignaturaState = ref.watch(listaAsignaturaProvider);
    final parcialState = ref.watch(listaParcialProvider);

    return ExpansionTile(
      title: AppTexts.subTitle("Editar Notas de un Curso"),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrera
              AppTexts.softText('Curso'),
              AppSpaces.vertical5,
              _buildCursoDropdown(cursoState),
              AppSpaces.vertical15,

              // Asignaturas
              AppTexts.softText('Asignatura'),
              AppSpaces.vertical5,
              _buildAsignaturaDropdown(asignaturaState),
              AppSpaces.vertical15,

              // Subir Listado de Estudiantes
              AppTexts.softText('Listado de estudiantes'),
              AppSpaces.vertical10,
              _buildSubirListadoButton(),

              // Parciales
              AppTexts.softText('Notas del Parcial'),
              AppSpaces.vertical5,
              _buildParcialDropdown(parcialState),
              AppSpaces.vertical15,

              // Action Guardar Asignación
              AppTexts.softText('Guardar Asignación'),
              AppSpaces.vertical10,
              _buildGuardarAsignacionButton(),
              AppSpaces.vertical5,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCursoDropdown(ListaCursoState cursoState) {
    if (cursoState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cursoState.error != null) {
      return Text('Error: ${cursoState.error}',
          style: const TextStyle(color: Colors.red));
    }

    final cursos = cursoState.cursos
        .map((curso) => DropdownMenuItem<String>(
              value: curso.id.toString(),
              child: SizedBox(
                width: 200,
                height: 70,
                child: Text(
                    '${curso.carrera} ${curso.nivel} / ${curso.periodoAcademico}'),
              ),
            ))
        .toList();

    return DropdownButtonFormField<String>(
      value: selectedCurso,
      items: cursos,
      onChanged: (value) {
        setState(() {
          selectedCurso = value;
        });
      },
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildAsignaturaDropdown(ListaAsignaturaState asignaturaState) {
    if (asignaturaState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asignaturaState.error != null) {
      return Text('Error: ${asignaturaState.error}',
          style: const TextStyle(color: Colors.red));
    }

    final asignaturas = asignaturaState.materias
        .map((materia) => DropdownMenuItem<String>(
              value: materia.id.toString(),
              child: SizedBox(
                width: 200,
                child: Text(materia.nombre),
              ),
            ))
        .toList();

    return DropdownButtonFormField<String>(
      value: selectedAsignatura,
      items: asignaturas,
      onChanged: (value) {
        setState(() {
          selectedAsignatura = value;
        });
      },
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSubirListadoButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          onPressed: () async {
            try {
              final excelService = ExcelService();
              final nuevosEstudiantes =
                  await excelService.cargarEstudiantesDesdeExcel();

              if (!mounted) return;

              setState(() {
                estudiantes = nuevosEstudiantes;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Archivo cargado exitosamente')),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 165, 165, 165),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(
                color: Color.fromARGB(255, 205, 187, 187), width: 1),
          ),
          child: AppTexts.subTitle('Subir listado de estudiantes'),
        ),
        if (estudiantes.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildEstudiantesTable(),
        ],
      ],
    );
  }

  Widget _buildEstudiantesTable() {
    return EstudiantesDynamicTable(estudiantes: estudiantes);
  }

  Widget _buildParcialDropdown(ListaParcialState parcialState) {
    if (parcialState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (parcialState.error != null) {
      return Text('Error: ${parcialState.error}',
          style: const TextStyle(color: Colors.red));
    }

    final parciales = parcialState.parciales
        .map((parcial) => DropdownMenuItem<String>(
              value: parcial.id.toString(),
              child: SizedBox(
                width: 200,
                child: Text(parcial.descripcion),
              ),
            ))
        .toList();

    return DropdownButtonFormField<String>(
      value: selectedParcial,
      items: parciales,
      onChanged: (value) {
        setState(() {
          selectedParcial = value;
        });
      },
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildGuardarAsignacionButton() {
    return Consumer(
      builder: (context, ref, child) {
        final crearAsignacionState = ref.watch(crearAsignacionProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              onPressed: () async {
                // Guarda el contexto localmente
                final messenger = ScaffoldMessenger.of(context);

                // Validar que todos los campos estén seleccionados
                if (selectedCurso == null || selectedAsignatura == null) {
                  messenger.showSnackBar(const SnackBar(
                      content: Text('Por favor, complete todos los campos.')));
                  return;
                }

                // Llamar al provider para crear la asignación
                await ref.read(crearAsignacionProvider.notifier).actualizarNota(
                    estudiantes,
                    int.tryParse(selectedCurso!)!,
                    int.tryParse(selectedAsignatura!)!,
                    int.tryParse(selectedParcial!)!);

                // Manejar el resultado
                if (ref.read(crearAsignacionProvider).asignacionCreada !=
                    null) {
                  messenger.showSnackBar(const SnackBar(
                      content: Text('Notas actualizadas con éxito.')));
                  await ref
                      .read(listaAsignacionDetalleProvider.notifier)
                      .obtenerTodasLasAsignaciones();
                } else if (ref.read(crearAsignacionProvider).error != null) {
                  messenger.showSnackBar(SnackBar(
                      content: Text(
                          'Error: ${ref.read(crearAsignacionProvider).error}')));
                }
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 230, 38, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: crearAsignacionState.isLoading
                  ? const CircularProgressIndicator()
                  : AppTexts.subTitle('Guardar Notas'),
            ),
            if (crearAsignacionState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Error: ${crearAsignacionState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}