import 'package:encuestas_utn/features/auth/domain/entities/estudiante.dart';
import 'package:encuestas_utn/utils/excel_service.dart';
import 'package:flutter/material.dart';

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
                  subtitle: Text(
                      'Cédula: ${estudiante.cedula} - Nota 1: ${estudiante.nota1} - Nota 2: ${estudiante.nota2}'),
                  trailing: Text(
                      'Promedio: ${estudiante.promedio.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
