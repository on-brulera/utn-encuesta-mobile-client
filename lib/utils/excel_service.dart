import 'dart:io';
import 'package:encuestas_utn/features/auth/domain/entities/estudiante.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class ExcelService {
  Future<List<Estudiante>> cargarEstudiantesDesdeExcel() async {
    try {
      // Seleccionar archivo
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        // Leer el archivo
        final bytes = File(result.files.single.path!).readAsBytesSync();
        final excel = Excel.decodeBytes(bytes);

        List<Estudiante> estudiantes = [];

        // Leer la primera hoja
        final sheet = excel.tables.keys.first;
        final rows = excel.tables[sheet]?.rows;

        // Procesar filas (omitimos la primera fila si tiene encabezados)
        for (var i = 1; i < (rows?.length ?? 0); i++) {
          final row = rows![i];

          final estudiante = Estudiante(
            nombre: row[0]?.value?.toString() ?? '',
            cedula: row[1]?.value?.toString() ?? '',
            nota1: double.tryParse(row[2]?.value.toString() ?? '0') ?? 0.0,
            nota2: double.tryParse(row[3]?.value.toString() ?? '0') ?? 0.0,
            promedio: double.tryParse(row[4]?.value.toString() ?? '0') ?? 0.0,
          );

          estudiantes.add(estudiante);
        }

        return estudiantes;
      } else {
        throw Exception("No se seleccionó ningún archivo.");
      }
    } catch (e) {
      throw Exception("Error al cargar el archivo Excel: $e");
    }
  }
}
