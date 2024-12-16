import 'package:encuestas_utn/features/auth/presentation/providers/docente/curso_asignacion_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_curso_provider.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomCrearCursoBox extends ConsumerStatefulWidget {
  const CustomCrearCursoBox({super.key});

  @override
  createState() => _CustomCrearCursoBoxState();
}

class _CustomCrearCursoBoxState extends ConsumerState<CustomCrearCursoBox> {
  late final TextEditingController fechaInicioController;
  late final TextEditingController fechaFinController;

  @override
  void initState() {
    super.initState();
    fechaInicioController = TextEditingController();
    fechaFinController = TextEditingController();
  }

  @override
  void dispose() {
    fechaInicioController.dispose();
    fechaFinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCrearCursoBoxContent(
      fechaInicioController: fechaInicioController,
      fechaFinController: fechaFinController,
    );
  }
}

class CustomCrearCursoBoxContent extends ConsumerWidget {
  final TextEditingController fechaInicioController;
  final TextEditingController fechaFinController;

  const CustomCrearCursoBoxContent({
    required this.fechaInicioController,
    required this.fechaFinController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursoNotifier = ref.read(cursoDetalleProvider.notifier);
    final cursoState = ref.watch(cursoDetalleProvider);

    return ExpansionTile(
      title: AppTexts.subTitle("Añadir curso"),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                label: 'Carrera',
                value: cursoState.curso.carrera,
                items: listaCarreras,
                onChanged: (value) => cursoNotifier.actualizarCarrera(value!),
              ),
              _buildDropdown(
                label: 'Semestre',
                value: cursoState.curso.nivel,
                items: listaSemestres,
                onChanged: (value) => cursoNotifier.actualizarSemestre(value!),
              ),
              _buildDateFields(context),
              _buildSaveButton(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.softText(label),
        AppSpaces.vertical5,
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        AppSpaces.vertical15,
      ],
    );
  }

  Widget _buildDateFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.softText('Periodo Académico'),
        AppSpaces.vertical5,
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: fechaInicioController,
                inputFormatters: [DateInputFormatter()],
                decoration: const InputDecoration(
                  hintText: "dd-mm-yyyy",
                  suffixIcon: Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            AppSpaces.horizontal10,
            Expanded(
              child: TextFormField(
                controller: fechaFinController,
                inputFormatters: [DateInputFormatter()],
                decoration: const InputDecoration(
                  hintText: "dd-mm-yyyy",
                  suffixIcon: Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        AppSpaces.vertical15,
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, WidgetRef ref) {
    final cursoNotifier = ref.read(cursoDetalleProvider.notifier);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(
              context); // Captura el messenger antes del async gap
          final periodoAcademico =
              "${fechaInicioController.text} - ${fechaFinController.text}";
          cursoNotifier.actualizarPeriodoAcademico(periodoAcademico);

          final exito = await cursoNotifier.crearCurso();
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                exito
                    ? 'Curso guardado exitosamente'
                    : 'Error al guardar el curso.',
              ),
              backgroundColor: exito ? Colors.green : Colors.red,
            ),
          );
          await ref.read(listaCursoProvider.notifier).obtenerTodosCursos();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        child: const Text(
          'Guardar Curso',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

List<DropdownMenuItem<String>> listaCarreras = const [
  DropdownMenuItem(
      value: "Ingeniería Mecatrónica", child: Text("Ingeniería Mecatrónica")),
  DropdownMenuItem(
      value: "Ingeniería en Telecomunicaciones",
      child: Text("Ingeniería en Telecomunicaciones")),
  DropdownMenuItem(
      value: "Ingeniería Textil", child: Text("Ingeniería Textil")),
  DropdownMenuItem(
      value: "Ingeniería Industrial", child: Text("Ingeniería Industrial")),
  DropdownMenuItem(
      value: "Ingeniería de Software", child: Text("Ingeniería de Software")),
  DropdownMenuItem(value: "Electricidad", child: Text("Electricidad")),
  DropdownMenuItem(
      value: "Ingeniería Automotriz", child: Text("Ingeniería Automotriz")),
];

List<DropdownMenuItem<int>> listaSemestres = List.generate(
  8,
  (index) => DropdownMenuItem(
    value: index + 1,
    child: Text("Semestre ${index + 1}"),
  ),
);
