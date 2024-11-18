import 'package:encuestas_utn/features/auth/domain/entities/estudiante.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_curso_provider.dart';
import 'package:encuestas_utn/utils/excel_service.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAsignarEncuestaCursoBox extends ConsumerStatefulWidget {
  const CustomAsignarEncuestaCursoBox({super.key});

  @override
  createState() => _CustomAsignarEncuestaCursoBoxState();
}

class _CustomAsignarEncuestaCursoBoxState
    extends ConsumerState<CustomAsignarEncuestaCursoBox> {
  String? selectedCurso; // Curso seleccionado

  @override
  void initState() {
    super.initState();
    // Llama al método para obtener los cursos al iniciar
    Future.microtask(
        () => ref.read(listaCursoProvider.notifier).obtenerTodosCursos());
  }

  @override
  Widget build(BuildContext context) {
    final cursoState = ref.watch(listaCursoProvider);

    return ExpansionTile(
      title: AppTexts.subTitle("Asignación encuesta a un curso"),
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
              _buildAsignaturaDropdown(),
              AppSpaces.vertical15,

              // Fecha de encuesta
              AppTexts.softText('Fecha límite de responder encuesta'),
              AppSpaces.vertical5,
              _buildFechaField(),
              AppSpaces.vertical15,

              // Subir Listado de Estudiantes
              AppTexts.softText('Listado de estudiantes'),
              AppSpaces.vertical10,
              _buildSubirListadoButton(context),

              // Parciales
              AppTexts.softText('Notas del Parcial'),
              AppSpaces.vertical5,
              _buildParcialDropdown(),
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

  Widget _buildAsignaturaDropdown() {
    return DropdownButtonFormField<String>(
      items: const [
        DropdownMenuItem(
            value: "Realidad Nacional", child: Text("Realidad Nacional")),
        DropdownMenuItem(value: "Ética", child: Text("Ética")),
        DropdownMenuItem(
            value: "Ecuaciones Diferenciales",
            child: Text("Ecuaciones Diferenciales")),
      ],
      onChanged: (value) {},
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildFechaField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "dd-mm-yyyy",
              suffixIcon: Icon(Icons.calendar_today),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.datetime,
          ),
        ),
        AppSpaces.horizontal10,
      ],
    );
  }

  Widget _buildSubirListadoButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CargarExcelScreen(),
          ),
        );
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
      child: AppTexts.subTitle('subir listado de estudiantes'),
    );
  }


  Widget _buildParcialDropdown() {
    return DropdownButtonFormField<String>(
      items: const [
        DropdownMenuItem(value: "Parcial 1", child: Text("Parcial 1")),
        DropdownMenuItem(value: "Parcial 2", child: Text("Parcial 2")),
      ],
      onChanged: (value) {},
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildGuardarAsignacionButton() {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: const Color.fromARGB(255, 230, 38, 38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: AppTexts.subTitle('Guardar Asignación'),
    );
  }
}




class CargarExcelScreen extends StatefulWidget {
  const CargarExcelScreen({super.key});

  @override
   createState() => _CargarExcelScreenState();
}

class _CargarExcelScreenState extends State<CargarExcelScreen> {
  List<Estudiante> estudiantes = [];

  Future<void> cargarExcel() async {
    try {
      final excelService = ExcelService();
      final nuevosEstudiantes =
          await excelService.cargarEstudiantesDesdeExcel();

      if (!mounted) return; // Verifica si el widget sigue montado

      setState(() {
        estudiantes = nuevosEstudiantes;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Archivo cargado exitosamente')),
      );
    } catch (e) {
      if (!mounted) return; // Verifica si el widget sigue montado

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Excel de Estudiantes'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: cargarExcel,
            child: const Text('Subir Archivo Excel'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: estudiantes.length,
              itemBuilder: (context, index) {
                final estudiante = estudiantes[index];
                return ListTile(
                  title: Text(estudiante.nombre),
                  subtitle: Text('Cédula: ${estudiante.cedula}'),
                  trailing: Text('Promedio: ${estudiante.promedio.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
